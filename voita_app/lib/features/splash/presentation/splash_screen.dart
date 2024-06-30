import 'package:flutter/material.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';
import 'package:voita_app/utils/services/notes_provider.dart';

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
  void initState() async {
    super.initState();

    _noteRepo.getAllNotes().then((notes) { 
      notesProvider.notes = notes;
      
      Navigator.of(context)
        .pushReplacementNamed('/voita_home', arguments: notes);
    });
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
