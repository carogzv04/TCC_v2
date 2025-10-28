<?php
define('APP_ENV', 'dev');

define('DB_HOST', '127.0.0.1');
define('DB_NAME', 'tcc_db');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_CHARSET', 'utf8mb4');

if (APP_ENV === 'dev') {
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');
}

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

const APP_DEBUG = (APP_ENV === 'dev');
