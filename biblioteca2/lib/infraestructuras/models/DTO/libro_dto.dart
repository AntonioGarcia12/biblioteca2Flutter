import 'package:biblioteca2/infraestructuras/models/libro.dart';

class LibroPrestamoDTO {
  final Libro libro;
  final int cantidad;

  LibroPrestamoDTO({
    required this.libro,
    required this.cantidad,
  });

  // Método para crear una instancia de LibroPrestamoDTO a partir de un JSON
  factory LibroPrestamoDTO.fromJson(Map<String, dynamic> json) {
    return LibroPrestamoDTO(
      libro: Libro.fromJson(json["libro"]),
      cantidad: json["cantidad"],
    );
  }
}
