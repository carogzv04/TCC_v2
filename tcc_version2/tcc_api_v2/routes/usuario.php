<?php
// ============================================
//  routes/usuario.php
//  Perfil y modificación del usuario
// ============================================

require_once __DIR__ . '/../db.php';

// --- Obtener perfil ---
Router::get('/usuario/perfil', function() {
    $usuario_id = isset($_GET['usuario_id']) ? (int)$_GET['usuario_id'] : null;
    $email      = isset($_GET['email']) ? trim($_GET['email']) : null;

    if (!$usuario_id && !$email) {
        json_response(false, 'Debe enviar usuario_id o email', null, 400);
    }

    try {
        $pdo = get_pdo();

        if ($usuario_id) {
            $stmt = $pdo->prepare('SELECT id_usuarios, nombre_completo, fecha_nacimiento, email, sexo, foto_perfil, fecha_registro, diagnostico_previo 
                                   FROM usuarios WHERE id_usuarios = ? LIMIT 1');
            $stmt->execute([$usuario_id]);
        } else {
            $stmt = $pdo->prepare('SELECT id_usuarios, nombre_completo, fecha_nacimiento, email, sexo, foto_perfil, fecha_registro, diagnostico_previo 
                                   FROM usuarios WHERE email = ? LIMIT 1');
            $stmt->execute([$email]);
        }

        $user = $stmt->fetch();

        if (!$user) {
            json_response(false, 'Usuario no encontrado', null, 404);
        }

        json_response(true, 'Perfil obtenido correctamente', [
            'usuario_id' => (int)$user['id_usuarios'],
            'nombre_completo' => $user['nombre_completo'],
            'fecha_nacimiento' => $user['fecha_nacimiento'],
            'email' => $user['email'],
            'sexo' => $user['sexo'],
            'foto_perfil' => $user['foto_perfil'],
            'fecha_registro' => $user['fecha_registro'],
            'diagnostico_previo' => $user['diagnostico_previo']
        ]);
    } catch (Throwable $e) {
        json_response(false, 'Error al obtener perfil: ' . $e->getMessage(), null, 500);
    }
});


// --- Modificar perfil ---
Router::post('/usuario/modificar', function() {
    $body = json_decode(file_get_contents('php://input'), true);

    if (empty($body['usuario_id'])) {
        json_response(false, 'Debe enviar usuario_id', null, 400);
    }

    $usuario_id = (int)$body['usuario_id'];
    $nombre = $body['nombre_completo'] ?? null;
    $sexo = $body['sexo'] ?? null;
    $foto = $body['foto_perfil'] ?? null;
    $diagnostico = $body['diagnostico_previo'] ?? null;

    try {
        $pdo = get_pdo();

        $stmt = $pdo->prepare('UPDATE usuarios 
                               SET nombre_completo = COALESCE(?, nombre_completo),
                                   sexo = COALESCE(?, sexo),
                                   foto_perfil = COALESCE(?, foto_perfil),
                                   diagnostico_previo = COALESCE(?, diagnostico_previo)
                               WHERE id_usuarios = ?');
        $stmt->execute([$nombre, $sexo, $foto, $diagnostico, $usuario_id]);

        if ($stmt->rowCount() === 0) {
            json_response(false, 'No se realizaron cambios o usuario inexistente', null, 404);
        }

        json_response(true, 'Perfil actualizado correctamente', ['usuario_id' => $usuario_id], 200);
    } catch (Throwable $e) {
        json_response(false, 'Error al actualizar perfil: ' . $e->getMessage(), null, 500);
    }
});
