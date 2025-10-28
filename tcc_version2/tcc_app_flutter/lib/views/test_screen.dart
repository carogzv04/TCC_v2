import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/test_viewmodel.dart';
import '../viewmodels/usuario_viewmodel.dart';
import '../services/api_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  int? _testId;

  @override
  void initState() {
    super.initState();
    _cargarPreguntas();
  }

  Future<void> _cargarPreguntas() async {
    final usuario = Provider.of<UsuarioViewModel>(context, listen: false);
    final viewModel = Provider.of<TestViewModel>(context, listen: false);

    final response = await ApiService().fetchTestPorEdad(usuario.usuarioId ?? 0);

    if (response['success'] == true && response['data'] != null) {
      _testId = response['data']['test_id'];
      await viewModel.cargarPreguntasDesdeApi(response['data']['preguntas']);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _enviarRespuestas() async {
    final viewModel = Provider.of<TestViewModel>(context, listen: false);
    final usuario = Provider.of<UsuarioViewModel>(context, listen: false);

    if (viewModel.respuestasSeleccionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Responda todas las preguntas antes de enviar.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final payload = {
      'usuario_id': usuario.usuarioId,
      'test_id': _testId,
      'respuestas': viewModel.respuestasSeleccionadas.entries.map((e) {
        return {
          'preguntas_id': e.key,
          'codigo_op': e.value,
        };
      }).toList(),
    };

    final response = await ApiService().enviarRespuestas(payload);
    setState(() => _isSubmitting = false);

    if (response['success'] == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Respuestas enviadas correctamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error al enviar respuestas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TestViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFD5F5DC),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Realizar Test'),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Colors.deepPurple),
      )
          : viewModel.preguntas.isEmpty
          ? const Center(
        child: Text('No hay preguntas disponibles para este usuario.'),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: viewModel.preguntas.length,
          itemBuilder: (context, index) {
            final pregunta = viewModel.preguntas[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${pregunta['texto']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      (pregunta['opciones'] as List).length,
                          (i) {
                        final opcion = pregunta['opciones'][i];
                        return RadioListTile<String>(
                          title: Text(opcion['texto']),
                          value: opcion['codigo_op'],
                          groupValue:
                          viewModel.respuestasSeleccionadas[pregunta['id']],
                          activeColor: Colors.deepPurple,
                          onChanged: (value) {
                            viewModel.seleccionarRespuesta(
                              pregunta['id'],
                              value!,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSubmitting ? null : _enviarRespuestas,
        backgroundColor: Colors.deepPurple,
        icon: _isSubmitting
            ? const CircularProgressIndicator(
            color: Colors.white, strokeWidth: 2)
            : const Icon(Icons.send),
        label: Text(_isSubmitting ? 'Enviando...' : 'Enviar'),
      ),
    );
  }
}
