import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voita_app/features/notes-overview/presentation/desktop/notes_overview_desk.dart';
import 'package:voita_app/features/notes-overview/presentation/mobile/notes_overview_mob.dart';
import 'package:voita_app/features/splash/presentation/splash_screen.dart';
import 'package:voita_app/utils/blocs/notes_bloc/notes_bloc.dart';
import 'package:voita_app/utils/services/context_extension.dart';

class NotesScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const NotesScreen({super.key, required this.navigationShell});

  @override
  State<NotesScreen> createState() {
    return _NotesScreenState();
  }
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
      if (state is NotesLoaded) {
        return Container(
            child: context.responsive<Widget>(
                NotesOverviewMob(notes: state.notes),
                xl: NotesOverviewDesk(
                    notes: state.notes,
                    navigationShell: widget.navigationShell)));
      } else {
        // TODO change to error message
        return const SplashScreen();
      }
    });
  }
}
