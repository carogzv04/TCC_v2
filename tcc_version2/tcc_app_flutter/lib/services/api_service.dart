import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  // =========================================
  // 🔹 Configuración base de la API
  // =========================================
  static const String baseUrl = 'http://localhost:8080/tcc_api_v2';

  // 🔹 Encabezados por defecto
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {
        'success': false,
        'message': 'Formato de respuesta inválido',
        'data': null
      };
    } catch (e) {
      debugPrint('❌ Error al decodificar respuesta: $e');
      return {
        'success': false,
        'message': 'Error al procesar la respuesta',
        'data': null
      };
    }
  }


  Future<Map<String, dynamic>> _safeRequest(
      Future<http.Response> Function() request) async {
    try {
      final response = await request().timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (e) {
      debugPrint('⏱️ Error de conexión o timeout: $e');
      return {
        'success': false,
        'message': 'Error de conexión o tiempo de espera',
        'data': null
      };
    }
  }


  Future<Map<String, dynamic>> login(String email, String password) async {
    print('🌐 Usando baseUrl: $baseUrl');
    final url = Uri.parse('$baseUrl/auth/login');
    debugPrint('📤 [LOGIN] Enviando solicitud a: $url');
    debugPrint('📦 [LOGIN] Body: ${jsonEncode({'email': email, 'password': password})}');

    try {
      final response = await http
          .post(
        url,
        headers: defaultHeaders,
        body: jsonEncode({'email': email, 'password': password}),
      )
          .timeout(const Duration(seconds: 15));

      debugPrint('📥 [LOGIN] Status: ${response.statusCode}');
      debugPrint('📄 [LOGIN] Respuesta: ${response.body}');

      return _handleResponse(response);
    } catch (e) {
      debugPrint('❌ [LOGIN] Error al conectar con el servidor: $e');
      return {
        'success': false,
        'message': 'Error de conexión o tiempo de espera',
        'data': null
      };
    }
  }

 
  Future<Map<String, dynamic>> registrarUsuario(Map<String, dynamic> body) async {
    debugPrint('📤 [REGISTRO] Body: $body');
    return _safeRequest(() => http.post(
      Uri.parse('$baseUrl/auth/registro'),
      headers: defaultHeaders,
      body: jsonEncode(body),
    ));
  }


  Future<Map<String, dynamic>> fetchPerfil(int usuarioId) async {
    debugPrint('📤 [PERFIL] Obteniendo perfil para usuarioId=$usuarioId');
    return _safeRequest(() =>
        http.get(Uri.parse('$baseUrl/usuario/perfil?usuario_id=$usuarioId')));
  }


  Future<Map<String, dynamic>> modificarPerfil(Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/usuario/modificar');
    debugPrint('📤 [MODIFICAR PERFIL] Body: $body');

    try {
      final response = await http
          .post(url, headers: defaultHeaders, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));

      debugPrint('📥 [MODIFICAR PERFIL] Status: ${response.statusCode}');
      debugPrint('📄 [MODIFICAR PERFIL] Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'] ?? false,
          'message': data['message'] ?? 'Sin mensaje',
          'data': data['data'] ?? {}
        };
      } else {
        return {
          'success': false,
          'message': 'Error ${response.statusCode}: ${response.reasonPhrase}',
          'data': null
        };
      }
    } catch (e) {
      debugPrint('❌ [MODIFICAR PERFIL] Error: $e');
      return {
        'success': false,
        'message': 'Error de conexión al servidor',
        'data': null
      };
    }
  }


  Future<Map<String, dynamic>> fetchTestPorEdad(int usuarioId) async {
    debugPrint('📤 [TEST POR EDAD] usuarioId=$usuarioId');
    return _safeRequest(() =>
        http.get(Uri.parse('$baseUrl/tests/por-edad?usuario_id=$usuarioId')));
  }


  Future<Map<String, dynamic>> enviarRespuestas(Map<String, dynamic> body) async {
    debugPrint('📤 [ENVIAR RESPUESTAS] Body: $body');
    return _safeRequest(() => http.post(
      Uri.parse('$baseUrl/tests/guardar'),
      headers: defaultHeaders,
      body: jsonEncode(body),
    ));
  }


  Future<List<Map<String, dynamic>>> fetchMisTests(int usuarioId) async {
    final url = Uri.parse('$baseUrl/tests/mis-tests?usuario_id=$usuarioId');
    debugPrint('📤 [MIS TESTS] URL: $url');

    final response = await http.get(url);

    debugPrint('📥 [MIS TESTS] Status: ${response.statusCode}');
    debugPrint('📄 [MIS TESTS] Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic> &&
          decoded['success'] == true &&
          decoded['data'] != null) {
        return List<Map<String, dynamic>>.from(decoded['data']);
      }
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchDetalleTest(int idRpu) async {
    final url = Uri.parse('$baseUrl/tests/detalle?id_rpu=$idRpu');
    debugPrint('📤 [DETALLE TEST] URL: $url');

    final response = await http.get(url);

    debugPrint('📥 [DETALLE TEST] Status: ${response.statusCode}');
    debugPrint('📄 [DETALLE TEST] Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else {
        return {
          'success': false,
          'message': 'Formato inesperado de respuesta',
          'data': []
        };
      }
    } else {
      return {
        'success': false,
        'message': 'Error ${response.statusCode}',
        'data': []
      };
    }
  }

  Future<Map<String, dynamic>> fetchRecomendaciones(int usuarioId, {int? ruId}) async {
    final qp = {
      'id_usuario': usuarioId.toString(),
      if (ruId != null) 'ru_id': ruId.toString(),
    };
    final uri = Uri.parse('$baseUrl/recomendaciones/usuario').replace(queryParameters: qp);
    final res = await http.get(uri, headers: defaultHeaders);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
