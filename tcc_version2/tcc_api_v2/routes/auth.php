<?php
// routes/auth.php
require_once __DIR__ . '/../db.php';

// --- POST /auth/registro ---
Router::post('/auth/registro', function() {
    $body = json_decode(file_get_contents('php://input'), true);
    if (
        empty($body['nombre_completo']) ||
        empty($body['fecha_nacimiento']) ||
        empty($body['email']) ||
        empty($body['sexo']) ||
        empty($body['password'])
    ) {
        json_response(false, 'Faltan campos requeridos', null, 400);
    }

    $nombre = trim($body['nombre_completo']);
    $fecha  = trim($body['fecha_nacimiento']);
    $email  = trim($body['email']);
    $sexo   = trim($body['sexo']);
    $pass   = trim($body['password']);
    $foto   = $body['foto_perfil'] ?? null;
    $diag   = $body['diagnostico_previo'] ?? null;

    try {
        $pdo = get_pdo();

        // ¿ya existe el email?
        $chk = $pdo->prepare('SELECT 1 FROM usuarios WHERE email = ? LIMIT 1');
        $chk->execute([$email]);
        if ($chk->fetch()) {
            json_response(false, 'El correo ya está registrado', null, 409);
        }

        // Inserta usando la columna `password` en texto plano (según tu decisión)
        $ins = $pdo->prepare('INSERT INTO usuarios
            (nombre_completo, fecha_nacimiento, email, sexo, password, foto_perfil, fecha_registro, diagnostico_previo)
            VALUES (?, ?, ?, ?, ?, ?, NOW(), ?)');
        $ins->execute([$nombre, $fecha, $email, $sexo, $pass, $foto, $diag]);

        json_response(true, 'Usuario registrado correctamente', [
            'usuario_id' => (int)$pdo->lastInsertId(),
            'email'      => $email
        ], 201);
    } catch (Throwable $e) {
        json_response(false, 'Error al registrar: ' . $e->getMessage(), null, 500);
    }
});

// --- POST /auth/login ---
Router::post('/auth/login', function() {
    $body = json_decode(file_get_contents('php://input'), true);
    if (empty($body['email']) || empty($body['password'])) {
        json_response(false, 'Debe enviar email y contraseña', null, 400);
    }

    $email = trim($body['email']);
    $pass  = trim($body['password']);

    try {
        $pdo = get_pdo();
        // lee `password` texto plano
        $q = $pdo->prepare('SELECT id_usuarios, nombre_completo, fecha_nacimiento, email, sexo, foto_perfil, fecha_registro, diagnostico_previo, password
                            FROM usuarios WHERE email = ? LIMIT 1');
        $q->execute([$email]);
        $u = $q->fetch();

        if (!$u) {
            json_response(false, 'Usuario no encontrado', null, 404);
        }

        if ($u['password'] !== $pass) {
            json_response(false, 'Contraseña incorrecta', null, 401);
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
