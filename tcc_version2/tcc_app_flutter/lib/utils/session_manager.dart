import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyUsuarioId = 'usuario_id';
  static const _keyNombre = 'nombre';
  static const _keyEmail = 'email';
  static const _keyIsLoggedIn = 'is_logged_in';

  // ===== GUARDAR SESIÓN =====
  static Future<void> saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUsuarioId, data['usuario_id']);
    await prefs.setString(_keyNombre, data['nombre_completo'] ?? '');
    await prefs.setString(_keyEmail, data['email'] ?? '');
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // ===== OBTENER SESIÓN =====
  static Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_keyIsLoggedIn) ?? false)) return null;

    return {
      'usuario_id': prefs.getInt(_keyUsuarioId),
      'nombre_completo': prefs.getString(_keyNombre),
      'email': prefs.getString(_keyEmail),
    };
  }

  // ===== CERRAR SESIÓN (mantener datos) =====
  static Future<void> logoutKeepData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // ===== BORRAR SESIÓN COMPLETA =====
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ===== OBTENER DATOS INDIVIDUALES =====
  static Future<int?> getUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUsuarioId);
  }

  static Future<String?> getNombre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNombre);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // ===== VERIFICAR SI HAY SESIÓN ACTIVA =====
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }
}
