import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../viewmodels/usuario_viewmodel.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  String? _sexoSeleccionado;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  void _cargarDatosUsuario() {
    final usuario = Provider.of<UsuarioViewModel>(context, listen: false);
    _nombreController.text = usuario.nombreCompleto ?? '';
    _emailController.text = usuario.email ?? '';
    _sexoSeleccionado = null; // No tenemos aún este dato persistido
  }

  Future<void> _actualizarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final usuario = Provider.of<UsuarioViewModel>(context, listen: false);
    final body = {
      'usuario_id': usuario.usuarioId,
      'nombre_completo': _nombreController.text.trim(),
      'email': _emailController.text.trim(),
      'fecha_nacimiento': _fechaNacimientoController.text.trim(),
      'sexo': _sexoSeleccionado ?? '',
    };

    final response = await ApiService().modificarPerfil(body);
    setState(() => _isLoading = false);

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Perfil actualizado')),
      );
      usuario.nombreCompleto = _nombreController.text.trim();
      usuario.email = _emailController.text.trim();
      usuario.notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error al actualizar perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<UsuarioViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFD5F5DC),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Mi Perfil'),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Información del usuario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 30),

                // Campo nombre completo
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  (value == null || value.isEmpty) ? 'Ingrese su nombre' : null,
                ),
                const SizedBox(height: 20),

                // Campo correo
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese su correo electrónico';
                    }
                    if (!value.contains('@')) {
                      return 'Correo inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Campo fecha nacimiento
                TextFormField(
                  controller: _fechaNacimientoController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de nacimiento',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      locale: const Locale('es', 'ES'),
                    );
                    if (picked != null) {
                      _fechaNacimientoController.text =
                      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Campo sexo
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sexo',
                    prefixIcon: Icon(Icons.wc),
                    border: OutlineInputBorder(),
                  ),
                  value: _sexoSeleccionado,
                  items: const [
                    DropdownMenuItem(value: 'M', child: Text('Masculino')),
                    DropdownMenuItem(value: 'F', child: Text('Femenino')),
                    DropdownMenuItem(value: 'O', child: Text('Otro')),
                  ],
                  onChanged: (value) {
                    setState(() => _sexoSeleccionado = value);
                  },
                ),
                const SizedBox(height: 30),

                // Botón actualizar
                ElevatedButton(
                  onPressed: _isLoading ? null : _actualizarPerfil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text('Actualizar perfil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
