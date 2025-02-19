import 'dart:convert';
import 'package:biblioteca2/infraestructuras/models/DTO/libro_dto.dart';
import 'package:http/http.dart' as http;

class PrestamoService {
  Future<List<LibroPrestamoDTO>> getMisLibrosPrestados({
    required String token,
    String? genero,
    String orden = "asc",
  }) async {
    final queryParameters = <String, String>{
      if (genero != null && genero.isNotEmpty) 'genero': genero,
      'orden': orden,
    };

    final uri = Uri.parse(
            "https://apibiblioteca2.up.railway.app/api/auth/mis-libros-prestados")
        .replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData["data"] == null) {
        throw Exception(responseData["mensaje"] ?? "Datos no encontrados");
      }

      List<dynamic> dataList = responseData["data"];
      final List<LibroPrestamoDTO> prestamos = dataList
          .map((item) => LibroPrestamoDTO.fromJson(item))
          .toList()
          .cast<LibroPrestamoDTO>();

      return prestamos;
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData["mensaje"] ??
          "Error al obtener libros prestados: ${response.statusCode}");
    }
  }
}