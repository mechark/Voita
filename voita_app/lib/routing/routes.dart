import 'package:flutter/material.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/recording/presentation/recording_screen.dart';
import 'package:voita_app/features/splash/presentation/splash_screen.dart';
import 'package:voita_app/features/notes-overview/presentation/notes_overview_screen.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const SplashScreen(),
  '/voita_home': (context) => NotesScreen(
        notes: ModalRoute.of(context)?.settings.arguments as List<Note>,
      ),
  '/recording': (context) => RecordingScreen(
      onNoteCreated:
          ModalRoute.of(context)?.settings.arguments as Function(Note)?),
};
