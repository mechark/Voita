import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';
import 'package:voita_app/utils/services/notes_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() {
      return _SplashScreenState();
    }
}

class _SplashScreenState extends State<SplashScreen> {
  final NoteRepositoryImpl _noteRepo = NoteRepositoryImpl();
  final NotesProvider notesProvider = NotesProvider();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 100)).
      then((value) => context.go('/home'));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
      'Voita',
      style: TextStyle(
          fontFamily: 'Open Sans', fontSize: 50, fontWeight: FontWeight.bold),
    )));
  }
}
