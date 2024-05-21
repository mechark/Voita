import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voita_app/features/notes-overview/bloc/notes_bloc.dart';

class RecordIcon extends StatelessWidget {
final Color color;
final NotesBloc? notesBloc;
const RecordIcon({ Key? key, required this.color, this.notesBloc }) : super(key: key);


  @override
  Widget build(BuildContext context){
    return IconButton(
            onPressed: () async {
              final status = await Permission.microphone.request();
              if (status.isGranted) {
                Navigator.pushNamed(context, "/recording", arguments: notesBloc);
              }
              else {throw Exception("status.isDenied ${status.isDenied}");}
            },
            icon: const ImageIcon(AssetImage("assets/add_note.png")),
            iconSize: 90,
            color: color,
          );
  }
}