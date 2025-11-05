import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'recomendaciones_screen.dart'; // 🔹 Importamos la nueva pantalla

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
      backgroundColor: const Color(0xFFF6F7D7), // ✅ fondo beige claro
      appBar: AppBar(
        title: const Text('Detalle del Test'),
        backgroundColor: const Color(0xFF3EC1D3), // ✅ azul principal
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3EC1D3)),
            )
          : _detalles.isEmpty
              ? const Center(child: Text('No se encontraron datos del test'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _detalles.length + 1, // +1 para incluir el resumen final
                  itemBuilder: (context, index) {
                    // === Bloque resumen final ===
                    if (index == _detalles.length) {
                      if (_detalles.isEmpty) return const SizedBox();

                      // Extraemos los ganadores de cada dimensión
                      final ganadores = _detalles
                          .map((d) => d['ganador']?.toString() ?? '')
                          .toList();

                      // Formamos el resumen en texto
                      final resumen = ganadores.join(', ');

                      return Card(
                        elevation: 3,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Text(
                                'Resumen del Estilo de Aprendizaje',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3EC1D3),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Tu perfil general es mayormente:\n$resumen',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Basado en las cuatro dimensiones de Felder y Silverman',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // === Botón "Ver más" que lleva a recomendaciones ===
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RecomendacionesScreen(
                                        estiloId: _mapearEstiloPrincipal(resumen),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF9A00),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(180, 45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 4,
                                ),
                                icon: const Icon(Icons.lightbulb),
                                label: const Text(
                                  'Ver más',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // === Bloque normal de dimensión ===
                    final detalle = _detalles[index];

                    final Map<int, Map<String, String>> dimensiones = {
                      1: {'nombre': 'Procesamiento', 'polaridad': 'Activo ↔ Reflexivo'},
                      2: {'nombre': 'Percepción', 'polaridad': 'Visual ↔ Verbal'},
                      3: {'nombre': 'Organización', 'polaridad': 'Secuencial ↔ Global'},
                      4: {'nombre': 'Comprensión', 'polaridad': 'Sensorial ↔ Intuitivo'},
                    };

                    final int idDimension =
                        int.tryParse(detalle['dimensiones_id'].toString()) ?? 0;
                    final nombreDimension =
                        dimensiones[idDimension]?['nombre'] ?? 'Dimensión desconocida';
                    final polaridad =
                        dimensiones[idDimension]?['polaridad'] ?? '';

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                color: Color(0xFF3EC1D3),
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
                            const Divider(
                              height: 20,
                              thickness: 1,
                              color: Color(0xFFB2EBF2),
                            ),
                            Text('Polo A: ${detalle['polo_a'] ?? '-'}'),
                            Text('Polo B: ${detalle['polo_b'] ?? '-'}'),
                            Text('Ganador: ${detalle['ganador'] ?? '-'}'),
                            Text('Neto: ${detalle['neto'] ?? '-'}'),
                            Text('Magnitud: ${detalle['magnitud'] ?? '-'}'),
                            const SizedBox(height: 8),
                            Text(
                              'Fecha: ${detalle['created_at'] ?? '-'}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  // === Mapea los estilos dominantes a un ID general ===
  int _mapearEstiloPrincipal(String resumen) {
    // Esta función determina qué tipo general mostrar (1 o 2)
    // según la presencia de palabras clave.
    final texto = resumen.toLowerCase();

    if (texto.contains('activo') || texto.contains('visual')) return 1;
    if (texto.contains('reflexivo') || texto.contains('verbal')) return 2;

    // por defecto: reflexivo / verbal
    return 2;
  }
}
