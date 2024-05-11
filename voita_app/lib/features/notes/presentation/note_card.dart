import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({ Key? key, required this.note }) : super(key: key);

  @override
  Widget build(BuildContext context){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Text(
          "Суб, 20 квітня",
          style: TextStyle(
                fontWeight: FontWeight.w900,
                fontFamily: 'Open Sans',
                fontSize: 20,
                color: AppColor.spaceGray
        )),
        ),   
        Container(
        constraints: const BoxConstraints(minWidth: 400, maxWidth: 500),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppColor.purplishBlue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Open Sans'
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              ),
              child: Text(note.tags!)
            ),
            const SizedBox(height: 5),
            Text(note.text),
            const SizedBox(height: 5),
            Text(note.date.toString()),
          ],
        ),
    )]);
  }
}