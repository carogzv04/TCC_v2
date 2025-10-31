<?php
require_once __DIR__ . '/../db.php';


Router::get('/tests/por-edad', function() {
    $usuario_id = isset($_GET['usuario_id']) ? (int)$_GET['usuario_id'] : null;

    if (!$usuario_id) {
        json_response(false, 'Debe enviar usuario_id', null, 400);
    }

    try {
        $pdo = get_pdo();

        // Obtener fecha de nacimiento del usuario
        $stmt = $pdo->prepare('SELECT fecha_nacimiento FROM usuarios WHERE id_usuarios = ?');
        $stmt->execute([$usuario_id]);
        $usr = $stmt->fetch();

        if (!$usr) {
            json_response(false, 'Usuario no encontrado', null, 404);
        }

        // Calcular edad
        $fn = new DateTime($usr['fecha_nacimiento']);
        $edad = (new DateTime())->diff($fn)->y;

        // Buscar test correspondiente
        $t = $pdo->prepare('SELECT id_test, test_key, test_nombre, test_descripcion 
                            FROM tests 
                            WHERE activo = 1 
                              AND :edad BETWEEN rango_edad_min AND rango_edad_max
                            ORDER BY fecha_creacion DESC 
                            LIMIT 1');
        $t->execute(['edad' => $edad]);
        $test = $t->fetch();

        if (!$test) {
            // Sin test disponible para esa edad
            json_response(true, 'No hay test disponible para esta edad.', [
                'test_id' => null,
                'test_key' => null,
                'test_nombre' => null,
                'test_descripcion' => null,
                'edad' => $edad,
                'preguntas' => []
            ]);
        }

        $test_id = (int)$test['id_test'];

        // Obtener preguntas del test
        $p = $pdo->prepare('SELECT id_preguntas, numero_pregunta, texto, media_tipo, media_url
                            FROM preguntas
                            WHERE test_id = ?
                            ORDER BY numero_pregunta ASC');
        $p->execute([$test_id]);
        $preguntas = $p->fetchAll();

        if (!$preguntas) {
            // Test sin preguntas registradas
            json_response(true, 'El test no tiene preguntas registradas.', [
                'test_id' => $test_id,
                'test_key' => $test['test_key'],
                'test_nombre' => $test['test_nombre'],
                'test_descripcion' => $test['test_descripcion'],
                'edad' => $edad,
                'preguntas' => []
            ]);
        }

        // Obtener opciones para cada pregunta
        $op = $pdo->prepare('SELECT id_opciones, preguntas_id, codigo_op, texto_op
                             FROM opciones_respuesta
                             WHERE preguntas_id = ?
                             ORDER BY id_opciones ASC');

        $preguntasConOpciones = [];
        foreach ($preguntas as $preg) {
            $op->execute([$preg['id_preguntas']]);
            $opciones = $op->fetchAll();

            $preguntasConOpciones[] = [
                'id' => (int)$preg['id_preguntas'],
                'numero_pregunta' => (int)$preg['numero_pregunta'],
                'texto' => $preg['texto'] ?? '',
                'media_tipo' => $preg['media_tipo'] ?? null,
                'media_url' => $preg['media_url'] ?? null,
                'opciones' => array_map(function ($o) {
                    return [
                        'id_opciones' => (int)$o['id_opciones'],
                        'preguntas_id' => (int)$o['preguntas_id'],
                        'codigo_op' => strtoupper($o['codigo_op'] ?? ''),
                        'texto' => $o['texto_op'] ?? ''
                    ];
                }, $opciones ?: [])
            ];
        }

        $data = [
            'test_id' => $test_id,
            'test_key' => $test['test_key'],
            'test_nombre' => $test['test_nombre'],
            'test_descripcion' => $test['test_descripcion'],
            'edad' => $edad,
            'preguntas' => $preguntasConOpciones
        ];

        json_response(true, 'Test obtenido correctamente', $data);
    } catch (Throwable $e) {
        json_response(false, 'Error al obtener test: ' . $e->getMessage(), null, 500);
    }
});


Router::post('/tests/guardar', function() {
    $body = json_decode(file_get_contents('php://input'), true);

    if (
        !$body ||
        !isset($body['usuario_id'], $body['test_id'], $body['respuestas']) ||
        !is_array($body['respuestas'])
    ) {
        json_response(false, 'Body JSON inválido', null, 400);
    }

    $usuario_id = (int)$body['usuario_id'];
    $test_id    = (int)$body['test_id'];
    $respuestas = $body['respuestas'];

    try {
        $pdo = get_pdo();
        $pdo->beginTransaction();

        // Insertar cabecera
        $insertRU = $pdo->prepare('INSERT INTO respuestas_usuario 
            (usuario_id, tests_id, fecha_realizacion, valido)
            VALUES (?, ?, NOW(), 1)');
        $insertRU->execute([$usuario_id, $test_id]);
        $ru_id = (int)$pdo->lastInsertId();

        // Insertar detalles
        $buscarOpcion = $pdo->prepare('SELECT id_opciones FROM opciones_respuesta WHERE preguntas_id = ? AND codigo_op = ? LIMIT 1');
        $insertDetalle = $pdo->prepare('INSERT INTO detalle_respuestas (ru_id, preguntas_id, or_id) VALUES (?, ?, ?)');

        foreach ($respuestas as $r) {
            $preguntaId = (int)($r['preguntas_id'] ?? 0);
            $codigoOp = strtoupper(trim($r['codigo_op'] ?? ''));

            if (!$preguntaId || !$codigoOp) {
                throw new Exception('Datos de respuesta incompletos.');
            }

            $buscarOpcion->execute([$preguntaId, $codigoOp]);
            $opcion = $buscarOpcion->fetch();

            if (!$opcion) {
                throw new Exception("Opción inválida para la pregunta $preguntaId");
            }

            $insertDetalle->execute([$ru_id, $preguntaId, (int)$opcion['id_opciones']]);
        }

        // Confirma inserciones antes de calcular
        $pdo->commit();

        $ru_id = intval($ru_id);

        $calc = $pdo->prepare("
            SELECT 
                SUM(CASE WHEN o.codigo_op = 'A' THEN 1 ELSE 0 END) AS total_A,
                SUM(CASE WHEN o.codigo_op = 'B' THEN 1 ELSE 0 END) AS total_B
            FROM detalle_respuestas AS d
            INNER JOIN opciones_respuesta AS o ON o.id_opciones = d.or_id
            WHERE d.ru_id = :ru_id
        ");
        $calc->execute(['ru_id' => $ru_id]);
        $tot = $calc->fetch(PDO::FETCH_ASSOC) ?: ['total_A' => 0, 'total_B' => 0];

        error_log("🧩 DEBUG: resultado del cálculo: " . json_encode($tot));

        $total = max(($tot['total_A'] + $tot['total_B']), 1);
        $porcentaje_A = round(($tot['total_A'] / $total) * 100, 2);
        $porcentaje_B = round(($tot['total_B'] / $total) * 100, 2);

        $estilo_id = ($porcentaje_A >= $porcentaje_B) ? 1 : 2;

        // Guardar resumen
        $insertRes = $pdo->prepare("
            INSERT INTO resultados_usuario (usuario_id, test_id, estilo_id, porcentaje, fecha_resultado)
            VALUES (?, ?, ?, ?, NOW())
        ");
        $insertRes->execute([$usuario_id, $test_id, $estilo_id, max($porcentaje_A, $porcentaje_B)]);

        $dataResultado = [
            'ru_id' => $ru_id,
            'porcentajes' => [
                'A' => $porcentaje_A,
                'B' => $porcentaje_B
            ],
            'estilo_id' => $estilo_id
        ];

        error_log("✅ totales calculados: A={$porcentaje_A} B={$porcentaje_B} estilo={$estilo_id}");

        json_response(true, 'Respuestas guardadas correctamente', $dataResultado, 201);

    } catch (Throwable $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        json_response(false, 'Error al guardar resultado: ' . $e->getMessage(), null, 500);
    }
});



Router::get('/tests/mis-tests', function() {
    $usuario_id = $_GET['usuario_id'] ?? null;

    if (!$usuario_id) {
        json_response(false, 'Parámetro usuario_id es requerido', null, 400);
    }

    try {
        $pdo = get_pdo();

        $sql = "SELECT 
                    t.id_test AS test_id,
                    t.test_nombre AS nombre_test,
                    ru.fecha_realizacion AS fecha,
                    COALESCE(re.ganador, '-') AS resultado
                FROM respuestas_usuario ru
                INNER JOIN tests t ON ru.tests_id = t.id_test
                LEFT JOIN resultado_dimension re ON re.ru_id = ru.id_rpu
                WHERE ru.usuario_id = ?
                ORDER BY ru.fecha_realizacion DESC";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([$usuario_id]);
        $tests = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (!$tests) {
            json_response(true, 'No hay tests registrados para este usuario.', []);
        }

        json_response(true, 'Tests obtenidos correctamente.', $tests);
    } catch (Throwable $e) {
        json_response(false, 'Error al obtener los tests: ' . $e->getMessage(), null, 500);
    }
});
