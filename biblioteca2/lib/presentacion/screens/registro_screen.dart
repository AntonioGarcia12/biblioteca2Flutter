import 'package:biblioteca2/services/usuarioService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistroScreen extends StatefulWidget {
  static const String name = 'RegistroScreen';

  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UsuarioService _usuarioService = UsuarioService();

  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showOverlayMessage(String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.1,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<void> _register() async {
    if (_nombreController.text.isEmpty ||
        _apellidosController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showOverlayMessage("Por favor, complete todos los campos");
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      await _usuarioService.register(
        _nombreController.text.trim(),
        _apellidosController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      _showOverlayMessage("Registro exitoso");

      Future.delayed(const Duration(seconds: 2), () {
        context.go('/login');
      });
    } catch (e) {
      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      _showOverlayMessage(errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(34, 47, 62, 0.9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/index');
          },
        ),
        title: const Text(
          'Biblioteca',
          style: TextStyle(
            color: Color(0xFFF5F6FA),
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(8),
          child: Divider(
            height: 8,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(40.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                    minWidth: 300,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Registro',
                        style: TextStyle(
                          color: Color(0xFF2C3E50),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _nombreController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _apellidosController,
                        decoration: const InputDecoration(
                          labelText: 'Apellidos',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : OutlinedButton.icon(
                              onPressed: _register,
                              label: const Text('Registrar'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFE74C3C),
                                side:
                                    const BorderSide(color: Color(0xFFE74C3C)),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const Text(
                          '¿Ya tienes una cuenta? Inicia sesión aquí',
                          style: TextStyle(color: Color(0xFF3498DB)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
