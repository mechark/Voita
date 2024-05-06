import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({ Key? key, required this.note }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: AppColor.purplishBlue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Open Sans'
              ),
            ),
            SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              ),
              child: Text(note.tags!)
            ),
            SizedBox(height: 5),
            Text(note.text),
            SizedBox(height: 5),
            Text(note.date.toString()),
          ],
        ),
    );
  }
}