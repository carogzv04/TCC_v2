import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class TestViewModel extends ChangeNotifier {
  // Lista de preguntas (cada una con sus opciones)
  List<Map<String, dynamic>> preguntas = [];

  // Lista de tests ya realizados por el usuario
  List<Map<String, dynamic>> testsRealizados = [];

  // Respuestas seleccionadas: {id_pregunta: codigo_op}
  Map<int, String> respuestasSeleccionadas = {};

  // ===== Cargar preguntas desde API =====
  Future<void> cargarPreguntasDesdeApi(List<dynamic> data) async {
    print('🧠 Cargando preguntas desde API...');
    preguntas = [];

    for (var i = 0; i < data.length; i++) {
      final elemento = data[i];
      if (elemento is Map<String, dynamic>) {
        preguntas.add({
          'id': elemento['id'],
          'texto': elemento['texto'],
          'opciones': elemento['opciones'] is List
              ? List<Map<String, dynamic>>.from(elemento['opciones'])
              : [],
        });
      } else {
        print('⚠️ Elemento $i inválido en data: $elemento');
      }
    }

    print('✅ Total de preguntas cargadas: ${preguntas.length}');
    respuestasSeleccionadas.clear();
    notifyListeners();
  }

  // ===== Cargar tests realizados =====
  Future<void> cargarTestsRealizados(int usuarioId) async {
    try {
      final api = ApiService();
      // fetchMisTests devuelve directamente una lista de tests
      final lista = await api.fetchMisTests(usuarioId);

      testsRealizados = List<Map<String, dynamic>>.from(lista);
      print('📊 Tests realizados cargados: ${testsRealizados.length}');
      notifyListeners();
    } catch (e) {
      print('❌ Error al cargar tests realizados: $e');
      testsRealizados = [];
      notifyListeners();
    }
  }

  // ===== Seleccionar respuesta =====
  void seleccionarRespuesta(int idPregunta, String codigoOpcion) {
    respuestasSeleccionadas[idPregunta] = codigoOpcion;
    notifyListeners();
  }

  // ===== Limpiar respuestas =====
  void limpiarRespuestas() {
    respuestasSeleccionadas.clear();
    notifyListeners();
  }

  // ===== Obtener total de preguntas =====
  int totalPreguntas() => preguntas.length;

  // ===== Obtener total de respuestas =====
  int totalRespondidas() => respuestasSeleccionadas.length;

  // ===== Verificar si el test está completo =====
  bool testCompleto() => respuestasSeleccionadas.length == preguntas.length;
}
