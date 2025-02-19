import 'package:biblioteca2/infraestructuras/models/DTO/libro_dto.dart';
import 'package:biblioteca2/services/libros_prestados_por_mes_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class LibrosPrestadorPorMesScreen extends StatefulWidget {
  static const String name = 'LibrosPrestadorPorMesScreen';

  const LibrosPrestadorPorMesScreen({super.key});

  @override
  State<LibrosPrestadorPorMesScreen> createState() =>
      _LibrosPrestadorPorMesScreenState();
}

class _LibrosPrestadorPorMesScreenState
    extends State<LibrosPrestadorPorMesScreen> {
  final LibrosPrestadosPorMesService _service = LibrosPrestadosPorMesService();

  late Future<Map<String, List<LibroPrestamoDTO>>> _futureData;

  String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _futureData = _fetchData();
  }

  String corregirCaracteres(String texto) {
    return texto.replaceAll('Ã±', 'ñ');
  }

  Future<Map<String, List<LibroPrestamoDTO>>> _fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      throw Exception("Token no encontrado. Por favor, inicia sesión.");
    }
    return _service.getLibrosPrestadosPorMes(token);
  }

  String _capitalizar(String mes) {
    if (mes.isEmpty) return mes;
    return mes[0].toUpperCase() + mes.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Libros prestados por mes",
          style: TextStyle(
            color: Color(0xFFF5F6FA),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromRGBO(34, 47, 62, 0.95),
        elevation: 4,
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
        child: FutureBuilder<Map<String, List<LibroPrestamoDTO>>>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final data = snapshot.data!;

              if (data.isEmpty) {
                return const Center(child: Text("No hay datos"));
              }

              final List<String> meses = data.keys.toList();

              _selectedMonth ??= meses.first;

              final List<LibroPrestamoDTO> librosDelMes =
                  data[_selectedMonth] ?? [];

              return Column(
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
                          value: _selectedMonth,
                          isExpanded: true,
                          dropdownColor: const Color.fromRGBO(34, 47, 62, 0.95),
                          hint: const Text('Selecciona un mes',
                              style: TextStyle(color: Colors.white)),
                          items: meses.map((mes) {
                            return DropdownMenuItem(
                              value: mes,
                              child: Text(
                                _capitalizar(mes),
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMonth = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: librosDelMes.length,
                      itemBuilder: (context, index) {
                        final libroPrestamo = librosDelMes[index];
                        final libro = libroPrestamo.libro;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  corregirCaracteres(libro.titulo),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text("Autor: ${libro.autor}"),
                                Text("Género: ${libro.genero}"),
                                Text(
                                    "Cantidad prestada: ${libroPrestamo.cantidad}"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => context.go('/admin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE74C3C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Volver'),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            } else {
              return const Center(child: Text("No hay datos"));
            }
          },
        ),
      ),
    );
  }
}