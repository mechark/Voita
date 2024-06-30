import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:voita_app/features/all-notes-desk/presentation/all_notes.dart';
import 'package:voita_app/features/groups/presentation/groups.dart';
import 'package:voita_app/features/notes-overview/presentation/notes_home.dart';
import 'package:voita_app/features/notes-overview/presentation/notes_overview_screen.dart';
import 'package:voita_app/features/search/presentation/search_bar.dart';
import 'package:voita_app/features/splash/presentation/splash_screen.dart';

class VoitaRouter {
  static final router = GoRouter(
  navigatorKey: GlobalKey<NavigatorState>(),
  initialLocation: '/splash',
  routes: <RouteBase>[
    GoRoute(
      name: 'splash',
      path: '/splash',
      builder:(context, state) => const SplashScreen(),
    ),
    StatefulShellRoute.indexedStack (
      builder: (context, state, navigationShell) {
        return NotesScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              name: 'search',
              path: '/search',
              builder: (context, state) => const SearchBarApp()
            )
        ]),
        StatefulShellBranch(
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: <RouteBase>[
            GoRoute(
              name: 'home',
              path: '/home',
              builder: (context, state) => const NotesHome()
            )]),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: 'groups',
                  path: '/groups',
                  builder: (context, state) => const Groups()
                )
              ]),
            StatefulShellBranch(
              routes: <RouteBase>[
                GoRoute(
                  name: 'notes',
                  path: '/notes',
                  builder: (context, state) => const AllNotes()
                )
              ]),
          ]
        )
      ], 
    );
}