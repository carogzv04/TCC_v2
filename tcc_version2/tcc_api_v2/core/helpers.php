<?php

// Funciones globales para JSON, logs y errores

function json_response(bool $success, string $message, $data = null, int $status = 200): void {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'success' => $success,
        'message' => $message,
        'data'    => $data,
        'timestamp' => date('Y-m-d H:i:s')
    ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    exit;
}

function app_log(string $msg): void {
    $dir = __DIR__ . '/../logs';
    if (!is_dir($dir)) {
        mkdir($dir, 0775, true);
    }
    $path = $dir . '/app.log';
    $entry = '[' . date('c') . '] ' . $msg . PHP_EOL;
    @file_put_contents($path, $entry, FILE_APPEND);
}

set_exception_handler(function ($e) {
    app_log('Excepción: ' . $e->getMessage());
    if (APP_DEBUG) {
        json_response(false, 'Error del servidor', [
            'error' => $e->getMessage(),
            'trace' => $e->getTraceAsString()
        ], 500);
    } else {
        json_response(false, 'Error interno del servidor', null, 500);
    }
});
