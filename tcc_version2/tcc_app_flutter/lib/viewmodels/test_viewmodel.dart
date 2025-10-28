import 'package:flutter/foundation.dart';

class TestViewModel extends ChangeNotifier {
  // Lista de preguntas (cada una con sus opciones)
  List<Map<String, dynamic>> preguntas = [];

  // Respuestas seleccionadas: {id_pregunta: codigo_op}
  Map<int, String> respuestasSeleccionadas = {};

  // ===== CARGAR PREGUNTAS DESDE API =====
  Future<void> cargarPreguntasDesdeApi(List<dynamic> data) async {
    preguntas = List<Map<String, dynamic>>.from(data);
    respuestasSeleccionadas.clear();
    notifyListeners();
  }

  // ===== SELECCIONAR RESPUESTA =====
  void seleccionarRespuesta(int idPregunta, String codigoOpcion) {
    respuestasSeleccionadas[idPregunta] = codigoOpcion;
    notifyListeners();
  }

  // ===== LIMPIAR TODAS LAS RESPUESTAS =====
  void limpiarRespuestas() {
    respuestasSeleccionadas.clear();
    notifyListeners();
  }

  // ===== OBTENER TOTAL DE PREGUNTAS =====
  int totalPreguntas() {
    return preguntas.length;
  }

  // ===== OBTENER TOTAL DE RESPUESTAS =====
  int totalRespondidas() {
    return respuestasSeleccionadas.length;
  }

  // ===== VERIFICAR SI EL TEST ESTÁ COMPLETO =====
  bool testCompleto() {
    return respuestasSeleccionadas.length == preguntas.length;
  }
}
