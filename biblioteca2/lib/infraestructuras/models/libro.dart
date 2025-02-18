class Libro {
  final int id;
  final String titulo;
  final String imagen;
  final String autor;
  final String genero;
  final int numPaginas;
  final int anioPublicacion;
  final String estado;

  Libro(
      {required this.id,
      required this.titulo,
      required this.imagen,
      required this.autor,
      required this.genero,
      required this.numPaginas,
      required this.anioPublicacion,
      required this.estado});

  factory Libro.fromJson(Map<String, dynamic> json) {
    return Libro(
      id: json["id"],
      titulo: json["titulo"],
      imagen: json["imagen"],
      autor: json["autor"],
      genero: json["genero"],
      numPaginas: json["numPaginas"],
      anioPublicacion: json["anioPublicacion"],
      estado: json["estado"],
    );
  }
}
