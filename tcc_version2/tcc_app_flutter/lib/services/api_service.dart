import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8080/tcc_api_v2';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  // Metodo interno para manejar errores y formato estándar
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'success': false, 'message': 'Formato de respuesta inválido', 'data': null};
    } catch (e) {
      return {'success': false, 'message': 'Error al procesar la respuesta', 'data': null};
    }
  }

  // Metodo interno para manejar excepciones de red
  Future<Map<String, dynamic>> _safeRequest(Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión o tiempo de espera', 'data': null};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    return jsonDecode(response.body);
  }

  // ===== REGISTRO =====
  Future<Map<String, dynamic>> registrarUsuario(Map<String, dynamic> body) async {
    return _safeRequest(() => http.post(
      Uri.parse('$baseUrl/auth/registro'),
      headers: headers,
      body: jsonEncode(body),
    ));
  }

  // ===== PERFIL =====
  Future<Map<String, dynamic>> fetchPerfil(int usuarioId) async {
    return _safeRequest(() => http.get(
      Uri.parse('$baseUrl/usuario/perfil?usuario_id=$usuarioId'),
    ));
  }

  // ===== MODIFICAR PERFIL =====
  Future<Map<String, dynamic>> modificarPerfil(Map<String, dynamic> body) async {
    return _safeRequest(() => http.post(
      Uri.parse('$baseUrl/usuario/modificar'),
      headers: headers,
      body: jsonEncode(body),
    ));
  }

  // ===== TEST POR EDAD =====
  Future<Map<String, dynamic>> fetchTestPorEdad(int usuarioId) async {
    return _safeRequest(() => http.get(
      Uri.parse('$baseUrl/tests/por-edad?usuario_id=$usuarioId'),
    ));
  }

  // ===== ENVIAR RESPUESTAS =====
  Future<Map<String, dynamic>> enviarRespuestas(Map<String, dynamic> body) async {
    return _safeRequest(() => http.post(
      Uri.parse('$baseUrl/tests/guardar'),
      headers: headers,
      body: jsonEncode(body),
    ));
  }
}
