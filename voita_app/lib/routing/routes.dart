import 'package:flutter/material.dart';
import 'package:voita_app/features/recording/presentation/recording_screen.dart';
import 'package:voita_app/features/splash/presentation/splash_screen.dart';
import 'package:voita_app/features/notes/presentation/notes_screen.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => SplashScreen(),
  '/voita_home': (context) => NotesScreen(),
  '/note': (context) => NoteScreen(),
};