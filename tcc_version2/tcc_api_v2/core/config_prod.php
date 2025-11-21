<?php

//Configuración para entorno de producción

define('APP_ENV', 'prod');

// Base de datos (usuario del servidor)
define('DB_HOST', '192.168.8.8');
define('DB_NAME', 'tcc_db');
define('DB_USER', 'root');     
define('DB_PASS', '');         
define('DB_CHARSET', 'utf8mb4');

header('Access-Control-Allow-Origin: http://192.168.8.8');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// Seguridad básica
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');

const APP_DEBUG = false;
