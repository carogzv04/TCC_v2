<?php

require_once __DIR__ . '/../db.php';

// --- Obtener último resultado del usuario ---
Router::get('/resultados/usuario', function() {
    $usuario_id = isset($_GET['usuario_id']) ? (int)$_GET['usuario_id'] : null;

    if (!$usuario_id) {
        json_response(false, 'Debe enviar usuario_id', null, 400);
    }

    try {
        $pdo = get_pdo();

        // Buscar último intento
        $stmt = $pdo->prepare('SELECT id_rpu, tests_id, fecha_realizacion 
                               FROM respuestas_usuario 
                               WHERE usuario_id = ? AND valido = 1
                               ORDER BY fecha_realizacion DESC LIMIT 1');
        $stmt->execute([$usuario_id]);
        $ultima = $stmt->fetch();

        if (!$ultima) {
            json_response(false, 'El usuario no tiene resultados registrados', null, 404);
        }

        $ru_id = (int)$ultima['id_rpu'];
        $test_id = (int)$ultima['tests_id'];

        // Info del test
        $t = $pdo->prepare('SELECT test_nombre, test_descripcion FROM tests WHERE id_test = ?');
        $t->execute([$test_id]);
        $test = $t->fetch();

        // Respuestas
        $r = $pdo->prepare('SELECT dr.preguntas_id, p.texto AS pregunta, o.codigo_op, o.texto_op
                            FROM detalle_respuestas dr
                            JOIN preguntas p ON dr.preguntas_id = p.id_preguntas
                            JOIN opciones_respuesta o ON dr.or_id = o.id_opciones
                            WHERE dr.ru_id = ?
                            ORDER BY p.numero_pregunta ASC');
        $r->execute([$ru_id]);
        $respuestas = $r->fetchAll();

        $data = [
            'ru_id' => $ru_id,
            'test_id' => $test_id,
            'test_nombre' => $test['test_nombre'] ?? null,
            'test_descripcion' => $test['test_descripcion'] ?? null,
            'fecha_realizacion' => $ultima['fecha_realizacion'],
            'respuestas' => array_map(function ($row) {
                return [
                    'preguntas_id' => (int)$row['preguntas_id'],
                    'pregunta' => $row['pregunta'],
                    'codigo_op' => $row['codigo_op'],
                    'texto_op' => $row['texto_op']
                ];
            }, $respuestas)
        ];

        json_response(true, 'Último resultado obtenido correctamente', $data);
    } catch (Throwable $e) {
        json_response(false, 'Error al obtener resultados: ' . $e->getMessage(), null, 500);
    }
});
