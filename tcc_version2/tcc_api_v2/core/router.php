<?php
// ============================================
//  core/router.php
//  Clase Router sencilla para manejar rutas REST
// ============================================

class Router {
    private static array $routes = [];

    // --- Registro de rutas ---
    public static function get(string $path, callable $handler): void {
        self::$routes['GET'][$path] = $handler;
    }

    public static function post(string $path, callable $handler): void {
        self::$routes['POST'][$path] = $handler;
    }

    public static function put(string $path, callable $handler): void {
        self::$routes['PUT'][$path] = $handler;
    }

    public static function delete(string $path, callable $handler): void {
        self::$routes['DELETE'][$path] = $handler;
    }

    // --- Ejecución del enrutamiento ---
    public static function dispatch(): void {
        $method = $_SERVER['REQUEST_METHOD'];
        $uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        $base = rtrim(dirname($_SERVER['SCRIPT_NAME']), '/');
        $path = '/' . trim(str_replace($base, '', $uri), '/');
        if ($path === '/') $path = '/';

        if (isset(self::$routes[$method][$path])) {
            try {
                call_user_func(self::$routes[$method][$path]);
            } catch (Throwable $e) {
                app_log("Error en ruta $path: " . $e->getMessage());
                json_response(false, 'Error en la ruta', ['error' => $e->getMessage()], 500);
            }
        } else {
            json_response(false, 'Ruta no encontrada', ['path' => $path], 404);
        }
    }
}
