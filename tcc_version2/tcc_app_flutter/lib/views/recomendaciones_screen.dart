import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecomendacionesScreen extends StatelessWidget {
  final int estiloId;

  const RecomendacionesScreen({super.key, required this.estiloId});

  Map<String, dynamic> _getRecomendaciones(int id) {
    switch (id) {
      // ========================================
      // 1️⃣ Estilo Activo
      // ========================================
      case 1:
        return {
          'titulo': 'Estilo Activo',
          'descripcion':
              'Te destacás aprendiendo a través de la práctica, la experimentación y el trabajo en equipo. Disfrutás del aprendizaje dinámico y práctico.',
          'tips': [
            'Participá en actividades grupales o experimentales.',
            'Usá materiales interactivos o juegos educativos.',
            'Aprendé aplicando los conceptos a situaciones reales.',
            'Experimentá nuevas formas de resolver un mismo problema.'
          ],
          'links': [
            {
              'texto': '5 DICAS de Aprendizagem Ativa (YouTube)',
              'url': 'https://www.youtube.com/watch?v=8Ik2ov6oYiI'
            },
            {
              'texto': 'Active Learning Tips for Busy Students',
              'url': 'https://www.youtube.com/watch?v=2aCgZcynFzw'
            },
            {
              'texto': 'Cómo estudiar mejor siendo activo',
              'url': 'https://www.youtube.com/watch?v=u165fGFfIlM'
            }
          ]
        };

      // ========================================
      // 2️⃣ Estilo Reflexivo
      // ========================================
      case 2:
        return {
          'titulo': 'Estilo Reflexivo',
          'descripcion':
              'Aprendés mejor observando, reflexionando y analizando antes de actuar. Preferís pensar con calma y aprender de la experiencia de otros.',
          'tips': [
            'Tomate tiempo para analizar antes de participar.',
            'Reflexioná sobre lo aprendido y escribí tus conclusiones.',
            'Revisá tus apuntes antes de aplicar lo aprendido.',
            'Buscá ejemplos o lecturas complementarias.'
          ],
          'links': [
            {
              'texto': 'Active & Reflective Learners (Active vs Reflective)',
              'url': 'https://www.youtube.com/watch?v=HYSlgNh_iBY'
            },
            {
              'texto': 'Reflective Learning – SkillsYouNeed',
              'url': 'https://www.skillsyouneed.com/ps/reflective-practice.html'
            }
          ]
        };

      // ========================================
      // 3️⃣ Estilo Sensorial
      // ========================================
      case 3:
        return {
          'titulo': 'Estilo Sensorial',
          'descripcion':
              'Aprendés mejor con hechos concretos, ejemplos prácticos y observando la realidad. Preferís información tangible y aplicada.',
          'tips': [
            'Buscá ejemplos reales o estudios de caso.',
            'Usá materiales visuales o físicos para practicar.',
            'Tomá notas de observaciones o resultados concretos.',
            'Evitá conceptos muy abstractos sin contexto práctico.'
          ],
          'links': [
            {
              'texto': 'Qual o seu estilo de aprendizagem? Sensorial ou Intuitivo',
              'url': 'https://www.youtube.com/watch?v=htPFbXqEdHw'
            },
            {
              'texto': 'Helping Sensing and Intuitive Learners: Tips for Learning',
              'url': 'https://www.youtube.com/watch?v=RbTNoHaIoGM'
            }
          ]
        };

      // ========================================
      // 4️⃣ Estilo Intuitivo
      // ========================================
      case 4:
        return {
          'titulo': 'Estilo Intuitivo',
          'descripcion':
              'Preferís descubrir patrones, teorías y relaciones conceptuales. Te atraen los desafíos intelectuales y las ideas abstractas.',
          'tips': [
            'Explorá conexiones entre temas.',
            'Leé sobre teorías y fundamentos de los conceptos.',
            'Buscá resolver problemas nuevos o alternativos.',
            'Evitá la repetición mecánica: necesitás innovación.'
          ],
          'links': [
            {
              'texto': 'Personalidade: sensorial e intuitivo',
              'url': 'https://www.youtube.com/watch?v=84KeXaSJflg'
            },
            {
              'texto': 'Aprendizaje sensorial e intuitivo: consejos prácticos',
              'url': 'https://www.youtube.com/watch?v=NBwfab8VDGE'
            }
          ]
        };

      // ========================================
      // 5️⃣ Estilo Visual
      // ========================================
      case 5:
        return {
          'titulo': 'Estilo Visual',
          'descripcion':
              'Tu fortaleza es comprender la información a través de imágenes, diagramas, colores y videos. Recordás mejor lo que ves.',
          'tips': [
            'Usá mapas mentales, esquemas y colores en tus apuntes.',
            'Mirá videos o infografías para reforzar los temas.',
            'Transformá ideas complejas en gráficos simples.',
            'Utilizá recursos visuales en tus exposiciones.'
          ],
          'links': [
            {
              'texto': 'Visual Learner Study Tips THAT WORK!',
              'url': 'https://www.youtube.com/watch?v=IN-_S_jj3gE'
            },
            {
              'texto': '6 Consejos para el aprendizaje visual',
              'url': 'https://www.youtube.com/watch?v=f48aBq8ngyc'
            },
            {
              'texto': 'Estilos de aprendizaje | ¿Cómo estudiar mejor?',
              'url': 'https://www.youtube.com/watch?v=WzkGMpvnwjI'
            }
          ]
        };

      // ========================================
      // 6️⃣ Estilo Verbal
      // ========================================
      case 6:
        return {
          'titulo': 'Estilo Verbal',
          'descripcion':
              'Aprendés mejor mediante palabras, ya sea leyendo, escribiendo o escuchando explicaciones. Te ayuda hablar sobre lo que aprendés.',
          'tips': [
            'Leé en voz alta y repetí conceptos clave.',
            'Escribí resúmenes o explicaciones con tus propias palabras.',
            'Participá en debates o grupos de discusión.',
            'Escuchá podcasts o audiolibros educativos.'
          ],
          'links': [
            {
              'texto': 'Tips for the Visual and Verbal Learners',
              'url': 'https://www.youtube.com/watch?v=cGhUApkrrm0'
            },
            {
              'texto': 'How to Learn Verbally (Study.com)',
              'url':
                  'https://study.com/academy/lesson/verbal-learning-style.html'
            }
          ]
        };
        
      case 7:
        return {
          'titulo': 'Estilo Secuencial',
          'descripcion':
              'Te gusta aprender paso a paso, siguiendo una estructura lógica. Avanzás mejor cuando la información está bien organizada.',
          'tips': [
            'Dividí los temas grandes en pasos pequeños.',
            'Usá esquemas o listas numeradas.',
            'Asegurate de dominar un concepto antes de pasar al siguiente.',
            'Seguí rutinas de estudio consistentes.'
          ],
          'links': [
            {
              'texto': 'Study SMART, Not HARD: Passive vs Active Studying',
              'url': 'https://www.youtube.com/watch?v=EOo7h-sQ3v4'
            },
            {
              'texto': 'Aprendizaje secuencial y global: estrategias',
              'url': 'https://www.youtube.com/watch?v=CzrL8wIJaIw'
            }
          ]
        };

      case 8:
        return {
          'titulo': 'Estilo Global',
          'descripcion':
              'Te gusta comprender el panorama general antes de enfocarte en los detalles. Captás ideas amplias y conectás distintos temas.',
          'tips': [
            'Leé primero resúmenes o introducciones generales.',
            'Usá esquemas para ver la relación entre conceptos.',
            'Buscá ejemplos que conecten varias materias.',
            'Evitá memorizar sin entender la idea completa.'
          ],
          'links': [
            {
              'texto': 'Speak Spanish more like a native: Active listening',
              'url': 'https://www.youtube.com/watch?v=seBoVJP16Ec'
            },
            {
              'texto': 'Active Recall: How to Remember Better!',
              'url': 'https://www.youtube.com/watch?v=-83GY7pXTWc'
            }
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
                  icon: const Icon(Icons.play_circle_fill,
                      color: Color(0xFF3EC1D3)),
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
