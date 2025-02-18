import 'dart:convert';
import 'package:http/http.dart' as http;

class LibrosPorCategoriasService {
  Future<Map<String, int>> obtenerLibrosPorCategoria(String token) async {
    final Uri url = Uri.parse(
        "https://apibiblioteca2.up.railway.app/admin/librosPorCategoria");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData["data"] != null) {
        final Map<String, dynamic> data = responseData["data"];

        final Map<String, int> resultado = data.map((key, value) {
          return MapEntry(
              key, value is int ? value : int.tryParse(value.toString()) ?? 0);
        });

        return resultado;
      } else {
        throw Exception("Datos no encontrados en la respuesta.");
      }
    } else {
      throw Exception("Error en la petición: ${response.statusCode}");
    }
  }
}
