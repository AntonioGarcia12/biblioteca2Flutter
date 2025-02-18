import 'package:biblioteca2/services/libros_por_categorias_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibrosPorCategoriasScreen extends StatefulWidget {
  static const String name = 'LibrosPorCategoriasScreen';

  const LibrosPorCategoriasScreen({super.key});

  @override
  State<LibrosPorCategoriasScreen> createState() =>
      _LibrosPorCategoriasScreenState();
}

class _LibrosPorCategoriasScreenState extends State<LibrosPorCategoriasScreen> {
  final LibrosPorCategoriasService service = LibrosPorCategoriasService();

  Future<Map<String, int>> _fetchLibrosPorCategorias() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';
    if (token.isEmpty) {
      throw Exception("Token no encontrado");
    }
    return service.obtenerLibrosPorCategoria(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(34, 47, 62, 0.95),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Libros por Categorías',
          style: TextStyle(
            color: Color(0xFFF5F6FA),
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondoBiblioteca.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<Map<String, int>>(
                future: _fetchLibrosPorCategorias(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error: \${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final List<BarChartGroupData> barGroups = [];
                    int index = 0;

                    data.forEach((category, count) {
                      barGroups.add(
                        BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: count.toDouble(),
                              width: 18,
                              color: Colors.deepPurpleAccent,
                              borderRadius: BorderRadius.circular(8),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: data.values
                                    .reduce((a, b) => a > b ? a : b)
                                    .toDouble(),
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                          showingTooltipIndicators: [],
                        ),
                      );
                      index++;
                    });
                    double maxY =
                        data.values.reduce((a, b) => a > b ? a : b).toDouble() +
                            1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: BarChart(
                          BarChartData(
                            maxY: maxY,
                            barGroups: barGroups,
                            titlesData: FlTitlesData(
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true, reservedSize: 30),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (double value, TitleMeta meta) {
                                    int index = value.toInt();
                                    if (index < data.keys.length) {
                                      String category =
                                          data.keys.elementAt(index);
                                      return Text(category,
                                          style: const TextStyle(fontSize: 10));
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: true),
                            barTouchData: BarTouchData(enabled: true),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: Text("No hay datos"));
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/admin'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Volver'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
