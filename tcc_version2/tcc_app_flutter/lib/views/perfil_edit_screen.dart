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
  String? _sexoSeleccionado;
  String? _diagnosticoSeleccionado;
  bool _isLoading = false;

  final List<String> _diagnosticos = [
    'No',
    'TDAH (Trastorno por Déficit de Atención e Hiperactividad)',
    'TDA (Trastorno por Déficit de Atención)',
    'TEA (Trastorno del Espectro Autista)',
    'Dislexia',
    'Discalculia',
    'Disgrafía',
    'Otro',
  ];

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
    _diagnosticoSeleccionado = usuario.diagnosticoPrevio ?? '';
    final diag = usuario.diagnosticoPrevio ?? '';
    _diagnosticoSeleccionado = _diagnosticos.contains(diag) ? diag : 'No';
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
      'diagnostico_previo': _diagnosticoSeleccionado ?? '',
    };

    final response = await ApiService().modificarPerfil(body);
    setState(() => _isLoading = false);

    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];
      usuario.nombreCompleto = data['nombre_completo'] ?? _nombreController.text.trim();
      usuario.email = data['email'] ?? _emailController.text.trim();
      usuario.fechaNacimiento = data['fecha_nacimiento'] ?? _fechaNacimientoController.text.trim();
      usuario.sexo = data['sexo'] ?? _sexoSeleccionado ?? '';
      usuario.diagnosticoPrevio = data['diagnostico_previo'] ?? _diagnosticoSeleccionado ?? '';

      await usuario.guardarUsuario(data);
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
      backgroundColor: const Color(0xFFF6F7D7), // ✅ fondo beige claro
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EC1D3), // ✅ azul principal
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
                    color: Color(0xFF3EC1D3), // ✅ título azul
                  ),
                ),
                const SizedBox(height: 30),

                // ===== Nombre =====
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person, color: Color(0xFF3EC1D3)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Ingrese su nombre' : null,
                ),
                const SizedBox(height: 20),

                // ===== Email =====
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email, color: Color(0xFF3EC1D3)),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingrese su correo electrónico';
                    if (!v.contains('@')) return 'Correo inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ===== Fecha nacimiento =====
                TextFormField(
                  controller: _fechaNacimientoController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Fecha de nacimiento',
                    prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF3EC1D3)),
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

                // ===== Sexo =====
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sexo',
                    prefixIcon: Icon(Icons.wc, color: Color(0xFF3EC1D3)),
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

                // ===== Diagnóstico previo =====
                DropdownButtonFormField<String>(
                  value: _diagnosticoSeleccionado,
                  isExpanded: true, // ✅ evita overflow
                  decoration: const InputDecoration(
                    labelText: 'Diagnóstico previo',
                    prefixIcon:
                        Icon(Icons.local_hospital, color: Color(0xFF3EC1D3)),
                    border: OutlineInputBorder(),
                  ),
                  items: _diagnosticos.map((d) {
                    return DropdownMenuItem(
                      value: d,
                      child: Text(
                        d,
                        overflow: TextOverflow.ellipsis, // ✅ corta con “...”
                        maxLines: 1,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _diagnosticoSeleccionado = value),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Seleccioná una opción' : null,
                ),
                const SizedBox(height: 30),

                // ===== Botón Guardar cambios =====
                ElevatedButton(
                  onPressed: _isLoading ? null : _actualizarPerfil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3EC1D3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
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

                // ===== Botón Cancelar =====
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF3EC1D3),
                    side: const BorderSide(color: Color(0xFF3EC1D3)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
