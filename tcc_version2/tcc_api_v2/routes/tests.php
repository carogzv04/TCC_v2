<?php
require_once __DIR__ . '/../db.php';

error_reporting(E_ALL);
ini_set('display_errors', 1);

/**
 * GET /tests/por-edad?usuario_id=XX
 * Devuelve el test vigente para la edad del usuario con sus preguntas y opciones.
 */
Router::get('/tests/por-edad', function () {
    $usuario_id = isset($_GET['usuario_id']) ? (int) $_GET['usuario_id'] : null;

    if (!$usuario_id) {
        json_response(false, 'Debe enviar usuario_id', null, 400);
    }

    try {
        $pdo = get_pdo();

        // Fecha de nacimiento del usuario
        $stmt = $pdo->prepare('SELECT fecha_nacimiento FROM usuarios WHERE id_usuarios = ?');
        $stmt->execute([$usuario_id]);
        $usr = $stmt->fetch();

        if (!$usr) {
            json_response(false, 'Usuario no encontrado', null, 404);
        }

        // Calcular edad
        $fn   = new DateTime($usr['fecha_nacimiento']);
        $edad = (new DateTime())->diff($fn)->y;

        // Test que aplica para la edad
        $t = $pdo->prepare('
            SELECT id_test, test_key, test_nombre, test_descripcion
            FROM tests
            WHERE activo = 1
              AND :edad BETWEEN rango_edad_min AND rango_edad_max
            ORDER BY fecha_creacion DESC
            LIMIT 1
        ');
        $t->execute(['edad' => $edad]);
        $test = $t->fetch();

        if (!$test) {
            json_response(true, 'No hay test disponible para esta edad.', [
                'test_id'          => null,
                'test_key'         => null,
                'test_nombre'      => null,
                'test_descripcion' => null,
                'edad'             => $edad,
                'preguntas'        => [],
            ]);
        }

        $test_id = (int) $test['id_test'];

        // Preguntas del test
        $p = $pdo->prepare('
            SELECT id_preguntas, numero_pregunta, texto, media_tipo, media_url
            FROM preguntas
            WHERE test_id = ?
            ORDER BY numero_pregunta ASC
        ');
        $p->execute([$test_id]);
        $preguntas = $p->fetchAll();

        if (!$preguntas) {
            json_response(true, 'El test no tiene preguntas registradas.', [
                'test_id'          => $test_id,
                'test_key'         => $test['test_key'],
                'test_nombre'      => $test['test_nombre'],
                'test_descripcion' => $test['test_descripcion'],
                'edad'             => $edad,
                'preguntas'        => [],
            ]);
        }

        // Opciones por pregunta
        $op = $pdo->prepare('
            SELECT id_opciones, preguntas_id, codigo_op, texto_op
            FROM opciones_respuesta
            WHERE preguntas_id = ?
            ORDER BY id_opciones ASC
        ');

        $preguntasConOpciones = [];
        foreach ($preguntas as $preg) {
            $op->execute([$preg['id_preguntas']]);
            $opciones = $op->fetchAll();

            $preguntasConOpciones[] = [
                'id'              => (int) $preg['id_preguntas'],
                'numero_pregunta' => (int) $preg['numero_pregunta'],
                'texto'           => $preg['texto'] ?? '',
                'media_tipo'      => $preg['media_tipo'] ?? null,
                'media_url'       => $preg['media_url'] ?? null,
                'opciones'        => array_map(function ($o) {
                    return [
                        'id_opciones'  => (int) $o['id_opciones'],
                        'preguntas_id' => (int) $o['preguntas_id'],
                        'codigo_op'    => strtoupper($o['codigo_op'] ?? ''),
                        'texto'        => $o['texto_op'] ?? '',
                    ];
                }, $opciones ?: []),
            ];
        }

        $data = [
            'test_id'          => $test_id,
            'test_key'         => $test['test_key'],
            'test_nombre'      => $test['test_nombre'],
            'test_descripcion' => $test['test_descripcion'],
            'edad'             => $edad,
            'preguntas'        => $preguntasConOpciones,
        ];

        json_response(true, 'Test obtenido correctamente', $data);
    } catch (Throwable $e) {
        json_response(false, 'Error al obtener test: ' . $e->getMessage(), null, 500);
    }
});

/**
 * POST /tests/guardar
 * Body JSON: { usuario_id, test_id, respuestas: [{ preguntas_id, codigo_op }, ...] }
 * Inserta respuestas, calcula resultados por dimensión Felder–Silverman y resultado global.
 */
Router::post('/tests/guardar', function () {
    $body = json_decode(file_get_contents('php://input'), true);

    if (
        !$body ||
        !isset($body['usuario_id'], $body['test_id'], $body['respuestas']) ||
        !is_array($body['respuestas'])
    ) {
        json_response(false, 'Body JSON inválido', null, 400);
    }

    $usuario_id = (int) $body['usuario_id'];
    $test_id    = (int) $body['test_id'];
    $respuestas = $body['respuestas'];

    try {
        $pdo = get_pdo();
        $pdo->beginTransaction();

        // Cabecera: respuestas_usuario
        $insertRU = $pdo->prepare('
            INSERT INTO respuestas_usuario (usuario_id, tests_id, fecha_realizacion, valido)
            VALUES (?, ?, NOW(), 1)
        ');
        $insertRU->execute([$usuario_id, $test_id]);
        $ru_id = (int) $pdo->lastInsertId();

        // Detalles: detalle_respuestas
        $buscarOpcion = $pdo->prepare('
            SELECT id_opciones
            FROM opciones_respuesta
            WHERE preguntas_id = ? AND codigo_op = ?
            LIMIT 1
        ');
        $insertDetalle = $pdo->prepare('
            INSERT INTO detalle_respuestas (ru_id, preguntas_id, or_id)
            VALUES (?, ?, ?)
        ');

        foreach ($respuestas as $r) {
            $preguntaId = (int) ($r['preguntas_id'] ?? 0);
            $codigoOp   = strtoupper(trim($r['codigo_op'] ?? ''));

            if (!$preguntaId || !$codigoOp) {
                throw new Exception('Datos de respuesta incompletos.');
            }

            $buscarOpcion->execute([$preguntaId, $codigoOp]);
            $opcion = $buscarOpcion->fetch();

            if (!$opcion) {
                throw new Exception("Opción inválida para la pregunta $preguntaId");
            }

            $insertDetalle->execute([$ru_id, $preguntaId, (int) $opcion['id_opciones']]);
        }

        // Cálculo por dimensión Felder–Silverman (A/B por pregunta)
        $calcDim = $pdo->prepare('
            SELECT 
                p.dimension_id,
                d.nombre AS nombre_dimension,
                d.id_dimension,
                SUM(CASE WHEN o.codigo_op = \'A\' THEN 1 ELSE 0 END) AS total_A,
                SUM(CASE WHEN o.codigo_op = \'B\' THEN 1 ELSE 0 END) AS total_B,
                COUNT(*) AS total_pregs
            FROM detalle_respuestas dr
            INNER JOIN opciones_respuesta o ON o.id_opciones = dr.or_id
            INNER JOIN preguntas p         ON p.id_preguntas  = dr.preguntas_id
            INNER JOIN dimensiones_fs d    ON d.id_dimension  = p.dimension_id
            WHERE dr.ru_id = ?
            GROUP BY p.dimension_id, d.nombre, d.id_dimension
            ORDER BY d.id_dimension
        ');
        $calcDim->execute([$ru_id]);
        $dimensiones = $calcDim->fetchAll(PDO::FETCH_ASSOC);

        if (!$dimensiones) {
            throw new Exception('No se encontraron resultados por dimensión.');
        }

        // Procesamiento por dimensión
        $dataDimensiones  = [];
        $sumPorcentajes   = 0;
        $contadorDim      = 0;
        $mayorPorcentaje  = 0;
        $estiloDominante  = '';

        $insertDim = $pdo->prepare('
            INSERT INTO resultado_dimension
                (ru_id, dimensiones_id, polo_a, polo_b, neto, magnitud, ganador, total_pregs, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
        ');

        foreach ($dimensiones as $dim) {
            $totalA     = (int) $dim['total_A'];
            $totalB     = (int) $dim['total_B'];
            $totalPregs = max((int) $dim['total_pregs'], 1);

            $porcA = round(($totalA / $totalPregs) * 100, 2);
            $porcB = round(($totalB / $totalPregs) * 100, 2);

            // Polos: intentamos partir por EN DASH o HYPHEN
            $nombreDim = $dim['nombre_dimension'] ?? '';
            $partes    = preg_split('/\s*[–-]\s*/u', $nombreDim, 2);
            $poloA     = trim($partes[0] ?? 'PoloA');
            $poloB     = trim($partes[1] ?? 'PoloB');

            // Para promedio global y estilo dominante
            $maxDim = max($porcA, $porcB);
            $sumPorcentajes += $maxDim;
            $contadorDim++;

            if ($maxDim > $mayorPorcentaje) {
                $mayorPorcentaje = $maxDim;
                $estiloDominante = ($porcA >= $porcB) ? $poloA : $poloB;
            }

            $dataDimensiones[] = [
                'nombre'                   => $nombreDim,
                strtolower($poloA)         => $porcA,
                strtolower($poloB)         => $porcB,
            ];

            // Persistir resultado por dimensión
            $neto     = $totalA - $totalB;
            $magnitud = abs($neto);
            $ganador  = ($neto >= 0) ? $poloA : $poloB;

            $insertDim->execute([
                $ru_id,
                (int) $dim['id_dimension'],
                $poloA,
                $poloB,
                $neto,
                $magnitud,
                $ganador,
                $totalPregs,
            ]);
        }

        // Porcentaje promedio global
        $porcentajeTotal = round($sumPorcentajes / max($contadorDim, 1), 2);

        // Resultado global (sin estilo_id definido por ahora)
        $insertRes = $pdo->prepare('
            INSERT INTO resultados_usuario (usuario_id, test_id, estilo_id, porcentaje, fecha_resultado)
            VALUES (?, ?, NULL, ?, NOW())
        ');
        $insertRes->execute([$usuario_id, $test_id, $porcentajeTotal]);

        $pdo->commit();

        $dataResultado = [
            'ru_id'             => $ru_id,
            'dimensiones'       => $dataDimensiones,
            'estilo_dominante'  => $estiloDominante,
            'porcentaje_total'  => $porcentajeTotal,
        ];

        json_response(true, 'Respuestas guardadas correctamente', $dataResultado, 201);
    } catch (Throwable $e) {
        if (isset($pdo) && $pdo->inTransaction()) {
            $pdo->rollBack();
        }
        json_response(false, 'Error al guardar resultado: ' . $e->getMessage(), null, 500);
    }
});

/**
 * GET /tests/mis-tests?usuario_id=XX
 * Lista pruebas realizadas por el usuario con un resumen de resultado.
 */
Router::get('/tests/mis-tests', function () {
    $usuario_id = isset($_GET['usuario_id']) ? (int) $_GET['usuario_id'] : 0;
    if ($usuario_id <= 0) {
        json_response(false, 'Debe enviar usuario_id', null, 400);
    }

    try {
        $pdo = get_pdo();

        $sql = "
            SELECT
                ru.id_rpu,
                ru.usuario_id,
                t.test_nombre AS nombre_test,
                DATE_FORMAT(ru.fecha_realizacion, '%Y-%m-%d %H:%i:%s') AS fecha,
                COALESCE(
                    (
                        SELECT GROUP_CONCAT(rd.ganador ORDER BY rd.dimensiones_id SEPARATOR ' / ')
                        FROM resultado_dimension rd
                        WHERE rd.ru_id = ru.id_rpu
                    ),
                    (
                        SELECT CONCAT(
                            CASE r.estilo_id
                                WHEN 1 THEN 'A — Activo / Visual'
                                WHEN 2 THEN 'B — Reflexivo / Verbal'
                                ELSE 'Indefinido'
                            END,
                            ' (', r.porcentaje, '%)'
                        )
                        FROM resultados_usuario r
                        WHERE r.usuario_id = ru.usuario_id
                          AND r.test_id     = ru.tests_id
                        ORDER BY r.fecha_resultado DESC
                        LIMIT 1
                    ),
                    'Pendiente'
                ) AS resultado
            FROM respuestas_usuario ru
            INNER JOIN tests t ON t.id_test = ru.tests_id
            WHERE ru.usuario_id = ?
            ORDER BY ru.fecha_realizacion DESC
        ";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([$usuario_id]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        json_response(true, 'Tests obtenidos correctamente', $rows, 200);
    } catch (Throwable $e) {
        json_response(false, 'Error al obtener tests: ' . $e->getMessage(), null, 500);
    }
});

/**
 * GET /tests/detalle?id_rpu=XX
 * Devuelve detalle por dimensión para un resultado (ru_id).
 */
Router::get('/tests/detalle', function () {
    $id_rpu = isset($_GET['id_rpu']) ? (int) $_GET['id_rpu'] : 0;

    if ($id_rpu <= 0) {
        json_response(false, 'ID del test inválido', null, 400);
    }

    try {
        $pdo = get_pdo();

        $sql = "
            SELECT 
                rd.dimensiones_id,
                rd.polo_a,
                rd.polo_b,
                rd.neto,
                rd.ganador,
                rd.magnitud,
                rd.total_pregs,
                rd.created_at
            FROM resultado_dimension rd
            WHERE rd.ru_id = ?
            ORDER BY rd.dimensiones_id
        ";

        $stmt = $pdo->prepare($sql);
        $stmt->execute([$id_rpu]);
        $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (!$resultados) {
            json_response(false, 'No se encontraron datos del test', []);
        }

        json_response(true, 'Detalle del test obtenido correctamente', $resultados);
    } catch (Throwable $e) {
        json_response(false, 'Error al obtener detalle: ' . $e->getMessage(), null, 500);
    }
});

/**
 * GET /debug/rd?ru_id=XX
 * Utilidad para depurar filas en resultado_dimension.
 */
Router::get('/debug/rd', function () {
    try {
        $pdo  = get_pdo();
        $ru_id = isset($_GET['ru_id']) ? (int) $_GET['ru_id'] : 0;

        if ($ru_id <= 0) {
            $ru_id = (int) $pdo->query('SELECT MAX(id_rpu) FROM respuestas_usuario')->fetchColumn();
        }

        $n = (int) $pdo->query('SELECT COUNT(*) FROM resultado_dimension WHERE ru_id = ' . (int) $ru_id)->fetchColumn();

        $rows = $pdo->query("
            SELECT id_rd, ru_id, dimensiones_id, ganador, created_at
            FROM resultado_dimension
            WHERE ru_id = " . (int) $ru_id . "
            ORDER BY dimensiones_id
        ")->fetchAll(PDO::FETCH_ASSOC);

        json_response(true, "ru_id=$ru_id; filas_resultado_dimension=$n", $rows, 200);
    } catch (Throwable $e) {
        json_response(false, 'Error debug rd: ' . $e->getMessage(), null, 500);
    }
});
