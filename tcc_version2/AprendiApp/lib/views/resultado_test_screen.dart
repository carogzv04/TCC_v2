import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'recomendaciones_screen.dart';
import '../viewmodels/usuario_viewmodel.dart';

// Pantalla que muestra resultados del test y gráfico resumen.
class ResultadoTestScreen extends StatelessWidget {
  final List<dynamic> dimensiones;
  final String estiloDominante;
  final double porcentajeTotal;
  final int idRpu;

  const ResultadoTestScreen({
    super.key,
    required this.dimensiones,
    required this.estiloDominante,
    required this.porcentajeTotal,
    required this.idRpu,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    final chartSize = orientation == Orientation.portrait
        ? size.width * 0.48
        : size.height * 0.38;

    final colores = [
      const Color(0xFF3EC1D3),
      const Color(0xFFFF9A00),
      const Color(0xFFCB6CE6),
      const Color(0xFF26E24F),
    ];

    // valores: porcentaje REAL de cada dimensión (el que viene del backend)
    final valores = <double>[];
    final etiquetas = <String>[];

    for (var raw in dimensiones) {
      final dim = Map<String, dynamic>.from(raw);
      final nombre = (dim['nombre'] ?? '').toString();

      // Intentar leer explícitamente el porcentaje de la dimensión
      double porcentajeDim = 0;

      if (dim['porcentaje_dimension'] is num) {
        porcentajeDim = (dim['porcentaje_dimension'] as num).toDouble();
      } else if (dim['porcentaje'] is num) {
        porcentajeDim = (dim['porcentaje'] as num).toDouble();
      }

      // Si no viene porcentaje explícito, usar el máximo de los polos (fallback antiguo)
      if (porcentajeDim <= 0) {
        dim.remove('nombre');
        final valoresPolos = dim.values
            .whereType<num>()
            .map((v) => v.toDouble())
            .toList();
        if (valoresPolos.isEmpty) continue;
        porcentajeDim =
            valoresPolos.reduce((a, b) => a > b ? a : b); // fallback
      }

      valores.add(porcentajeDim);
      etiquetas.add(nombre);
    }

    // Normalizar para que el gráfico represente una distribución (sume 100)
    final suma = valores.fold<double>(0, (acc, v) => acc + v);
    final valoresGrafico = suma > 0
        ? valores.map((v) => v / suma * 100).toList()
        : List<double>.from(valores);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7D7),
      appBar: AppBar(
        title: const Text('Resultado del Test'),
        backgroundColor: const Color(0xFF3EC1D3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Center(
          child: Column(
            children: [
              const Text(
                'Distribución por Dimensión de Aprendizaje',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3EC1D3),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: chartSize,
                width: chartSize,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 1.5,
                    centerSpaceRadius: chartSize * 0.30,
                    startDegreeOffset: -90,
                    sections: List.generate(valores.length, (i) {
                      final valorReal = valores[i];        // p.ej. 83.3
                      final valorGraf = valoresGrafico[i]; // normalizado
                      final etiqueta = etiquetas[i];

                      return PieChartSectionData(
                        color: colores[i % colores.length],
                        value: valorGraf,
                        title:
                            '${etiqueta.split('–')[0]}\n${valorReal.toStringAsFixed(1)}%',
                        radius: chartSize * 0.25,
                        titleStyle: TextStyle(
                          fontSize: chartSize * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      );
                    }),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 800),
                  swapAnimationCurve: Curves.easeOutCubic,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                'Tu estilo dominante es: $estiloDominante',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Promedio general: ${porcentajeTotal.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),

              const SizedBox(height: 25),

              ElevatedButton.icon(
                onPressed: () {
                  final usuario = Provider.of<UsuarioViewModel>(
                    context,
                    listen: false,
                  );
                  if (usuario.usuarioId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecomendacionesScreen(ruId: idRpu),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Error: No se encontró el usuario logueado',
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9A00),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.lightbulb),
                label: const Text(
                  'Ver recomendaciones',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3EC1D3),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(180, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.home),
                label: const Text(
                  'Volver al inicio',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
