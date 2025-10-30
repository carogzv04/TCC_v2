import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultadoTestScreen extends StatelessWidget {
  final double porcentajeA;
  final double porcentajeB;
  final int estiloId;

  const ResultadoTestScreen({
    super.key,
    required this.porcentajeA,
    required this.porcentajeB,
    required this.estiloId,
  });

  String _getEstiloDescripcion(int id) {
    switch (id) {
      case 1:
        return 'Tu estilo predominante es A — Activo / Visual';
      case 2:
        return 'Tu estilo predominante es B — Reflexivo / Verbal';
      default:
        return 'No se pudo determinar un estilo predominante.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5F5DC),
      appBar: AppBar(
        title: const Text('Resultado del Test'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Porcentaje por Estilo de Aprendizaje',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // === Gráfico Circular ===
            SizedBox(
              height: 250,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.deepPurple,
                      value: porcentajeA,
                      title: 'A: ${porcentajeA.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: porcentajeB,
                      title: 'B: ${porcentajeB.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // === Resultado textual ===
            Text(
              _getEstiloDescripcion(estiloId),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(180, 48),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
