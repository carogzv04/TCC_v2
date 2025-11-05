import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecomendacionesScreen extends StatelessWidget {
  final int estiloId;

  const RecomendacionesScreen({super.key, required this.estiloId});

  Map<String, dynamic> _getRecomendaciones(int id) {
    switch (id) {
      case 1:
        return {
          'titulo': 'Estilo Activo / Visual',
          'descripcion':
              'Te destacás aprendiendo a través de la práctica, la experimentación y el uso de elementos visuales como esquemas, gráficos o videos.',
          'tips': [
            'Participá en actividades grupales o experimentales.',
            'Usá colores, diagramas y mapas mentales en tus apuntes.',
            'Aprendé aplicando los conceptos a situaciones reales.',
            'Mirar videos o infografías puede ayudarte a recordar mejor.'
          ],
          'links': [
            {
              'texto': 'Visual Learning Strategies – MindTools',
              'url': 'https://www.mindtools.com/pages/article/newISS_01.htm'
            },
            {
              'texto': 'Active Learning Explained (Edutopia)',
              'url': 'https://www.edutopia.org/active-learning'
            },
          ]
        };

      case 2:
        return {
          'titulo': 'Estilo Reflexivo / Verbal',
          'descripcion':
              'Aprendés mejor analizando, leyendo o discutiendo ideas. Te beneficiás de la reflexión individual y las explicaciones verbales.',
          'tips': [
            'Después de estudiar, tomá un tiempo para pensar lo aprendido.',
            'Explicá los conceptos en voz alta o escribí tus reflexiones.',
            'Unite a grupos de estudio para debatir los temas.',
            'Leé artículos o libros relacionados con los contenidos de clase.'
          ],
          'links': [
            {
              'texto': 'How to Learn Verbally (Study.com)',
              'url':
                  'https://study.com/academy/lesson/verbal-learning-style.html'
            },
            {
              'texto': 'Reflective Learning – SkillsYouNeed',
              'url':
                  'https://www.skillsyouneed.com/ps/reflective-practice.html'
            },
          ]
        };

      default:
        return {
          'titulo': 'Estilo no identificado',
          'descripcion':
              'Parece que tu resultado no fue concluyente. Podés repetir el test para obtener un perfil más preciso.',
          'tips': ['Intentá realizar el test nuevamente con calma.'],
          'links': []
        };
    }
  }

  Future<void> _abrirLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getRecomendaciones(estiloId);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7D7),
      appBar: AppBar(
        title: const Text('Recomendaciones'),
        backgroundColor: const Color(0xFFFF9A00),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              data['titulo'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF9A00),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              data['descripcion'],
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 25),

            const Text(
              'Consejos personalizados:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3EC1D3),
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(
              data['tips'].length,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF3EC1D3)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        data['tips'][i],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (data['links'].isNotEmpty) ...[
              const Text(
                'Recursos recomendados:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3EC1D3),
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(
                data['links'].length,
                (i) => TextButton.icon(
                  onPressed: () => _abrirLink(data['links'][i]['url']),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(
                    data['links'][i]['texto'],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF3EC1D3),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
