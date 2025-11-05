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
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    } else {
      _mostrarSnack(response['message'] ?? 'Error al registrar usuario.');
    }
  }

  void _mostrarSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
      resizeToAvoidBottomInset: true, // ✅ se ajusta al teclado
      backgroundColor: const Color(0xFFF6F7D7), // ✅ fondo beige claro
      appBar: AppBar(
        backgroundColor: const Color(0xFF3EC1D3), // ✅ azul principal
        elevation: 0,
        title: const Text('Registro de usuario'),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(), // 👈 cierra teclado al tocar fuera
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ===== TÍTULO =====
                  const Text(
                    'Crear nueva cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3EC1D3), // ✅ azul principal
                    ),
                  ),
                  const SizedBox(height: 25),

                  // ===== CAMPOS =====
                  TextFormField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: Icon(Icons.person, color: Color(0xFF3EC1D3)),
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
                      prefixIcon: Icon(Icons.email, color: Color(0xFF3EC1D3)),
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
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF3EC1D3)),
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
                      prefixIcon: const Icon(Icons.calendar_today,
                          color: Color(0xFF3EC1D3)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.event, color: Color(0xFF3EC1D3)),
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
                      prefixIcon: Icon(Icons.wc, color: Color(0xFF3EC1D3)),
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Femenino', child: Text('Femenino')),
                      DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
                      DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                    ],
                    onChanged: (value) =>
                        setState(() => _sexoSeleccionado = value),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Seleccioná un sexo' : null,
                  ),
                  const SizedBox(height: 15),

                  DropdownButtonFormField<String>(
                    value: _diagnosticoSeleccionado,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Diagnóstico previo',
                      prefixIcon:
                          Icon(Icons.local_hospital, color: Color(0xFF3EC1D3)),
                      border: OutlineInputBorder(),
                    ),
                    items: _diagnosticos
                        .map((d) => DropdownMenuItem(value: d, child: Text(d,
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1, 
                        style: const TextStyle(fontSize: 14))))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _diagnosticoSeleccionado = value),
                    validator: (v) => v == null || v.isEmpty
                        ? 'Seleccioná una opción'
                        : null,
                  ),
                  const SizedBox(height: 30),

                
                  _loading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF3EC1D3),
                        )
                      : ElevatedButton(
                          onPressed: _registrar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3EC1D3),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          child: const Text('Registrarse'),
                        ),
                  const SizedBox(height: 15),

                  // ===== ENLACE A LOGIN =====
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      '¿Ya tenés cuenta? Iniciá sesión',
                      style: TextStyle(
                        color: Color(0xFFFF9A00), // ✅ acento naranja
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
