<?php
require_once __DIR__ . '/../db.php';

Router::get('/recomendaciones/usuario', function() {
    $usuarioId = isset($_GET['id_usuario']) ? (int)$_GET['id_usuario'] : 0;
    $ruIdParam = isset($_GET['ru_id']) ? (int)$_GET['ru_id'] : 0;

    if (!$usuarioId) {
        json_response(false, 'Falta el parámetro id_usuario', null, 400);
    }

    try {
        $pdo = get_pdo();

        // 1) Determinar qué ru_id usar (el que viene por query o el último del usuario)
        if ($ruIdParam > 0) {
            // Validar que el ru_id pertenezca al usuario
            $val = $pdo->prepare("SELECT 1 FROM respuestas_usuario WHERE id_rpu = ? AND usuario_id = ? LIMIT 1");
            $val->execute([$ruIdParam, $usuarioId]);
            if (!$val->fetchColumn()) {
                json_response(false, 'El ru_id no pertenece al usuario', ['ru_id' => $ruIdParam], 400);
            }
            $ruId = $ruIdParam;
        } else {
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
        }

        // 2) Traer los ganadores de ese ru_id
        $d = $pdo->prepare("
            SELECT ganador
            FROM resultado_dimension
            WHERE ru_id = ?
            ORDER BY dimensiones_id ASC
        ");
        $d->execute([$ruId]);
        $dimensiones = $d->fetchAll(PDO::FETCH_COLUMN);

        if (empty($dimensiones)) {
            json_response(false, 'No se encontraron dimensiones ganadoras para este resultado', ['ru_id' => $ruId], 404);
        }

        // 3) Recomendar por polos ganadores (sin duplicados)
        $placeholders = implode(',', array_fill(0, count($dimensiones), '?'));
        $sql = "
            SELECT DISTINCT
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
        ";
        $r = $pdo->prepare($sql);
        $r->execute($dimensiones);
        $recomendaciones = $r->fetchAll(PDO::FETCH_ASSOC);

        if (empty($recomendaciones)) {
            json_response(false, 'No se encontraron recomendaciones para estas dimensiones', [
                'ru_id' => $ruId,
                'dimensiones' => $dimensiones
            ], 404);
        }

        json_response(true, 'Recomendaciones obtenidas correctamente', [
            'ru_id_usado' => $ruId,
            'dimensiones_detectadas' => $dimensiones,
            'total_recomendaciones' => count($recomendaciones),
            'recomendaciones' => $recomendaciones
        ], 200);

    } catch (Throwable $e) {
        error_log("❌ Error en /recomendaciones/usuario: " . $e->getMessage());
        json_response(false, 'Error interno al obtener recomendaciones', null, 500);
    }
});
