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

        // --- CABECERA ---
        $insertRU = $pdo->prepare("
            INSERT INTO respuestas_usuario (usuario_id, tests_id, fecha_realizacion, valido)
            VALUES (?, ?, NOW(), 1)
        ");
        $insertRU->execute([$usuario_id, $test_id]);
        $ru_id = (int)$pdo->lastInsertId();
        error_log("🟢 Nuevo registro en respuestas_usuario ID=$ru_id");

        // --- DETALLES ---
        $buscarOpcion = $pdo->prepare("
            SELECT id_opciones FROM opciones_respuesta 
            WHERE preguntas_id = ? AND codigo_op = ? LIMIT 1
        ");
        $insertDetalle = $pdo->prepare("
            INSERT INTO detalle_respuestas (ru_id, preguntas_id, or_id) VALUES (?, ?, ?)
        ");

        foreach ($respuestas as $r) {
            $preguntaId = (int)($r['preguntas_id'] ?? 0);
            $codigoOp = strtoupper(trim($r['codigo_op'] ?? ''));

            if (!$preguntaId || !$codigoOp) {
                throw new Exception("Datos de respuesta incompletos");
            }

            $buscarOpcion->execute([$preguntaId, $codigoOp]);
            $opcion = $buscarOpcion->fetch();

            if (!$opcion) {
                throw new Exception("Opción inválida para pregunta $preguntaId");
            }

            $insertDetalle->execute([$ru_id, $preguntaId, (int)$opcion['id_opciones']]);
        }

        // --- CÁLCULO GLOBAL ---
        $calc = $pdo->prepare("
            SELECT 
                SUM(CASE WHEN o.codigo_op = 'A' THEN 1 ELSE 0 END) AS total_A,
                SUM(CASE WHEN o.codigo_op = 'B' THEN 1 ELSE 0 END) AS total_B
            FROM detalle_respuestas d
            INNER JOIN opciones_respuesta o ON o.id_opciones = d.or_id
            WHERE d.ru_id = ?
        ");
        $calc->execute([$ru_id]);
        $tot = $calc->fetch(PDO::FETCH_ASSOC);

        $total = ($tot['total_A'] + $tot['total_B']) ?: 1;
        $porcentaje_A = round(($tot['total_A'] / $total) * 100, 2);
        $porcentaje_B = round(($tot['total_B'] / $total) * 100, 2);
        $estilo_id = ($porcentaje_A >= $porcentaje_B) ? 1 : 2;

        $insertRes = $pdo->prepare("
            INSERT INTO resultados_usuario (usuario_id, test_id, estilo_id, porcentaje, fecha_resultado)
            VALUES (?, ?, ?, ?, NOW())
        ");
        $insertRes->execute([$usuario_id, $test_id, $estilo_id, max($porcentaje_A, $porcentaje_B)]);
        error_log("🟢 Resultado global insertado para ru_id=$ru_id");

        // --- DIMENSIONES ---
        $dimensiones = [
            ['id' => 1, 'polo_a' => 'Activo', 'polo_b' => 'Reflexivo'],
            ['id' => 2, 'polo_a' => 'Visual', 'polo_b' => 'Verbal'],
            ['id' => 3, 'polo_a' => 'Secuencial', 'polo_b' => 'Global'],
            ['id' => 4, 'polo_a' => 'Sensorial', 'polo_b' => 'Intuitivo'],
        ];

        $insertDim = $pdo->prepare("
            INSERT INTO resultado_dimension (ru_id, dimensiones_id, polo_a, polo_b, neto, magnitud, ganador, total_pregs, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
        ");

        foreach ($dimensiones as $dim) {
            $neto = rand(-5, 5);
            $magnitud = abs($neto);
            $ganador = $neto >= 0 ? $dim['polo_a'] : $dim['polo_b'];
            $insertDim->execute([$ru_id, $dim['id'], $dim['polo_a'], $dim['polo_b'], $neto, $magnitud, $ganador, 11]);
            error_log("   ➕ Dimensión {$dim['id']} insertada ($ganador)");
        }

        $pdo->commit();
        error_log("✅ Commit completado para ru_id=$ru_id");

        json_response(true, 'Respuestas guardadas correctamente', [
            'ru_id' => $ru_id,
            'porcentajes' => ['A' => $porcentaje_A, 'B' => $porcentaje_B],
            'estilo_id' => $estilo_id
        ], 201);

    } catch (Throwable $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        error_log("❌ Error en tests/guardar: " . $e->getMessage());
        json_response(false, 'Error al guardar resultado: ' . $e->getMessage(), null, 500);
    }
});




// GET /tests/mis-tests?usuario_id=123
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
            -- resultado preferido: concat de ganadores por dimensión
            COALESCE(
                (
                  SELECT GROUP_CONCAT(rd.ganador ORDER BY rd.dimensiones_id SEPARATOR ' / ')
                  FROM resultado_dimension rd
                  WHERE rd.ru_id = ru.id_rpu
                ),
                (
                  -- fallback al resultado global si no hay filas en resultado_dimension
                  SELECT CASE r.estilo_id
                           WHEN 1 THEN 'A — Activo / Visual'
                           WHEN 2 THEN 'B — Reflexivo / Verbal'
                           ELSE NULL
                         END
                  FROM resultados_usuario r
                  WHERE r.usuario_id = ru.usuario_id
                    AND r.test_id    = ru.tests_id
                  ORDER BY r.id_resultado DESC
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

// GET /debug/rd?ru_id=XXX  ó sin parámetro para usar el último
Router::get('/debug/rd', function () {
    try {
        $pdo = get_pdo();
        $ru_id = isset($_GET['ru_id']) ? (int)$_GET['ru_id'] : 0;
        if ($ru_id <= 0) {
            $ru_id = (int)$pdo->query("SELECT MAX(id_rpu) FROM respuestas_usuario")->fetchColumn();
        }
        $n = (int)$pdo->query("SELECT COUNT(*) FROM resultado_dimension WHERE ru_id = ".(int)$ru_id)->fetchColumn();
        $rows = $pdo->query("
            SELECT id_rd, ru_id, dimensiones_id, ganador, created_at
            FROM resultado_dimension
            WHERE ru_id = ".(int)$ru_id."
            ORDER BY dimensiones_id
        ")->fetchAll(PDO::FETCH_ASSOC);

        json_response(true, "ru_id=$ru_id; filas_resultado_dimension=$n", $rows, 200);
    } catch (Throwable $e) {
        json_response(false, 'Error debug rd: ' . $e->getMessage(), null, 500);
    }
});


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
        $insertRU = $pdo->prepare('
            INSERT INTO respuestas_usuario (usuario_id, tests_id, fecha_realizacion, valido)
            VALUES (?, ?, NOW(), 1)
        ');
        $insertRU->execute([$usuario_id, $test_id]);
        $ru_id = (int)$pdo->lastInsertId();

        // Insertar detalles
        $buscarOpcion = $pdo->prepare('SELECT id_opciones, codigo_op FROM opciones_respuesta WHERE preguntas_id = ? AND codigo_op = ? LIMIT 1');
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

        // Calcular totales globales (solo A y B)
        $calc = $pdo->prepare("
            SELECT 
                SUM(CASE WHEN o.codigo_op = 'A' THEN 1 ELSE 0 END) AS total_A,
                SUM(CASE WHEN o.codigo_op = 'B' THEN 1 ELSE 0 END) AS total_B
            FROM detalle_respuestas d
            INNER JOIN opciones_respuesta o ON o.id_opciones = d.or_id
            WHERE d.ru_id = ?
        ");
        $calc->execute([$ru_id]);
        $tot = $calc->fetch(PDO::FETCH_ASSOC);

        $total = ($tot['total_A'] + $tot['total_B']) ?: 1;
        $porcentaje_A = round(($tot['total_A'] / $total) * 100, 2);
        $porcentaje_B = round(($tot['total_B'] / $total) * 100, 2);

        // Determinar estilo ganador (simple)
        $estilo_id = ($porcentaje_A >= $porcentaje_B) ? 1 : 2;

        // Guardar resultado global
        $insertRes = $pdo->prepare("
            INSERT INTO resultados_usuario (usuario_id, test_id, estilo_id, porcentaje, fecha_resultado)
            VALUES (?, ?, ?, ?, NOW())
        ");
        $insertRes->execute([$usuario_id, $test_id, $estilo_id, max($porcentaje_A, $porcentaje_B)]);

        // ======================
        // NUEVO: insertar resultados por dimensión
        // ======================
        $dimensiones = [
            ['id' => 1, 'polo_a' => 'Activo', 'polo_b' => 'Reflexivo'],
            ['id' => 2, 'polo_a' => 'Visual', 'polo_b' => 'Verbal'],
            ['id' => 3, 'polo_a' => 'Secuencial', 'polo_b' => 'Global'],
            ['id' => 4, 'polo_a' => 'Sensorial', 'polo_b' => 'Intuitivo'],
        ];

        $insertDim = $pdo->prepare("
            INSERT INTO resultado_dimension (ru_id, dimensiones_id, polo_a, polo_b, neto, magnitud, ganador, total_pregs, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())
        ");

        foreach ($dimensiones as $dim) {
            // Por simplicidad: asignamos resultados de ejemplo
            // (cuando tengas tu cálculo real, reemplazá estas variables)
            $neto = rand(-5, 5); // valor simulado
            $magnitud = abs($neto);
            $ganador = $neto > 0 ? $dim['polo_a'] : $dim['polo_b'];
            $total_pregs = 11;

            $insertDim->execute([
                $ru_id,
                $dim['id'],
                $dim['polo_a'],
                $dim['polo_b'],
                $neto,
                $magnitud,
                $ganador,
                $total_pregs
            ]);
        }

        $pdo->commit();

        $dataResultado = [
            'ru_id' => $ru_id,
            'porcentajes' => [
                'A' => $porcentaje_A,
                'B' => $porcentaje_B
            ],
            'estilo_id' => $estilo_id
        ];

        json_response(true, 'Respuestas guardadas correctamente', $dataResultado, 201);

    } catch (Throwable $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        json_response(false, 'Error al guardar resultado: ' . $e->getMessage(), null, 500);
    }
});



// GET /tests/mis-tests?usuario_id=123
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
                          AND r.test_id = ru.tests_id
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

// --- GET /tests/detalle?id_rpu=XX ---
Router::get('/tests/detalle', function() {
    $id_rpu = isset($_GET['id_rpu']) ? intval($_GET['id_rpu']) : 0;

    if ($id_rpu <= 0) {
        json_response(false, 'ID del test inválido', null, 400);
    }

    try {
        $pdo = get_pdo();

        // Campo correcto: dimensiones_id (no dimension_code)
        $sql = "SELECT 
                    rd.dimensiones_id,
                    rd.polo_a,
                    rd.polo_b,
                    rd.neto,
                    rd.ganador,
                    rd.magnitud,
                    rd.total_pregs,
                    rd.created_at
                FROM resultado_dimension rd
                WHERE rd.ru_id = ?";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$id_rpu]);
        $resultados = $stmt->fetchAll(PDO::FETCH_ASSOC);

        if (!$resultados || count($resultados) === 0) {
            json_response(false, 'No se encontraron datos del test', []);
        }

        json_response(true, 'Detalle del test obtenido correctamente', $resultados);
    } catch (Exception $e) {
        json_response(false, 'Error al obtener detalle: ' . $e->getMessage(), null, 500);
    }
});






