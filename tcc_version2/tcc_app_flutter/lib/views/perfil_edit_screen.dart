import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../viewmodels/usuario_viewmodel.dart';

class PerfilEditScreen extends StatefulWidget {
  const PerfilEditScreen({super.key});

  @override
  State<PerfilEditScreen> createState() => _PerfilEditScreenState();
}

class _PerfilEditScreenState extends State<PerfilEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _diagnosticoController = TextEditingController();
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
    _fechaNacimientoController.text = usuario.fechaNacimiento ?? '';
    _sexoSeleccionado = usuario.sexo ?? '';
    _diagnosticoController.text = usuario.diagnosticoPrevio ?? '';
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
      'diagnostico_previo': _diagnosticoController.text.trim(),
    };

    final response = await ApiService().modificarPerfil(body);
    setState(() => _isLoading = false);

    if (response['success'] == true && response['data'] != null) {
      // ✅ Actualizamos el ViewModel con los datos del backend
      final data = response['data'];
      usuario.nombreCompleto = data['nombre_completo'] ?? _nombreController.text.trim();
      usuario.email = data['email'] ?? _emailController.text.trim();
      usuario.fechaNacimiento = data['fecha_nacimiento'] ?? _fechaNacimientoController.text.trim();
      usuario.sexo = data['sexo'] ?? _sexoSeleccionado ?? '';
      usuario.diagnosticoPrevio = data['diagnostico_previo'] ?? _diagnosticoController.text.trim();

      await usuario.guardarUsuario(data); // actualiza SharedPreferences también
      usuario.notifyListeners();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Perfil actualizado correctamente')),
      );

      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error al actualizar perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5F5DC),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Editar Perfil'),
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
                  'Editar información del usuario',
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
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Ingrese su nombre' : null,
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
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingrese su correo electrónico';
                    if (!v.contains('@')) return 'Correo inválido';
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
                      initialDate: DateTime.tryParse(_fechaNacimientoController.text) ??
                          DateTime(2000),
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
                  value: _sexoSeleccionado?.isNotEmpty == true ? _sexoSeleccionado : null,
                  items: const [
                    DropdownMenuItem(value: 'M', child: Text('Masculino')),
                    DropdownMenuItem(value: 'F', child: Text('Femenino')),
                    DropdownMenuItem(value: 'O', child: Text('Otro')),
                  ],
                  onChanged: (v) => setState(() => _sexoSeleccionado = v),
                ),
                const SizedBox(height: 20),

                // Campo diagnóstico previo
                TextFormField(
                  controller: _diagnosticoController,
                  decoration: const InputDecoration(
                    labelText: 'Diagnóstico previo',
                    prefixIcon: Icon(Icons.local_hospital),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // Botones
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
                      : const Text('Guardar cambios'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    side: const BorderSide(color: Colors.deepPurple),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
