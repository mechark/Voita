import 'package:flutter/material.dart';
import 'package:voita_app/features/notes-overview/bloc/notes_bloc.dart';
import 'package:voita_app/features/recording/presentation/recording_screen.dart';
import 'package:voita_app/features/splash/presentation/splash_screen.dart';
import 'package:voita_app/features/notes-overview/presentation/notes_overview_screen.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => SplashScreen(),
  '/voita_home': (context) => NotesScreen(),
  '/recording': (context) => RecordingScreen(
    notesBloc: ModalRoute.of(context)?.settings.arguments as NotesBloc
  ),
};