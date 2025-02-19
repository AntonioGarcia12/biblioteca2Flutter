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

  @override
  void initState() {
    super.initState();
    _futurePrestamos = _cargarPrestamos();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(34, 47, 62, 0.95),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Mis Préstamos',
          style: TextStyle(
            color: Color(0xFFF5F6FA),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/index'),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () => _actualizarPrestamos(
                    orden: _orden == 'asc' ? 'desc' : 'asc'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(34, 47, 62, 0.95),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(_orden == 'asc'
                    ? 'Orden: Ascendente'
                    : 'Orden: Descendente'),
              ),
            ),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: ListTile(
                          title: Text(libro.titulo,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Autor: ${libro.autor}\nGénero: ${libro.genero}\nCantidad: ${prestamo.cantidad}'),
                          isThreeLine: true,
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