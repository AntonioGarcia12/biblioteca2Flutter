import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IndexScreen extends StatelessWidget {
  static const String name = 'IndexScreen';

  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(34, 47, 62, 0.9),
        elevation: 0,
        title: const Text(
          'Biblioteca',
          style: TextStyle(
            color: Color(0xFFF5F6FA),
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: Divider(
            height: 3,
            thickness: 3,
            color: Color(0xFFF39C12),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondoBiblioteca.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Bienvenido a la Biblioteca',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Explora nuestra colección de libros y amplía tus conocimientos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF34495E),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => context.push('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(34, 47, 62, 0.9),
                    foregroundColor: const Color(0xFFF39C12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Iniciar Sesión'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.push('/registro'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(34, 47, 62, 0.9),
                    foregroundColor: const Color(0xFFF39C12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 33, vertical: 12),
                  ),
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
