import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_app_flutter/views/detalle_test_screen.dart';
import '../services/api_service.dart';
import '../viewmodels/usuario_viewmodel.dart';

class MisTestsScreen extends StatefulWidget {
  const MisTestsScreen({super.key});

  @override
  State<MisTestsScreen> createState() => _MisTestsScreenState();
}

class _MisTestsScreenState extends State<MisTestsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _tests = [];

  @override
  void initState() {
    super.initState();
    _cargarTests();
  }

  Future<void> _cargarTests() async {
  final usuario = Provider.of<UsuarioViewModel>(context, listen: false);

  try {
    final tests = await ApiService().fetchMisTests(usuario.usuarioId ?? 0);
    debugPrint('📥 Lista mis-tests (len=${tests.length}): $tests');

    setState(() {
      _tests = tests;       // ya es la lista final
      _isLoading = false;
    });
  } catch (e) {
    debugPrint('❌ Error cargando tests: $e');
    setState(() => _isLoading = false);
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5F5DC),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Mis Tests'),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            )
          : _tests.isEmpty
              ? const Center(
                  child: Text(
                    'No tienes tests realizados aún.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _tests.length,
                  itemBuilder: (context, index) {
                  final Map<String, dynamic> test = _tests[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const Icon(
                        Icons.assessment,
                        color: Colors.deepPurple,
                        size: 36,
                      ),
                      title: Text(
                        test['nombre_test']?.toString() ?? 'Test sin nombre',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            'Fecha: ${test['fecha']?.toString() ?? 'Desconocida'}',
                            style: const TextStyle(color: Colors.black87),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Resultado: ${test['resultado']?.toString().isNotEmpty == true ? test['resultado'] : 'Pendiente'}',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
                        onPressed: () {
                          // Robusto para número o string y evita nulls
                          final int idRpu =
                              (test['id_rpu'] as num?)?.toInt() ??
                              int.tryParse('${test['id_rpu']}') ??
                              0;

                          if (idRpu > 0) {
                            debugPrint('🟢 Abriendo detalle del test ID $idRpu');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetalleTestScreen(idRpu: idRpu),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ID del test inválido.')),
                            );
                            debugPrint('⚠️ ID del test no válido: ${test['id_rpu']} | test=$test');
                          }
                        },
                      ),
                    ),
                  );
                },
                ),
    );
  }
}
