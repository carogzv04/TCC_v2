import 'dart:convert';
import 'package:http/http.dart' as http;

// Cliente HTTP del backend; centraliza llamadas, headers y manejo de respuestas.
class ApiService {
  // URL base del backend
  static const String baseUrl = 'http://186.208.144.167:8080/tcc_api_v2';

  // Headers por defecto
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Decodifica y valida la respuesta
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {
        'success': false,
        'message': 'Formato de respuesta inválido',
        'data': null,
      };
    } catch (_) {
      return {
        'success': false,
        'message': 'Error al procesar la respuesta',
        'data': null,
      };
    }
  }

  // Envoltorio con timeout y manejo de errores
  Future<Map<String, dynamic>> _safeRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request().timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } catch (_) {
      return {
        'success': false,
        'message': 'Error de conexión o tiempo de espera',
        'data': null,
      };
    }
  }

  // Login de usuario
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    return _safeRequest(
      () => http.post(
        url,
        headers: defaultHeaders,
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
  }

  // Registro de usuario
  Future<Map<String, dynamic>> registrarUsuario(
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl/auth/registro');
    return _safeRequest(
      () => http.post(url, headers: defaultHeaders, body: jsonEncode(body)),
    );
  }

  // Obtiene perfil por id
  Future<Map<String, dynamic>> fetchPerfil(int usuarioId) async {
    final url = Uri.parse('$baseUrl/usuario/perfil?usuario_id=$usuarioId');
    return _safeRequest(() => http.get(url, headers: defaultHeaders));
  }

  // Modifica perfil
  Future<Map<String, dynamic>> modificarPerfil(
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl/usuario/modificar');
    return _safeRequest(
      () => http.post(url, headers: defaultHeaders, body: jsonEncode(body)),
    );
  }

  // Lista de tests disponibles por edad
  Future<Map<String, dynamic>> fetchTestPorEdad(int usuarioId) async {
    final url = Uri.parse('$baseUrl/tests/por-edad?usuario_id=$usuarioId');
    return _safeRequest(() => http.get(url, headers: defaultHeaders));
  }

  // Envía respuestas del test
  Future<Map<String, dynamic>> enviarRespuestas(
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl/tests/guardar');
    return _safeRequest(
      () => http.post(url, headers: defaultHeaders, body: jsonEncode(body)),
    );
  }

  // Lista tests realizados por el usuario
  Future<List<Map<String, dynamic>>> fetchMisTests(int usuarioId) async {
    final url = Uri.parse('$baseUrl/tests/mis-tests?usuario_id=$usuarioId');
    final res = await _safeRequest(
      () => http.get(url, headers: defaultHeaders),
    );

    if (res['success'] == true && res['data'] is List) {
      return List<Map<String, dynamic>>.from(res['data'] as List);
    }
    return <Map<String, dynamic>>[];
  }

  // Detalle de un test por idRpu
  Future<Map<String, dynamic>> fetchDetalleTest(int idRpu) async {
    final url = Uri.parse('$baseUrl/tests/detalle?id_rpu=$idRpu');
    return _safeRequest(() => http.get(url, headers: defaultHeaders));
  }

  // Recomendaciones por usuario y opcional ruId
  Future<Map<String, dynamic>> fetchRecomendaciones(
    int usuarioId, {
    int? ruId,
  }) async {
    final qp = {
      'id_usuario': usuarioId.toString(),
      if (ruId != null) 'ru_id': ruId.toString(),
    };
    final uri = Uri.parse(
      '$baseUrl/recomendaciones/usuario',
    ).replace(queryParameters: qp);
    return _safeRequest(() => http.get(uri, headers: defaultHeaders));
  }

  Future<Map<String, dynamic>> eliminarUsuario(int usuarioId) async {
    final url = Uri.parse('$baseUrl/usuario/eliminar');

    final postBody = jsonEncode({'id_usuario': usuarioId});
    final postRes = await _safeRequest(
      () => http.post(url, headers: defaultHeaders, body: postBody),
    );
    if (postRes['success'] == true) return postRes;

    final urlQS = Uri.parse('$baseUrl/usuario/eliminar?id_usuario=$usuarioId');
    final postQSRes = await _safeRequest(
      () => http.post(urlQS, headers: defaultHeaders),
    );
    if (postQSRes['success'] == true) return postQSRes;

    final delRes = await _safeRequest(
      () => http.delete(urlQS, headers: defaultHeaders),
    );
    return delRes;
  }
}
