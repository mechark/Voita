import 'package:flutter/material.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final NoteRepositoryImpl _noteRepo = NoteRepositoryImpl();

  @override
  void initState() {
    super.initState();

    _noteRepo.getAllNotes().then((notes) => 
      Navigator.of(context).pushReplacementNamed('/voita_home', arguments: notes));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Voita',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 50,
            fontWeight: FontWeight.bold
          ),
        )
      )
    );
  }
}