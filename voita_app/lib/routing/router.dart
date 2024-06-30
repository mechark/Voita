import 'package:go_router/go_router.dart';
import 'package:voita_app/features/notes-overview/presentation/notes_overview_screen.dart';
import 'package:voita_app/features/splash/presentation/splash_screen.dart';

class VoitaRouter {
  static final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'splash',
      path: '/splash',
      builder:(context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => NotesScreen()
    )
  ]
);
}