<?php
// ============================================
//  routes/tests.php
//  Obtener test según edad, guardar respuestas y listar tests realizados
// ============================================

require_once __DIR__ . '/../db.php';


// --- Obtener test según edad ---
Router::get('/tests/por-edad', function() {
    $usuario_id = isset($_GET['usuario_id']) ? (int)$_GET['usuario_id'] : null;

    if (!$usuario_id) {
        json_response(false, 'Debe enviar usuario_id', null, 400);
    }

    try {
        $pdo = get_pdo();

        // Obtener fecha de nacimiento
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
                            ORDER BY fecha_creacion DESC LIMIT 1');
        $t->execute(['edad' => $edad]);
        $test = $t->fetch();

        if (!$test) {
            json_response(false, 'No hay test disponible para esta edad', null, 404);
        }

        $test_id = (int)$test['id_test'];

        // Preguntas
        $p = $pdo->prepare('SELECT id_preguntas, numero_pregunta, texto, media_tipo, media_url
                            FROM preguntas
                            WHERE test_id = ?
                            ORDER BY numero_pregunta ASC');
        $p->execute([$test_id]);
        $preguntas = $p->fetchAll();

        if (!$preguntas) {
            json_response(false, 'El test no tiene preguntas registradas', null, 404);
        }

        // Opciones
        $op = $pdo->prepare('SELECT id_opciones, preguntas_id, codigo_op, texto_op
                             FROM opciones_respuesta
                             WHERE preguntas_id = ?
                             ORDER BY id_opciones ASC');

        $preguntasConOpciones = [];
        foreach ($preguntas as $preg) {
            $op->execute([$preg['id_preguntas']]);
            $opciones = $op->fetchAll();

            $preguntasConOpciones[] = [
                'id_preguntas' => (int)$preg['id_preguntas'],
                'numero_pregunta' => (int)$preg['numero_pregunta'],
                'texto' => $preg['texto'],
                'media_tipo' => $preg['media_tipo'],
                'media_url' => $preg['media_url'],
                'opciones' => array_map(function ($o) {
                    return [
                        'id_opciones' => (int)$o['id_opciones'],
                        'preguntas_id' => (int)$o['preguntas_id'],
                        'codigo_op' => strtoupper($o['codigo_op']),
                        'texto_op' => $o['texto_op']
                    ];
                }, $opciones)
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


// --- Guardar respuestas de test ---
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
            $preguntaId = (int)$r['preguntas_id'];
            $codigoOp = strtoupper(trim($r['codigo_op']));

            $buscarOpcion->execute([$preguntaId, $codigoOp]);
            $opcion = $buscarOpcion->fetch();

            if (!$opcion) {
                throw new Exception("Opción inválida para la pregunta $preguntaId");
            }

            $insertDetalle->execute([$ru_id, $preguntaId, (int)$opcion['id_opciones']]);
        }

        $pdo->commit();
        json_response(true, 'Respuestas guardadas correctamente', ['ru_id' => $ru_id], 201);
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
