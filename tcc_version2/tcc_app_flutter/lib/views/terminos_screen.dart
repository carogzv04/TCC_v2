import 'package:flutter/material.dart';

class TerminosScreen extends StatelessWidget {
  const TerminosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7D7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EC1D3),
        foregroundColor: Colors.white,
        title: const Text('Términos y Condiciones'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Política de Privacidad y Términos de Uso',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3EC1D3),
                ),
              ),
              SizedBox(height: 16),

              Text(
                'Última actualización: Octubre 2025\n',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              Text(
                'Esta aplicación cumple con la Lei Geral de Proteção de Dados Pessoais (Lei nº 13.709/2018 – LGPD) de Brasil, '
                'y se compromete a proteger la privacidad de los datos personales de los usuarios. '
                'Al utilizar esta aplicación, el usuario acepta los términos y condiciones establecidos a continuación.\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              Text(
                '1. Recolección de datos personales',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Recolectamos únicamente los datos necesarios para el funcionamiento de la aplicación, '
                'como nombre completo, correo electrónico, fecha de nacimiento y sexo. '
                'Estos datos se utilizan exclusivamente con fines académicos y de personalización de la experiencia dentro del sistema.\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              Text(
                '2. Uso de la información',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'La información proporcionada por el usuario será utilizada solo para: '
                '(a) registrar su cuenta, (b) permitir el acceso a los tests de aprendizaje, '
                'y (c) generar recomendaciones personalizadas basadas en los resultados. '
                'No se compartirán datos personales con terceros sin el consentimiento expreso del usuario.\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              Text(
                '3. Almacenamiento y seguridad de los datos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Los datos se almacenan en servidores protegidos mediante mecanismos de seguridad y acceso restringido. '
                'La aplicación implementa medidas técnicas y organizativas para proteger la información contra accesos no autorizados, pérdida o alteración.\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              Text(
                '4. Derechos del titular de los datos (conforme a la LGPD)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'El usuario tiene derecho a: '
                '\n• Confirmar la existencia del tratamiento de sus datos; '
                '\n• Acceder a los datos personales recolectados; '
                '\n• Solicitar la corrección o eliminación de información; '
                '\n• Revocar el consentimiento para el tratamiento de los datos.\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              Text(
                '5. Conservación de datos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Los datos personales se conservarán únicamente durante el tiempo necesario para los fines educativos '
                'y de investigación del proyecto. Una vez cumplido dicho propósito, los registros podrán ser eliminados '
                'o anonimizados conforme a las disposiciones de la LGPD.\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              Text(
                '6. Cambios en esta política',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Nos reservamos el derecho de actualizar esta política de privacidad en cualquier momento. '
                'La nueva versión será publicada dentro de la aplicación y entrará en vigencia inmediatamente después de su publicación.\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              Text(
                '7. Contacto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Para ejercer los derechos mencionados o realizar consultas sobre el tratamiento de datos personales, '
                'el usuario puede comunicarse a través del correo electrónico de soporte del proyecto académico.\n',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),

              SizedBox(height: 24),
              Center(
                child: Text(
                  '© 2025 AprendiApp  - Evaluación Interactiva de Estilos de Aprendizaje',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
