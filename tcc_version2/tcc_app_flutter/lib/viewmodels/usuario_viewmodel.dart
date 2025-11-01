import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../utils/session_manager.dart';

class UsuarioViewModel extends ChangeNotifier {
  int? usuarioId;
  String? nombreCompleto;
  String? email;
  String? token;
  bool isLoggedIn = false;

  // nuevos (opcionales)
  String? fechaNacimiento;      // "YYYY-MM-DD"
  String? sexo;                 // "M" | "F" | "O" | null
  String? diagnosticoPrevio;    // texto o null
  String? fotoPerfil;           // url/base64 opcional
  String? fechaRegistro;        // timestamp opcional

  Future<void> cargarUsuario() async {
    final session = await SessionManager.getSession();
    if (session != null) {
      usuarioId        = session['usuario_id'];
      nombreCompleto   = session['nombre_completo'];
      email            = session['email'];
      token            = session['token'];
      isLoggedIn       = session['isLoggedIn'] ?? false;

      // opcionales si existen en sesión
      fechaNacimiento  = session['fecha_nacimiento'];
      sexo             = session['sexo'];
      diagnosticoPrevio= session['diagnostico_previo'];
      fotoPerfil       = session['foto_perfil'];
      fechaRegistro    = session['fecha_registro'];

      notifyListeners();
    } else {
      isLoggedIn = false;
      notifyListeners();
    }
  }

  // Guarda todo lo que venga (por ejemplo, /auth/login o /usuario/perfil)
  Future<void> guardarUsuario(Map<String, dynamic> data) async {
    await SessionManager.saveSession(data);

    usuarioId        = data['usuario_id'];
    nombreCompleto   = data['nombre_completo'];
    email            = data['email'];
    token            = data['token'];
    isLoggedIn       = true;

    // opcionales
    fechaNacimiento  = data['fecha_nacimiento'];
    sexo             = data['sexo'];
    diagnosticoPrevio= data['diagnostico_previo'];
    fotoPerfil       = data['foto_perfil'];
    fechaRegistro    = data['fecha_registro'];

    notifyListeners();
  }

  Future<void> cerrarSesion() async {
    await SessionManager.logoutKeepData();
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> borrarSesionTotal() async {
    await SessionManager.clearSession();
    usuarioId = null;
    nombreCompleto = null;
    email = null;
    token = null;
    fechaNacimiento = null;
    sexo = null;
    diagnosticoPrevio = null;
    fotoPerfil = null;
    fechaRegistro = null;
    isLoggedIn = false;
    notifyListeners();
  }

  Future<void> actualizarPerfil() async {
  if (usuarioId == null) return;

  try {
    final response = await ApiService().fetchPerfil(usuarioId!);
    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];

      // Actualiza los valores locales con los datos del backend
      nombreCompleto = data['nombre_completo'];
      email = data['email'];
      fechaNacimiento = data['fecha_nacimiento'];
      sexo = data['sexo'];
      diagnosticoPrevio = data['diagnostico_previo'];

      notifyListeners();
    }
  } catch (e) {
    debugPrint('⚠️ Error al actualizar perfil: $e');
  }
}

}
