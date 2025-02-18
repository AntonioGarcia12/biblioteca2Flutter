class Usuario {
  final int id;
  final String nombre;
  final String apellidos;
  final String email;
  final String contrasenya;
  final String rol;
  final int estado;

  Usuario(
      {required this.id,
      required this.nombre,
      required this.apellidos,
      required this.email,
      required this.contrasenya,
      required this.rol,
      required this.estado});
}
