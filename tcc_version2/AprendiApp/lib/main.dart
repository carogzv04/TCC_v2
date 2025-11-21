import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'viewmodels/usuario_viewmodel.dart';
import 'viewmodels/test_viewmodel.dart';

import 'views/welcome_screen.dart';
import 'views/home_screen.dart';
import 'views/registro_screen.dart';
import 'views/login_screen.dart';
import 'views/perfil_screen.dart';
import 'views/test_screen.dart';
import 'views/mis_tests_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final usuarioViewModel = UsuarioViewModel();
  await usuarioViewModel.cargarUsuario();
  final isLogged = usuarioViewModel.isLoggedIn;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => usuarioViewModel),
        ChangeNotifierProvider(create: (_) => TestViewModel()),
      ],
      
      child: MyApp(isLogged: isLogged),
    ),
  );
}
// App raíz; configura tema, rutas y localización.
class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TCC App',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('es', 'UY'),
        Locale('en', 'US'),
      ],
      locale: const Locale('es', 'ES'),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF6F7D7),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF3EC1D3),
          onPrimary: Colors.white,
          secondary: Color(0xFFFF9A00),
          onSecondary: Colors.white,
          error: Color(0xFFFF165D),
          onError: Colors.white,
          background: Color(0xFFF6F7D7),
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3EC1D3),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3EC1D3),
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF3EC1D3), width: 2),
            foregroundColor: const Color(0xFF3EC1D3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF3EC1D3), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF3EC1D3)),
            borderRadius: BorderRadius.circular(10),
          ),
          labelStyle: const TextStyle(color: Colors.black87),
        ),
      ),

      builder: (context, child) {
        return SafeArea(
          top: false,
          bottom: true,
          child: child ?? const SizedBox.shrink(),
        );
      },

      home: isLogged ? const HomeScreen() : const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/test': (context) => const TestScreen(),
        '/mis_tests': (context) => const MisTestsScreen(),
      },
    );
  }
}
