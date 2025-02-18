import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:biblioteca2/infraestructuras/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioService {
  /// Realiza el login enviando email y contraseña
  Future<Usuario> login(String email, String contrasenya) async {
    final Uri url =
        Uri.parse("https://apibiblioteca2.up.railway.app/api/auth/login");

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email': email,
        'contrasenya':
            contrasenya, // Usamos la clave correcta que espera el API.
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData["data"] != null) {
        final data = responseData["data"];
        Usuario usuario = Usuario(
          id: data["id"],
          nombre: data["nombre"],
          apellidos: data["apellido"],
          email: data["email"],
          contrasenya: contrasenya,
          rol: data["role"],
          estado: 1,
        );

        // Almacenar el token en SharedPreferences.
        final String token = data["token"];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        return usuario;
      } else {
        throw Exception("Datos de usuario no encontrados en la respuesta.");
      }
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      throw Exception(responseData["mensaje"] ??
          "Error en el login: ${response.statusCode}");
    }
  }

  Future<Usuario> register(
    String nombre,
    String apellidos,
    String email,
    String contrasenya,
  ) async {
    final Uri url =
        Uri.parse("https://apibiblioteca2.up.railway.app/api/auth/registrar");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'nombre': nombre,
        'apellidos': apellidos,
        'email': email,
        'contrasenya': contrasenya,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData["data"] != null) {
        final data = responseData["data"];
        Usuario usuario = Usuario(
          id: data["id"],
          nombre: data["nombre"],
          apellidos: data["apellido"],
          email: data["email"],
          contrasenya: contrasenya,
          rol: "USER",
          estado: 1,
        );
        return usuario;
      } else {
        throw Exception("Datos de usuario no encontrados en el registro.");
      }
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      throw Exception(responseData["mensaje"] ??
          "Error en el registro: ${response.statusCode}");
    }
  }
}
