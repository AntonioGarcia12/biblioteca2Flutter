import 'package:biblioteca2/presentacion/screens/screens.dart';
import 'package:biblioteca2/presentacion/screens/usuario_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(initialLocation: '/index', routes: [
  GoRoute(
      path: '/index',
      name: IndexScreen.name,
      builder: (context, state) => const IndexScreen()),
  GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen()),
  GoRoute(
      path: '/registro',
      name: RegistroScreen.name,
      builder: (context, state) => const RegistroScreen()),
  GoRoute(
      path: '/admin',
      name: AdministradorScreen.name,
      builder: (context, state) => const AdministradorScreen()),
  GoRoute(
      path: '/librosPorCategoria',
      name: LibrosPorCategoriasScreen.name,
      builder: (context, state) => const LibrosPorCategoriasScreen()),
  GoRoute(
      path: '/usuarios',
      name: UsuarioScreen.name,
      builder: (context, state) => const UsuarioScreen()),
]);
