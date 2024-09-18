import 'package:flutter/material.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/note-review/presentation/note_screen.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/utils/services/context_extension.dart';
import 'package:voita_app/utils/services/time_formatter.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final Function(Note) onNoteUpdated;
  const NoteCard({Key? key, required this.note, required this.onNoteUpdated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      // Padding(
      //   padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      //   child: Text(
      //   TimeFormatter.getDay(note.date),
      //   style: const TextStyle(
      //         fontWeight: FontWeight.w900,
      //         fontFamily: 'Open Sans',
      //         fontSize: 20,
      //         color: AppColor.spaceGray
      // )),
      // ),
      Container(
          constraints: context.responsive(
              const BoxConstraints(minWidth: 400, maxWidth: 1000),
              xl: const BoxConstraints(
                  minWidth: 320, maxWidth: 400, minHeight: 90, maxHeight: 90)),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: context.responsive(AppColor.purplishBlue, xl: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      NoteScreen(note: note, onNoteUpdated: onNoteUpdated)));
            },
            title: Text(
              note.header,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Open Sans',
              ),
            ),
            subtitle: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
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
                        style: TextStyle(
                            color: AppColor.spaceGray,
                            fontFamily: "Open Sans",
                            fontSize: context.responsive(14, xl: 10),
                            fontWeight: FontWeight.w400))),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        TimeFormatter.getDay(note.date) ==
                                TimeFormatter.getDay(DateTime.now())
                            ? "Сьогодні"
                            : TimeFormatter.getDay(note.date),
                        style: TextStyle(
                            fontSize: context.responsive(14, xl: 10))),
                    Text(TimeFormatter.getTimeRange(note.date, note.duration),
                        style: TextStyle(
                            fontSize: context.responsive(14, xl: 10))),
                  ],
                )
              ],
            ),
          ))
    ]);
  }
}
