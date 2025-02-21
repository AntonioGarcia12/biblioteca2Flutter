import 'package:biblioteca2/infraestructuras/models/DTO/libro_dto.dart';
import 'package:biblioteca2/services/prestamo_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class UsuarioScreen extends StatefulWidget {
  static const String name = 'UsuarioScreen';

  const UsuarioScreen({super.key});

  @override
  State<UsuarioScreen> createState() => _UsuarioScreenState();
}

class _UsuarioScreenState extends State<UsuarioScreen> {
  final PrestamoService _prestamoService = PrestamoService();
  String? _filtroGenero;
  String _orden = 'asc';
  late Future<List<LibroPrestamoDTO>> _futurePrestamos;
  String _nombreUsuario = "";

  @override
  void initState() {
    super.initState();
    _cargarNombreUsuario();
    _futurePrestamos = _cargarPrestamos();
  }

  Future<void> _cargarNombreUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nombreUsuario = prefs.getString('nombre') ?? 'Usuario';
    });
  }

  Future<List<LibroPrestamoDTO>> _cargarPrestamos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      throw Exception('No se encontró un token. Por favor, inicia sesión.');
    }

    return _prestamoService.getMisLibrosPrestados(
      token: token,
      genero: _filtroGenero,
      orden: _orden,
    );
  }

  void _actualizarPrestamos(
      {String? genero, String? orden, bool limpiarGenero = false}) {
    setState(() {
      if (limpiarGenero) {
        _filtroGenero = null;
      } else {
        _filtroGenero = genero ?? _filtroGenero;
      }
      _orden = orden ?? _orden;
      _futurePrestamos = _cargarPrestamos();
    });
  }

  void _mostrarConfirmacionLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar cierre de sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/index');
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(34, 47, 62, 0.95),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mis Préstamos',
              style: TextStyle(
                color: Color(0xFFF5F6FA),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              _nombreUsuario,
              style: const TextStyle(
                color: Color(0xFFF39C12),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.white),
            onPressed: () => _mostrarConfirmacionLogout(context),
          ),
        ],
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondoBiblioteca.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(34, 47, 62, 0.95),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFF39C12)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _filtroGenero,
                    isExpanded: true,
                    dropdownColor: const Color.fromRGBO(34, 47, 62, 0.95),
                    hint: const Text('Filtrar por género',
                        style: TextStyle(color: Colors.white)),
                    items: const [
                      DropdownMenuItem(
                          value: '',
                          child: Text('Todos los géneros',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 'Amor',
                          child: Text('Amor',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 'Ficcion',
                          child: Text('Ficción',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 'Infantil',
                          child: Text('Infantil',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 'Negra',
                          child: Text('Negra',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 'Historico',
                          child: Text('Histórico',
                              style: TextStyle(color: Colors.white))),
                      DropdownMenuItem(
                          value: 'Terror',
                          child: Text('Terror',
                              style: TextStyle(color: Colors.white))),
                    ],
                    onChanged: (value) {
                      if (value == '') {
                        _actualizarPrestamos(limpiarGenero: true);
                      } else {
                        _actualizarPrestamos(genero: value);
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<LibroPrestamoDTO>>(
                future: _futurePrestamos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final prestamos = snapshot.data ?? [];

                  if (prestamos.isEmpty) {
                    return const Center(
                      child: Text(
                        'No hay libros prestados',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: prestamos.length,
                    itemBuilder: (context, index) {
                      final prestamo = prestamos[index];
                      final libro = prestamo.libro;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 6,
                        color: const Color(0xFF2C3E50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                              color: Color(0xFFF39C12), width: 2),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/images/libroPorDefecto.png',
                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(libro.titulo,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          subtitle: Text(
                            'Autor: ${libro.autor}\nGénero: ${libro.genero}\nCantidad: ${prestamo.cantidad}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
