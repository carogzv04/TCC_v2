import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/test_viewmodel.dart';
import '../viewmodels/usuario_viewmodel.dart';
import '../services/api_service.dart';
import 'resultado_test_screen.dart';

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

try {
  final response = await ApiService().fetchTestPorEdad(usuario.usuarioId ?? 0);
  print('🔍 Respuesta del backend: $response');

  if (response['success'] == true && response['data'] != null) {
    final data = response['data'];
    if (data is Map && data['preguntas'] is List) {
      _testId = (data['test_id'] ?? 0) as int;
      await viewModel.cargarPreguntasDesdeApi(List.from(data['preguntas']));
    } else {
      print('⚠️ No hay preguntas válidas en la respuesta.');
      await viewModel.cargarPreguntasDesdeApi(const []);
    }
  } else {
    print('⚠️ Respuesta sin éxito o sin data válida.');
    await viewModel.cargarPreguntasDesdeApi(const []);
  }
} catch (e) {
  print('Error cargando preguntas: $e');
  await Provider.of<TestViewModel>(context, listen: false).cargarPreguntasDesdeApi(const []);
}

if (mounted) setState(() => _isLoading = false);


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
  'respuestas': viewModel.respuestasSeleccionadas.entries
      .map((e) => {'preguntas_id': e.key, 'codigo_op': e.value})
      .toList(),
};

print('📤 Enviando payload: $payload');

final response = await ApiService().enviarRespuestas(payload);
if (mounted) setState(() => _isSubmitting = false);

print('📥 Respuesta al guardar: $response');

if (response['success'] == true) {
  final data = (response['data'] as Map?) ?? const {};
  final porcentajes = (data['porcentajes'] as Map?) ?? const {};

  // Coerce seguro a double
  double toD(dynamic v) {
    if (v is num) return v.toDouble();
    if (v is String) {
      final p = double.tryParse(v);
      return p ?? 0;
    }
    return 0;
  }

  final porcentajeA = toD(porcentajes['A']);
  final porcentajeB = toD(porcentajes['B']);
  final estiloId = (data['estilo_id'] as int?) ?? 0;

  print('📊 Porcentajes normalizados => A: $porcentajeA, B: $porcentajeB, estiloId: $estiloId');

  if (!mounted) return;
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => ResultadoTestScreen(
        porcentajeA: porcentajeA,
        porcentajeB: porcentajeB,
        estiloId: estiloId,
      ),
    ),
  );
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
      backgroundColor: const Color(0xFFF6F7D7), // ✅ fondo beige claro
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EC1D3), // ✅ azul principal
        title: const Text('Realizar Test'),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3EC1D3)), // ✅ azul principal
            )
          : viewModel.preguntas.isEmpty
              ? const Center(
                  child: Text(
                    'No hay preguntas disponibles para este usuario.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: viewModel.preguntas.length,
                    itemBuilder: (context, index) {
                      try {
                        final pregunta = viewModel.preguntas[index];
                        final textoPregunta =
                            '${index + 1}. ${pregunta['texto'] ?? 'Pregunta sin texto'}';
                        final opciones =
                            (pregunta['opciones'] as List?) ?? const [];
                        final preguntaId = (pregunta['id'] ?? 0) as int;

                        // Inicialización defensiva del map de respuestas
                        viewModel.respuestasSeleccionadas[preguntaId] =
                            viewModel.respuestasSeleccionadas[preguntaId] ?? '';

                        return Card(
                          margin: const EdgeInsets.only(bottom: 20),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  textoPregunta,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF3EC1D3), // ✅ azul principal
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (opciones.isEmpty)
                                  const Text(
                                    'Sin opciones disponibles',
                                    style: TextStyle(color: Colors.black45),
                                  )
                                else
                                  ...List.generate(opciones.length, (i) {
                                    final opcion = opciones[i] as Map;
                                    final textoOpcion = (opcion['texto'] ??
                                            'Opción sin texto')
                                        .toString();
                                    final codigoOp =
                                        (opcion['codigo_op'] ?? '').toString();

                                    return RadioListTile<String>(
                                      value: codigoOp,
                                      groupValue:
                                          viewModel.respuestasSeleccionadas[
                                              preguntaId],
                                      title: Text(
                                        textoOpcion,
                                        style: const TextStyle(
                                            color: Colors.black87),
                                      ),
                                      activeColor: const Color(
                                          0xFF3EC1D3), // ✅ azul principal
                                      onChanged: (value) {
                                        if (value != null && preguntaId != 0) {
                                          viewModel.seleccionarRespuesta(
                                              preguntaId, value);
                                        }
                                      },
                                    );
                                  }),
                              ],
                            ),
                          ),
                        );
                      } catch (e, s) {
                        debugPrint(
                            '🔥 EXCEPCIÓN al renderizar pregunta $index: $e\n$s');
                        return const Text(
                          'Error al renderizar pregunta',
                          style:
                              TextStyle(color: Color(0xFFFF165D)), // 🔴 rojo error
                        );
                      }
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSubmitting ? null : _enviarRespuestas,
        backgroundColor: const Color(0xFF3EC1D3), // ✅ azul principal
        icon: _isSubmitting
            ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              )
            : const Icon(Icons.send),
        label: Text(
          _isSubmitting ? 'Enviando...' : 'Enviar',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}