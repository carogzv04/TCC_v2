import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'recomendaciones_screen.dart';
import '../viewmodels/usuario_viewmodel.dart';

class ResultadoTestScreen extends StatelessWidget {
  final double porcentajeA;
  final double porcentajeB;
  final int estiloId;

   final int idRpu;
   
  const ResultadoTestScreen({
    super.key,
    required this.porcentajeA,
    required this.porcentajeB,
    required this.estiloId, required this.idRpu,
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
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    final chartSize = orientation == Orientation.portrait
        ? size.width * 0.65
        : size.height * 0.45;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7D7),
      appBar: AppBar(
        title: const Text('Resultado del Test'),
        backgroundColor: const Color(0xFF3EC1D3),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Porcentaje por Estilo de Aprendizaje',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3EC1D3),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              SizedBox(
                height: chartSize,
                width: chartSize,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: chartSize * 0.25,
                    startDegreeOffset: -90,
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF3EC1D3),
                        value: porcentajeA,
                        title: 'A: ${porcentajeA.toStringAsFixed(1)}%',
                        radius: chartSize * 0.35,
                        titleStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        color: const Color(0xFFFF9A00),
                        value: porcentajeB,
                        title: 'B: ${porcentajeB.toStringAsFixed(1)}%',
                        radius: chartSize * 0.35,
                        titleStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 900),
                  swapAnimationCurve: Curves.easeOutCubic,
                ),
              ),

              const SizedBox(height: 40),

              Text(
                _getEstiloDescripcion(estiloId),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
              onPressed: () {
                // Accedemos al ViewModel actual
                final usuario = Provider.of<UsuarioViewModel>(context, listen: false);

                if (usuario.usuarioId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecomendacionesScreen(ruId: idRpu,),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error: No se encontró el usuario logueado')),
                  );
                }
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9A00), // naranja
                  foregroundColor: Colors.white,
                  minimumSize: const Size(220, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 5,
                ),
                icon: const Icon(Icons.lightbulb),
                label: const Text(
                  'Ver recomendaciones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 16),

              // === Botón "Volver al inicio" ===
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3EC1D3),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                ),
                icon: const Icon(Icons.home),
                label: const Text(
                  'Volver al inicio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
