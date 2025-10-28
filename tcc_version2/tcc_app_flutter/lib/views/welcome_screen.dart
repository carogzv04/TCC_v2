import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registro_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5F5DC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO DE LA APP
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.deepPurple,
                ),
                child: const Icon(
                  Icons.psychology_alt,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // TÍTULO
              const Text(
                'Bienvenido a la App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),
              const Text(
                'Evaluación interactiva de estilos de aprendizaje',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // BOTÓN DE INICIO DE SESIÓN
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Iniciar Sesión'),
              ),

              const SizedBox(height: 20),

              // BOTÓN DE REGISTRO
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.deepPurple, width: 2),
                  foregroundColor: Colors.deepPurple,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
