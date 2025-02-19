import 'dart:convert';
import 'package:biblioteca2/infraestructuras/models/DTO/libro_dto.dart';
import 'package:http/http.dart' as http;

class LibrosPrestadosPorMesService {
  Future<Map<String, List<LibroPrestamoDTO>>> getLibrosPrestadosPorMes(
      String token) async {
    final Uri url = Uri.parse(
        "https://apibiblioteca2.up.railway.app/admin/librosPrestadosPorMes");

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData["data"] == null) {
        throw Exception("No se encontró el objeto 'data' en la respuesta.");
      }

      final Map<String, dynamic> data = responseData["data"];

      final Map<String, List<LibroPrestamoDTO>> resultado = {};

      data.forEach((mes, lista) {
        final List<dynamic> items = lista;
        final List<LibroPrestamoDTO> dtos =
            items.map((item) => LibroPrestamoDTO.fromJson(item)).toList();
        resultado[mes] = dtos;
      });

      return resultado;
    } else {
      final Map<String, dynamic> errorData = json.decode(response.body);
      throw Exception(errorData["mensaje"] ??
          "Error en la petición: ${response.statusCode}");
    }
  }
}