<?php

require_once __DIR__ . '/../db.php';


Router::get('/recomendaciones/usuario', function() {
    $usuarioId = isset($_GET['id_usuario']) ? (int)$_GET['id_usuario'] : 0;

    if (!$usuarioId) {
        json_response(false, 'Falta el parámetro id_usuario', null, 400);
    }

    try {
        $pdo = get_pdo();

        $q = $pdo->prepare("
            SELECT ru.id_rpu
            FROM respuestas_usuario ru
            WHERE ru.usuario_id = ?
            ORDER BY ru.fecha_realizacion DESC
            LIMIT 1
        ");
        $q->execute([$usuarioId]);
        $ultima = $q->fetch();

        if (!$ultima) {
            json_response(false, 'El usuario no tiene resultados registrados', null, 404);
        }

        $ruId = (int)$ultima['id_rpu'];

        $d = $pdo->prepare("
            SELECT ganador
            FROM resultado_dimension
            WHERE ru_id = ?
        ");
        $d->execute([$ruId]);
        $dimensiones = $d->fetchAll(PDO::FETCH_COLUMN);

        if (empty($dimensiones)) {
            json_response(false, 'No se encontraron dimensiones ganadoras para este resultado', null, 404);
        }

        $placeholders = implode(',', array_fill(0, count($dimensiones), '?'));
        $r = $pdo->prepare("
            SELECT 
                r.id_recs,
                r.contenido,
                r.polo,
                r.recurso_url,
                e.nombre AS estilo_nombre,
                e.descripcion AS estilo_descripcion
            FROM recomendaciones r
            INNER JOIN estilos_aprendizaje e ON e.id_ea = r.estilo_id
            WHERE r.polo IN ($placeholders)
            ORDER BY r.id_recs ASC
        ");
        $r->execute($dimensiones);
        $recomendaciones = $r->fetchAll(PDO::FETCH_ASSOC);

        if (empty($recomendaciones)) {
            json_response(false, 'No se encontraron recomendaciones para estas dimensiones', null, 404);
        }

        $data = [
            'dimensiones_detectadas' => $dimensiones,
            'total_recomendaciones' => count($recomendaciones),
            'recomendaciones' => $recomendaciones
        ];

        json_response(true, 'Recomendaciones obtenidas correctamente', $data, 200);

    } catch (Throwable $e) {
        error_log("❌ Error en /recomendaciones/usuario: " . $e->getMessage());
        json_response(false, 'Error interno al obtener recomendaciones', null, 500);
    }
});
