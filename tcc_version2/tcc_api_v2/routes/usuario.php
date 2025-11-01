<?php
require_once __DIR__ . '/../db.php';

// === Obtener test por edad ===
Router::get('/tests/por-edad', function() {
    $usuario_id = isset($_GET['usuario_id']) ? (int)$_GET['usuario_id'] : null;
    if (!$usuario_id) json_response(false, 'Debe enviar usuario_id', null, 400);

    try {
        $pdo = get_pdo();

        $stmt = $pdo->prepare('SELECT fecha_nacimiento FROM usuarios WHERE id_usuarios = ?');
        $stmt->execute([$usuario_id]);
        $usr = $stmt->fetch();
        if (!$usr) json_response(false, 'Usuario no encontrado', null, 404);

        $fn = new DateTime($usr['fecha_nacimiento']);
        $edad = (new DateTime())->diff($fn)->y;

        $t = $pdo->prepare('SELECT id_test, test_key, test_nombre, test_descripcion 
                            FROM tests 
                            WHERE activo = 1 
                              AND :edad BETWEEN rango_edad_min AND rango_edad_max
                            ORDER BY fecha_creacion DESC 
                            LIMIT 1');
        $t->execute(['edad' => $edad]);
        $test = $t->fetch();

        if (!$test) {
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

        $p = $pdo->prepare('SELECT id_preguntas, numero_pregunta, texto, media_tipo, media_url
                            FROM preguntas WHERE test_id = ? ORDER BY numero_pregunta ASC');
        $p->execute([$test_id]);
        $preguntas = $p->fetchAll();

        $op = $pdo->prepare('SELECT id_opciones, preguntas_id, codigo_op, texto_op
                             FROM opciones_respuesta WHERE preguntas_id = ? ORDER BY id_opciones ASC');

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

        json_response(true, 'Test obtenido correctamente', [
            'test_id' => $test_id,
            'test_key' => $test['test_key'],
            'test_nombre' => $test['test_nombre'],
            'test_descripcion' => $test['test_descripcion'],
            'edad' => $edad,
            'preguntas' => $preguntasConOpciones
        ]);
    } catch (Throwable $e) {
        json_response(false, 'Error al obtener test: ' . $e->getMessage(), null, 500);
    }
});

// === Guardar respuestas ===
Router::post('/tests/guardar', function() {
    $body = json_decode(file_get_contents('php://input'), true);

    if (!$body || !isset($body['usuario_id'], $body['test_id'], $body['respuestas']) || !is_array($body['respuestas'])) {
        json_response(false, 'Body JSON inválido', null, 400);
    }

    $usuario_id = (int)$body['usuario_id'];
    $test_id    = (int)$body['test_id'];
    $respuestas = $body['respuestas'];

    try {
        $pdo = get_pdo();
        $pdo->beginTransaction();

        $insertRU = $pdo->prepare("INSERT INTO respuestas_usuario (usuario_id, tests_id, fecha_realizacion, valido)
                                   VALUES (?, ?, NOW(), 1)");
        $insertRU->execute([$usuario_id, $test_id]);
        $ru_id = (int)$pdo->lastInsertId();

        $buscarOpcion = $pdo->prepare("SELECT id_opciones FROM opciones_respuesta WHERE preguntas_id = ? AND codigo_op = ? LIMIT 1");
        $insertDetalle = $pdo->prepare("INSERT INTO detalle_respuestas (ru_id, preguntas_id, or_id) VALUES (?, ?, ?)");

        foreach ($respuestas as $r) {
            $preguntaId = (int)($r['preguntas_id'] ?? 0);
            $codigoOp = strtoupper(trim($r['codigo_op'] ?? ''));
            if (!$preguntaId || !$codigoOp) throw new Exception("Datos de respuesta incompletos");

            $buscarOpcion->execute([$preguntaId, $codigoOp]);
            $opcion = $buscarOpcion->fetch();
            if (!$opcion) throw new Exception("Opción inválida para pregunta $preguntaId");

            $insertDetalle->execute([$ru_id, $preguntaId, (int)$opcion['id_opciones']]);
        }

        // Calcular totales A y B
        $calc = $pdo->prepare("SELECT 
                SUM(CASE WHEN o.codigo_op = 'A' THEN 1 ELSE 0 END) AS total_A,
                SUM(CASE WHEN o.codigo_op = 'B' THEN 1 ELSE 0 END) AS total_B
            FROM detalle_respuestas d
            INNER JOIN opciones_respuesta o ON o.id_opciones = d.or_id
            WHERE d.ru_id = ?");
        $calc->execute([$ru_id]);
        $tot = $calc->fetch(PDO::FETCH_ASSOC);

        $total = ($tot['total_A'] + $tot['total_B']) ?: 1;
        $porcentaje_A = round(($tot['total_A'] / $total) * 100, 2);
        $porcentaje_B = round(($tot['total_B'] / $total) * 100, 2);
        $estilo_id = ($porcentaje_A >= $porcentaje_B) ? 1 : 2;

        $insertRes = $pdo->prepare("INSERT INTO resultados_usuario (usuario_id, test_id, estilo_id, porcentaje, fecha_resultado)
                                    VALUES (?, ?, ?, ?, NOW())");
        $insertRes->execute([$usuario_id, $test_id, $estilo_id, max($porcentaje_A, $porcentaje_B)]);

        $pdo->commit();

        json_response(true, 'Respuestas guardadas correctamente', [
            'ru_id' => $ru_id,
            'porcentajes' => ['A' => $porcentaje_A, 'B' => $porcentaje_B],
            'estilo_id' => $estilo_id
        ], 201);

    } catch (Throwable $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        json_response(false, 'Error al guardar resultado: ' . $e->getMessage(), null, 500);
    }
});

// === Listar tests realizados ===
Router::get('/tests/mis-tests', function () {
    $usuario_id = isset($_GET['usuario_id']) ? (int) $_GET['usuario_id'] : 0;
    if ($usuario_id <= 0) json_response(false, 'Debe enviar usuario_id', null, 400);

    try {
        $pdo = get_pdo();
        $sql = "SELECT
                    ru.id_rpu,
                    ru.usuario_id,
                    t.test_nombre AS nombre_test,
                    DATE_FORMAT(ru.fecha_realizacion, '%Y-%m-%d %H:%i:%s') AS fecha,
                    COALESCE(
                        (SELECT GROUP_CONCAT(rd.ganador ORDER BY rd.dimensiones_id SEPARATOR ' / ')
                         FROM resultado_dimension rd WHERE rd.ru_id = ru.id_rpu),
                        'Pendiente'
                    ) AS resultado
                FROM respuestas_usuario ru
                INNER JOIN tests t ON t.id_test = ru.tests_id
                WHERE ru.usuario_id = ?
                ORDER BY ru.fecha_realizacion DESC";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$usuario_id]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        json_response(true, 'Tests obtenidos correctamente', $rows, 200);
    } catch (Throwable $e) {
        json_response(false, 'Error al obtener tests: ' . $e->getMessage(), null, 500);
    }
});
