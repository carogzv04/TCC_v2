import 'package:flutter/foundation.dart';
import '../utils/session_manager.dart';

class UsuarioViewModel extends ChangeNotifier {
  int? usuarioId;
  String? nombreCompleto;
  String? email;
  String? token;
  bool isLoggedIn = false;

  Future<void> cargarUsuario() async {
    final session = await SessionManager.getSession();
    if (session != null) {
      usuarioId = session['usuario_id'];
      nombreCompleto = session['nombre_completo'];
      email = session['email'];
      token = session['token'];
      isLoggedIn = session['isLoggedIn'] ?? false;
      notifyListeners();
    } else {
      isLoggedIn = false;
      notifyListeners();
    }
  }


  Future<void> guardarUsuario(Map<String, dynamic> data) async {
    await SessionManager.saveSession(data);
    usuarioId = data['usuario_id'];
    nombreCompleto = data['nombre_completo'];
    email = data['email'];
    isLoggedIn = true;
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
    isLoggedIn = false;
    notifyListeners();
  }
}
