import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _fechaCtrl = TextEditingController();
  String? _sexoSeleccionado;
  String? _diagnosticoSeleccionado;
  bool _loading = false;

  final _api = ApiService();

  // lista de trastornos comunes
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

  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final response = await _api.registrarUsuario({
      'nombre_completo': _nombreCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'password': _passCtrl.text.trim(),
      'fecha_nacimiento': _fechaCtrl.text.trim(),
      'sexo': _sexoSeleccionado ?? 'No especificado',
      'diagnostico_previo': _diagnosticoSeleccionado ?? 'No',
    });

    setState(() => _loading = false);

    if (response['success'] == true) {
      _mostrarSnack('Registro exitoso. Ahora podés iniciar sesión.');
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      _mostrarSnack(response['message'] ?? 'Error al registrar usuario.');
    }
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _fechaCtrl.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final hoy = DateTime.now();
    final inicial = DateTime(hoy.year - 18, hoy.month, hoy.day);

    final seleccion = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: DateTime(1900),
      lastDate: hoy,
      locale: const Locale('es', 'UY'),
    );

    if (seleccion != null) {
      _fechaCtrl.text =
          '${seleccion.year}-${_dosDigitos(seleccion.month)}-${_dosDigitos(seleccion.day)}';
    }
  }

  String _dosDigitos(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5F5DC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD5F5DC),
        elevation: 0,
        title: const Text('Registro de usuario'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingresá tu nombre' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresá tu email';
                  if (!v.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresá una contraseña';
                  if (v.length < 6) return 'Debe tener al menos 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _fechaCtrl,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _seleccionarFecha,
                  ),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Seleccioná una fecha' : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _sexoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                  DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                  DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                ],
                onChanged: (value) => setState(() => _sexoSeleccionado = value),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Seleccioná un sexo' : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: _diagnosticoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Diagnóstico previo',
                  border: OutlineInputBorder(),
                ),
                items: _diagnosticos
                    .map((d) => DropdownMenuItem(
                          value: d,
                          child: Text(d),
                        ))
                    .toList(),
                onChanged: (value) =>
                    setState(() => _diagnosticoSeleccionado = value),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Seleccioná una opción' : null,
              ),
              const SizedBox(height: 25),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Registrarse'),
                    ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('¿Ya tenés cuenta? Iniciá sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
