import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'utils/session_manager.dart';

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
  final isLogged = await SessionManager.isLoggedIn();

  runApp(MyApp(isLogged: isLogged));
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({super.key, required this.isLogged});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioViewModel()),
        ChangeNotifierProvider(create: (_) => TestViewModel()),
      ],
      child: MaterialApp(
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
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
          scaffoldBackgroundColor: const Color(0xFFD5F5DC),
        ),

        
        home: isLogged ? const HomeScreen() : const WelcomeScreen(),

        routes: {
          '/login': (context) => const LoginScreen(),
          '/registro': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/perfil': (context) => const PerfilScreen(),
          '/test': (context) => const TestScreen(),
          '/mis_tests': (context) => const MisTestsScreen(),
        },
      ),
    );
  }
}
