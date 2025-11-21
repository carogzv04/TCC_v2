import 'package:shared_preferences/shared_preferences.dart';

class TerminosService {
  static const String key = "terminos_aceptados";

  static Future<bool> usuarioAcepto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static Future<void> guardarAceptado() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  static Future<void> borrarAceptado() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
