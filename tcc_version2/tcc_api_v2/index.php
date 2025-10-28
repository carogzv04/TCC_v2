<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// ---- Configuración global ----
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/core/helpers.php';
require_once __DIR__ . '/core/router.php';

// ---- Definición de rutas ----
Router::get('/', function() {
    json_response(true, 'API TCC Caro en funcionamiento', [
        'server_time' => date('Y-m-d H:i:s'),
        'version' => '2.0-modular',
        'routes' => [
            '/auth/login'           => 'POST - Inicia sesión de usuario',
            '/auth/registro'        => 'POST - Registra un nuevo usuario',
            '/usuario/perfil'       => 'GET - Obtiene perfil',
            '/usuario/modificar'    => 'POST - Modifica perfil',
            '/tests/por-edad'       => 'GET - Devuelve test según edad',
            '/tests/guardar'        => 'POST - Guarda respuestas de test',
            '/resultados/usuario'   => 'GET - Devuelve último resultado'
        ]
    ]);
});

// Cargar módulos de rutas
require_once __DIR__ . '/routes/auth.php';
require_once __DIR__ . '/routes/usuario.php';
require_once __DIR__ . '/routes/tests.php';
require_once __DIR__ . '/routes/resultados.php';

// ---- Ejecutar enrutamiento ----
Router::dispatch();
