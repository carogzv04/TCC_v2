import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DetalleTestScreen extends StatefulWidget {
  final int idRpu;

  const DetalleTestScreen({super.key, required this.idRpu});

  @override
  State<DetalleTestScreen> createState() => _DetalleTestScreenState();
}

class _DetalleTestScreenState extends State<DetalleTestScreen> {
  bool _isLoading = true;
  List<dynamic> _detalles = [];

  @override
  void initState() {
    super.initState();
    _cargarDetalle();
  }

  Future<void> _cargarDetalle() async {
  try {
    print('📤 Solicitando detalle del test ID ${widget.idRpu}');
    final response = await ApiService().fetchDetalleTest(widget.idRpu);
    print('📥 Respuesta detalle: $response');

    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];
      if (data is List) {
        setState(() {
          _detalles = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      } else {
        setState(() {
          _detalles = [];
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _detalles = [];
        _isLoading = false;
      });
    }
  } catch (e) {
    print('❌ Error al cargar detalle: $e');
    setState(() {
      _detalles = [];
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9F3DC),
      appBar: AppBar(
        title: const Text('Detalle del Test'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : _detalles.isEmpty
              ? const Center(child: Text('No se encontraron datos del test'))
        :    ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _detalles.length + 1, // +1 para incluir el resumen final
              itemBuilder: (context, index) {
                // Si es el último elemento, mostramos el resumen
                if (index == _detalles.length) {
                  if (_detalles.isEmpty) return const SizedBox();

                  // Extraemos los ganadores de cada dimensión
                  final ganadores = _detalles.map((d) => d['ganador']?.toString() ?? '').toList();

                  // Formamos el resumen
                  final resumen = ganadores.join(', ');

                  return Card(
                    elevation: 3,
                    color: const Color(0xFFEDE7F6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Resumen del Estilo de Aprendizaje',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tu perfil general es mayormente:\n$resumen',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Basado en las cuatro dimensiones de Felder y Silverman',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // --- Caso normal: mostrar cada dimensión ---
                final detalle = _detalles[index];

                final Map<int, Map<String, String>> dimensiones = {
                  1: {'nombre': 'Procesamiento', 'polaridad': 'Activo ↔ Reflexivo'},
                  2: {'nombre': 'Percepción', 'polaridad': 'Visual ↔ Verbal'},
                  3: {'nombre': 'Organización', 'polaridad': 'Secuencial ↔ Global'},
                  4: {'nombre': 'Comprensión', 'polaridad': 'Sensorial ↔ Intuitivo'},
                };

                final int idDimension = int.tryParse(detalle['dimensiones_id'].toString()) ?? 0;
                final nombreDimension = dimensiones[idDimension]?['nombre'] ?? 'Dimensión desconocida';
                final polaridad = dimensiones[idDimension]?['polaridad'] ?? '';

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  color: const Color(0xFFF6F0FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nombreDimension,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          polaridad,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                        const Divider(height: 20, thickness: 1, color: Color(0xFFE0D7F5)),
                        Text('Polo A: ${detalle['polo_a'] ?? '-'}'),
                        Text('Polo B: ${detalle['polo_b'] ?? '-'}'),
                        Text('Ganador: ${detalle['ganador'] ?? '-'}'),
                        Text('Neto: ${detalle['neto'] ?? '-'}'),
                        Text('Magnitud: ${detalle['magnitud'] ?? '-'}'),
                        const SizedBox(height: 8),
                        Text(
                          'Fecha: ${detalle['created_at'] ?? '-'}',
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
