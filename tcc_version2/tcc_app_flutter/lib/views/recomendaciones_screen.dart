import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../viewmodels/usuario_viewmodel.dart';

class RecomendacionesScreen extends StatefulWidget {
  final int? ruId; // ← opcional, cuando venís desde un test específico

  const RecomendacionesScreen({super.key, this.ruId});

  @override
  State<RecomendacionesScreen> createState() => _RecomendacionesScreenState();
}

class _RecomendacionesScreenState extends State<RecomendacionesScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _data;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarRecomendaciones();
  }

  Future<void> _cargarRecomendaciones() async {
    final usuario = Provider.of<UsuarioViewModel>(context, listen: false);

    if (usuario.usuarioId == null) {
      setState(() {
        _error = 'Usuario no encontrado en la sesión.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await ApiService()
          .fetchRecomendaciones(usuario.usuarioId!, ruId: widget.ruId);

      if (response['success'] == true && response['data'] != null) {
        setState(() {
          _data = response['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response['message'] ?? 'Error desconocido';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error al conectar con la API: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _abrirLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  final Map<String, List<Map<String, String>>> recursosExtra = {
    "Activo": [
      {
        "texto": "5 DICAS de Aprendizagem Ativa (YouTube)",
        "url": "https://www.youtube.com/watch?v=8Ik2ov6oYiI"
      },
      {
        "texto": "Active Learning Tips for Busy Students",
        "url": "https://www.youtube.com/watch?v=2aCgZcynFzw"
      },
      {
        "texto": "Cómo estudiar mejor siendo activo",
        "url": "https://www.youtube.com/watch?v=u165fGFfIlM"
      },
    ],
    "Reflexivo": [
      {
        "texto": "Active & Reflective Learners (Active vs Reflective)",
        "url": "https://www.youtube.com/watch?v=HYSlgNh_iBY"
      },
      {
        "texto": "Reflective Learning – SkillsYouNeed",
        "url": "https://www.skillsyouneed.com/ps/reflective-practice.html"
      }
    ],
    "Visual": [
      {
        "texto": "Visual Learner Study Tips THAT WORK!",
        "url": "https://www.youtube.com/watch?v=IN-_S_jj3gE"
      },
      {
        "texto": "6 Consejos para el aprendizaje visual",
        "url": "https://www.youtube.com/watch?v=f48aBq8ngyc"
      }
    ],
    "Verbal": [
      {
        "texto": "How to Learn Verbally (Study.com)",
        "url": "https://study.com/academy/lesson/verbal-learning-style.html"
      },
      {
        "texto": "Tips for the Visual and Verbal Learners",
        "url": "https://www.youtube.com/watch?v=cGhUApkrrm0"
      }
    ],
    "Secuencial": [
      {
        "texto": "Aprendizaje secuencial y global: estrategias",
        "url": "https://www.youtube.com/watch?v=CzrL8wIJaIw"
      }
    ],
    "Global": [
      {
        "texto": "Active Recall: How to Remember Better!",
        "url": "https://www.youtube.com/watch?v=-83GY7pXTWc"
      }
    ],
    "Sensorial": [
      {
        "texto": "Qual o seu estilo de aprendizagem? Sensorial ou Intuitivo",
        "url": "https://www.youtube.com/watch?v=htPFbXqEdHw"
      }
    ],
    "Intuitivo": [
      {
        "texto": "Personalidade: sensorial e intuitivo",
        "url": "https://www.youtube.com/watch?v=84KeXaSJflg"
      }
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7D7),
      appBar: AppBar(
        title: const Text('Recomendaciones personalizadas'),
        backgroundColor: const Color(0xFFFF9A00),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : _buildContenido(),
    );
  }

  Widget _buildContenido() {
    final dimensiones = _data?['dimensiones_detectadas'] ?? [];
    final recomendaciones = _data?['recomendaciones'] ?? [];
    final ruUsado = _data?['ru_id_usado'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Text(
            "Dimensiones detectadas:",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3EC1D3),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(
              dimensiones.length,
              (i) => Chip(
                label: Text(dimensiones[i]),
                backgroundColor: Colors.orange.shade200,
              ),
            ),
          ),

          const SizedBox(height: 10),
          Text(
            "Resultado usado (ru_id): ${ruUsado ?? '-'}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 20),
          const Text(
            "Recomendaciones desde tu perfil:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3EC1D3),
            ),
          ),
          const SizedBox(height: 10),

          // --- Recomendaciones desde la API ---
          ...List.generate(
            recomendaciones.length,
            (i) {
              final rec = recomendaciones[i];
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rec['contenido'] ?? 'Sin descripción',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Polo: ${rec['polo'] ?? '-'}",
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),
          const Divider(thickness: 1),

          const Text(
            "Videos y recursos recomendados:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3EC1D3),
            ),
          ),
          const SizedBox(height: 10),

          // --- Recursos hardcodeados según dimensiones detectadas ---
          ...dimensiones.expand<Widget>((dim) {
            final dimNormalizado =
                "${dim[0].toUpperCase()}${dim.substring(1).toLowerCase()}";
            final extras = recursosExtra[dimNormalizado] ?? [];

            print(
                "🎥 Buscando recursos para '$dimNormalizado' → ${extras.length} encontrados");

            if (extras.isEmpty) {
              return [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Text(
                    "Sin recursos adicionales para $dimNormalizado.",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                )
              ];
            }

            return extras
                .map<Widget>(
                  (link) => TextButton.icon(
                    onPressed: () => _abrirLink(link['url']!),
                    icon: const Icon(Icons.play_circle_fill,
                        color: Color(0xFF3EC1D3)),
                    label: Text(
                      link['texto']!,
                      style: const TextStyle(
                        color: Color(0xFF3EC1D3),
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
                .toList();
          }).toList(),
        ],
      ),
    );
  }
}
