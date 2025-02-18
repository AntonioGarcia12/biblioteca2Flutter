import 'package:biblioteca2/config/rutas/rutas.dart';
import 'package:biblioteca2/config/rutas/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca',
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
    );
  }
}
