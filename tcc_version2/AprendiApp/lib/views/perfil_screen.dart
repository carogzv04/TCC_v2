import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../viewmodels/usuario_viewmodel.dart';
import '../utils/session_manager.dart';
import '../utils/sheets.dart';
import '../services/api_service.dart';
import 'perfil_edit_screen.dart';
import 'login_screen.dart';

// Pantalla de perfil y acciones de cuenta.
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  @override
  void initState() {
    super.initState();
    final usuario = Provider.of<UsuarioViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (usuario.isLoggedIn && (usuario.usuarioId ?? 0) > 0) {
        usuario.actualizarPerfilDesdeBackend();
      }
    });
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

  void _mostrarError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  Future<void> _eliminarCuenta() async {
    final usuarioVM = Provider.of<UsuarioViewModel>(context, listen: false);
    final id = usuarioVM.usuarioId;
    if (id == null) {
      _mostrarError('No se pudo obtener tu ID de usuario.');
      return;
    }

    try {
      final api = ApiService();
      final res = await api.eliminarUsuario(id);

      if (res['success'] == true) {
        await SessionManager.logoutKeepData();
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      } else {
        _mostrarError(
          res['message']?.toString() ?? 'No se pudo eliminar la cuenta.',
        );
      }
    } catch (_) {
      _mostrarError('Error al conectar con el servidor.');
    }
  }

  void _confirmarEliminacionCuenta() {
    showAppSheet(
      context: context,
      isScrollControlled: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 10),
            const Text(
              '¿Eliminar cuenta?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Esta acción eliminará todos tus datos, historial de tests y perfil de la base de datos. '
              'Esta operación es irreversible.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _eliminarCuenta();
                    },
                    child: const Text('Eliminar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<UsuarioViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7D7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EC1D3),
        title: const Text('Mi Perfil'),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: usuario.isLoggedIn
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 30.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFF3EC1D3),
                      child: Icon(Icons.person, size: 70, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      usuario.nombreCompleto ?? 'Nombre no disponible',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3EC1D3),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      usuario.email ?? 'Correo no disponible',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildInfoTile(
                      icon: Icons.cake,
                      label: 'Fecha de nacimiento',
                      value: (usuario.fechaNacimiento?.isNotEmpty ?? false)
                          ? usuario.fechaNacimiento!
                          : 'No especificada',
                    ),
                    _buildInfoTile(
                      icon: Icons.wc,
                      label: 'Sexo',
                      value: (usuario.sexo?.isNotEmpty ?? false)
                          ? (usuario.sexo == 'M'
                                ? 'Masculino'
                                : usuario.sexo == 'F'
                                ? 'Femenino'
                                : 'Otro')
                          : 'No especificado',
                    ),
                    _buildInfoTile(
                      icon: Icons.medical_information,
                      label: 'Diagnóstico previo',
                      value: (usuario.diagnosticoPrevio?.isNotEmpty ?? false)
                          ? usuario.diagnosticoPrevio!
                          : 'No registrado',
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PerfilEditScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar perfil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3EC1D3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      title: const Text(
                        'Eliminar mi cuenta permanentemente',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: _confirmarEliminacionCuenta,
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text(
                'No se ha iniciado sesión.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF3EC1D3)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
