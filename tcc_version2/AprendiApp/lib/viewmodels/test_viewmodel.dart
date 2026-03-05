import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

// ViewModel del flujo de tests (estado, carga y envío de respuestas).
class TestViewModel extends ChangeNotifier {

  List<Map<String, dynamic>> preguntas = [];

  List<Map<String, dynamic>> testsRealizados = [];

  Map<int, String> respuestasSeleccionadas = {};

  Future<void> cargarPreguntasDesdeApi(List<dynamic> data) async {

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
      }
    }

    respuestasSeleccionadas.clear();
    notifyListeners();
  }

  Future<void> cargarTestsRealizados(int usuarioId) async {
    try {
      final api = ApiService();

      final lista = await api.fetchMisTests(usuarioId);

      testsRealizados = List<Map<String, dynamic>>.from(lista);

      notifyListeners();
    } catch (e) {

      testsRealizados = [];
      notifyListeners();
    }
  }

  void seleccionarRespuesta(int idPregunta, String codigoOpcion) {
    respuestasSeleccionadas[idPregunta] = codigoOpcion;
    notifyListeners();
  }

  void limpiarRespuestas() {
    respuestasSeleccionadas.clear();
    notifyListeners();
  }

  int totalPreguntas() => preguntas.length;

  int totalRespondidas() => respuestasSeleccionadas.length;

  bool testCompleto() => respuestasSeleccionadas.length == preguntas.length;
}
