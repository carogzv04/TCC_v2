<?php
// Routes/auth.php
require_once __DIR__ . '/../db.php';

// POST /auth/registro 
Router::post('/auth/registro', function() {
    $body = json_decode(file_get_contents('php://input'), true);
    if (
        empty($body['nombre_completo']) ||
        empty($body['fecha_nacimiento']) ||
        empty($body['email']) ||
        empty($body['password'])
    ) {
        json_response(false, 'Faltan campos requeridos', null, 400);
    }

    $nombre = trim($body['nombre_completo']);
    $fecha  = trim($body['fecha_nacimiento']);
    $email  = trim($body['email']);
    $sexo   = $body['sexo'] ?? null;
    $pass   = trim($body['password']);
    $foto   = $body['foto_perfil'] ?? null;
    $diag   = $body['diagnostico_previo'] ?? null;

    try {
        $pdo = get_pdo();

        // Verificar si el correo ya existe
        $chk = $pdo->prepare('SELECT 1 FROM usuarios WHERE email = ? LIMIT 1');
        $chk->execute([$email]);
        if ($chk->fetch()) {
            json_response(false, 'El correo ya está registrado', null, 409);
        }

        // Generar hash seguro
        $hash = password_hash($pass, PASSWORD_DEFAULT);

        // Insertar nuevo usuario
        $ins = $pdo->prepare('INSERT INTO usuarios
            (nombre_completo, fecha_nacimiento, email, password_hash, foto_perfil, fecha_registro)
            VALUES (?, ?, ?, ?, ?, NOW())');
        $ins->execute([$nombre, $fecha, $email, $hash, $foto]);

        $usuarioId = (int)$pdo->lastInsertId();

        if ($sexo !== null || $diag !== null) {
            $insExtra = $pdo->prepare('INSERT INTO usuario_extra
                (usuario_id, sexo, diagnostico_previo)
                VALUES (?, ?, ?)');
            $insExtra->execute([$usuarioId, $sexo, $diag]);
        }

        json_response(true, 'Usuario registrado correctamente', [
            'usuario_id' => $usuarioId,
            'email'      => $email
        ], 201);

    } catch (Throwable $e) {
        json_response(false, 'Error al registrar: ' . $e->getMessage(), null, 500);
    }
});

// POST /auth/login 
Router::post('/auth/login', function() {
    $body = json_decode(file_get_contents('php://input'), true);
    if (empty($body['email']) || empty($body['password'])) {
        json_response(false, 'Debe enviar email y contraseña', null, 400);
    }

    $email = trim($body['email']);
    $pass  = trim($body['password']);

    try {
        $pdo = get_pdo();

        $q = $pdo->prepare('SELECT 
                                u.id_usuarios,
                                u.nombre_completo,
                                u.fecha_nacimiento,
                                u.email,
                                x.sexo,
                                u.foto_perfil,
                                u.fecha_registro,
                                x.diagnostico_previo,
                                u.password_hash
                            FROM usuarios u
                            LEFT JOIN usuario_extra x
                              ON x.usuario_id = u.id_usuarios
                            WHERE u.email = ? 
                            LIMIT 1');
        $q->execute([$email]);
        $u = $q->fetch();

        if (!$u) {
            json_response(false, 'Usuario no encontrado', null, 404);
        }

        // Verificar hash
        if (empty($u['password_hash']) || !password_verify($pass, $u['password_hash'])) {
            json_response(false, 'Credenciales inválidas', null, 401);
        }

        json_response(true, 'Inicio de sesión correcto', [
            'usuario_id'         => (int)$u['id_usuarios'],
            'nombre_completo'    => $u['nombre_completo'],
            'fecha_nacimiento'   => $u['fecha_nacimiento'],
            'email'              => $u['email'],
            'sexo'               => $u['sexo'],
            'foto_perfil'        => $u['foto_perfil'],
            'fecha_registro'     => $u['fecha_registro'],
            'diagnostico_previo' => $u['diagnostico_previo']
        ]);

    } catch (Throwable $e) {
        json_response(false, 'Error al iniciar sesión: ' . $e->getMessage(), null, 500);
    }
});
