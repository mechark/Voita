import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/note-review/presentation/note_screen.dart';
import 'package:voita_app/features/notes-overview/bloc/notes_bloc.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/utils/services/time_formatter.dart';


class NoteCard extends StatelessWidget {
  final Note note;
  final NotesBloc notesBloc;
  const NoteCard({ Key? key, required this.note, required this.notesBloc }) : super(key: key);

  @override
  Widget build(BuildContext context){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Text(
          TimeFormatter.getDay(note.date),
          style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontFamily: 'Open Sans',
                fontSize: 20,
                color: AppColor.spaceGray
        )),
        ),   
        Container(
          alignment: Alignment.centerLeft,
          constraints: const BoxConstraints(minWidth: 400, maxWidth: 1000),
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: AppColor.purplishBlue,
          ),
          child: ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NoteScreen(note: note, notesBloc: notesBloc))
            );
          },
          
          title: Text(note.header,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Open Sans'
          ),
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Container(
            //   padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
            //   decoration: const BoxDecoration(
            //   borderRadius: BorderRadius.all(Radius.circular(20)),
            //   color: Colors.white,
            //   ),
            //   child: Text(note.tags!)
            // ),
            const SizedBox(height: 5),
            Container(
              constraints: const BoxConstraints(maxHeight: 40),
              child: Text(note.text,
              style: const TextStyle(
                color: AppColor.spaceGray,
                fontFamily: "Open Sans",
                fontWeight: FontWeight.w400
              ))
            ),
            const SizedBox(height: 5),
            Text(TimeFormatter.getMinutes(note.date, note.duration)),
          ],),
        )
        )]);
  }
}