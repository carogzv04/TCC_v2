import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/usuario_viewmodel.dart';
import '../utils/session_manager.dart';
import 'mis_tests_screen.dart';
import 'perfil_screen.dart';
import 'test_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    await Provider.of<UsuarioViewModel>(context, listen: false).cargarUsuario();
  }

  Future<void> _cerrarSesion() async {
    await SessionManager.logoutKeepData();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFD5F5DC),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Inicio'),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              accountName: Text(usuarioVM.nombreCompleto ?? 'Usuario'),
              accountEmail: Text(usuarioVM.email ?? ''),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.deepPurple, size: 40),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Mis tests'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MisTestsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PerfilScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión', style: TextStyle(color: Colors.red)),
              onTap: _cerrarSesion,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido, ${usuarioVM.nombreCompleto ?? 'Usuario'}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              const Text(
                'Selecciona una opción para continuar:',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TestScreen()),
                  );
                },
                icon: const Icon(Icons.quiz),
                label: const Text('Realizar nuevo test'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MisTestsScreen()),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('Ver tests realizados'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.deepPurple, width: 2),
                  foregroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
