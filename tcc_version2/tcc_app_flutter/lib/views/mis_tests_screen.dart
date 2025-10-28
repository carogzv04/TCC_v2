import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../viewmodels/usuario_viewmodel.dart';

class MisTestsScreen extends StatefulWidget {
  const MisTestsScreen({super.key});

  @override
  State<MisTestsScreen> createState() => _MisTestsScreenState();
}

class _MisTestsScreenState extends State<MisTestsScreen> {
  bool _isLoading = true;
  List<dynamic> _tests = [];

  @override
  void initState() {
    super.initState();
    _cargarTests();
  }

  Future<void> _cargarTests() async {
    final usuario = Provider.of<UsuarioViewModel>(context, listen: false);
    try {
      // Llamada al backend: reemplazar por el endpoint real cuando esté listo
      final response = await ApiService()
          .fetchPerfil(usuario.usuarioId ?? 0); // TEMPORAL — simula carga

      // Supongamos que en el futuro habrá un endpoint /tests/mis-tests?usuario_id=ID
      if (response['success'] == true && response['data'] != null) {
        setState(() {
          _tests = response['data']['tests_realizados'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
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
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _tests.length,
        itemBuilder: (context, index) {
          final test = _tests[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.assessment,
                  color: Colors.deepPurple, size: 36),
              title: Text(
                test['nombre_test'] ?? 'Test sin nombre',
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
                    'Fecha: ${test['fecha'] ?? 'Desconocida'}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Resultado: ${test['resultado'] ?? 'Pendiente'}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios,
                  color: Colors.deepPurple),
              onTap: () {
                // Aquí podrías abrir una pantalla de detalle del test
              },
            ),
          );
        },
      ),
    );
  }
}
