import 'package:flutter/foundation.dart';

class TestViewModel extends ChangeNotifier {
  // Lista de preguntas (cada una con sus opciones)
  List<Map<String, dynamic>> preguntas = [];

  // Respuestas seleccionadas: {id_pregunta: codigo_op}
  Map<int, String> respuestasSeleccionadas = {};


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



  void seleccionarRespuesta(int idPregunta, String codigoOpcion) {
    respuestasSeleccionadas[idPregunta] = codigoOpcion;
    notifyListeners();
  }

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
