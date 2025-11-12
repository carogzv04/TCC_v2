import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/usuario_viewmodel.dart';
import '../utils/session_manager.dart';
import 'mis_tests_screen.dart';
import 'perfil_screen.dart';
import 'test_screen.dart';
import 'login_screen.dart';
import 'terminos_screen.dart'; // ✅ nueva importación

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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Inicio'),
        foregroundColor: Colors.white,
      ),

      // ====== MENÚ LATERAL (DRAWER) ======
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              accountName: Text(usuarioVM.nombreCompleto ?? 'Usuario'),
              accountEmail: Text(usuarioVM.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.background,
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                  size: 40,
                ),
              ),
            ),

            // === Mis Tests ===
            ListTile(
              leading: Icon(Icons.assignment,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Mis tests'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MisTestsScreen()),
                );
              },
            ),

            // === Perfil ===
            ListTile(
              leading: Icon(Icons.person,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PerfilScreen()),
                );
              },
            ),

            // === Nueva sección: Términos y Condiciones ===
            ListTile(
              leading: Icon(Icons.description,
                  color: Theme.of(context).colorScheme.primary),
              title: const Text('Términos y Condiciones (LGPD)'),
              onTap: () {
                Navigator.pop(context); // cierra el drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TerminosScreen()),
                );
              },
            ),

            const Divider(),

            // === Cerrar sesión ===
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red),
              ),
              onTap: _cerrarSesion,
            ),
          ],
        ),
      ),

      // ====== CONTENIDO PRINCIPAL ======
      body: SafeArea( // ✅ añadido para evitar que el contenido quede debajo de la barra
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '¡Bienvenido, ${usuarioVM.nombreCompleto ?? 'Usuario'}!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                const Text(
                  'Selecciona una opción para continuar:',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 40),

                // ====== BOTÓN PRINCIPAL ======
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
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                ),
                const SizedBox(height: 20),

                // ====== BOTÓN SECUNDARIO ======
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
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    foregroundColor:
                        Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
