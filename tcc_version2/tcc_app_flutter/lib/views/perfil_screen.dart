import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/usuario_viewmodel.dart';
import 'perfil_edit_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final usuario = Provider.of<UsuarioViewModel>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (usuario.isLoggedIn && (usuario.usuarioId ?? 0) > 0) {
        usuario.actualizarPerfilDesdeBackend();
      }
    });

  print('👤 [PerfilScreen] Estado actual del usuario: '
      'isLoggedIn=${usuario.isLoggedIn}, '
      'id=${usuario.usuarioId}, '
      'nombre=${usuario.nombreCompleto}, '
      'email=${usuario.email}');
      
    return Scaffold(
      backgroundColor: const Color(0xFFD5F5DC),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Mi Perfil'),
        foregroundColor: Colors.white,
      ),
      body: usuario.isLoggedIn
          ? Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ===== Avatar =====
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.person, size: 70, color: Colors.white),
                    ),
                    const SizedBox(height: 20),

                    // ===== Nombre =====
                    Text(
                      usuario.nombreCompleto ?? 'Nombre no disponible',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // ===== Email =====
                    Text(
                      usuario.email ?? 'Correo no disponible',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // ===== Datos adicionales (reales) =====
                    _buildInfoTile(
                      icon: Icons.cake,
                      label: 'Fecha de nacimiento',
                      value: usuario.fechaNacimiento?.isNotEmpty == true
                          ? usuario.fechaNacimiento!
                          : 'No especificada',
                    ),
                    _buildInfoTile(
                      icon: Icons.wc,
                      label: 'Sexo',
                      value: usuario.sexo?.isNotEmpty == true
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
                      value: usuario.diagnosticoPrevio?.isNotEmpty == true
                          ? usuario.diagnosticoPrevio!
                          : 'No registrado',
                    ),


                    // ===== Botón para editar =====
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PerfilEditScreen()),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Editar perfil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
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

  // Widget auxiliar para mostrar los campos con ícono
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
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.black54, fontSize: 14)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        color: Colors.black87, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
