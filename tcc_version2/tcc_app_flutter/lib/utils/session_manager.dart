import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const _keyUsuarioId = 'usuario_id';
  static const _keyNombreCompleto = 'nombre_completo';
  static const _keyEmail = 'email';
  static const _keyIsLoggedIn = 'isLoggedIn'; 
  static const _keyToken = 'token'; 
  static const _keyFechaNac   = 'fecha_nacimiento';
  static const _keySexo       = 'sexo';
  static const _keyDiagPrev   = 'diagnostico_previo';
  static const _keyFotoPerfil = 'foto_perfil';
  static const _keyFechaReg   = 'fecha_registro';

  // ===== GUARDAR SESIÓN =====
  static Future<void> saveSession(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    // 🔹 Aseguramos que todos los valores estén bien definidos
    await prefs.setInt(_keyUsuarioId, data['usuario_id'] ?? 0);
    await prefs.setString(_keyNombreCompleto, data['nombre_completo'] ?? '');
    await prefs.setString(_keyEmail, data['email'] ?? '');
    await prefs.setBool(_keyIsLoggedIn, true);
    if (data.containsKey('token')) {
      await prefs.setString(_keyToken, data['token'] ?? '');
    }
    await prefs.setString(_keyFechaNac,   data['fecha_nacimiento'] ?? '');
    await prefs.setString(_keySexo,       data['sexo'] ?? '');
    await prefs.setString(_keyDiagPrev,   data['diagnostico_previo'] ?? '');
    await prefs.setString(_keyFotoPerfil, data['foto_perfil'] ?? '');
    await prefs.setString(_keyFechaReg,   data['fecha_registro'] ?? '');

    print('💾 [SessionManager] Sesión guardada correctamente: $data');
  }

  // ===== OBTENER SESIÓN =====
  static Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();

    final isLogged = prefs.getBool(_keyIsLoggedIn) ?? false;
    print('🔍 [SessionManager] Verificando sesión activa: $isLogged');

    if (!isLogged) return null;

    final session = {
      'usuario_id': prefs.getInt(_keyUsuarioId),
      'nombre_completo': prefs.getString(_keyNombreCompleto),
      'email': prefs.getString(_keyEmail),
      'token': prefs.getString(_keyToken),
      'isLoggedIn': isLogged,
      'fecha_nacimiento'  : prefs.getString(_keyFechaNac),
      'sexo'              : prefs.getString(_keySexo),
      'diagnostico_previo': prefs.getString(_keyDiagPrev),
      'foto_perfil'       : prefs.getString(_keyFotoPerfil),
      'fecha_registro'    : prefs.getString(_keyFechaReg),
    };

    print('📂 [SessionManager] Sesión cargada: $session');
    return session;
  }

  // ===== CERRAR SESIÓN (mantener datos) =====
  static Future<void> logoutKeepData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    print('🚪 [SessionManager] Sesión cerrada pero datos conservados');
  }

  // ===== BORRAR SESIÓN COMPLETA =====
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('🗑️ [SessionManager] Sesión eliminada completamente');
  }

  // ===== OBTENER DATOS INDIVIDUALES =====
  static Future<int?> getUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUsuarioId);
  }

  static Future<String?> getNombreCompleto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNombreCompleto);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  // ===== VERIFICAR SI HAY SESIÓN ACTIVA =====
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final logged = prefs.getBool(_keyIsLoggedIn) ?? false;
    print('🔎 [SessionManager] Estado de sesión actual: $logged');
    return logged;
  }
}
