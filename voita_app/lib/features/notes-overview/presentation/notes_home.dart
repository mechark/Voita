import 'package:flutter/cupertino.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/notes-overview/presentation/note_card.dart';
import 'package:voita_app/utils/services/context_extension.dart';

class NotesHome extends StatefulWidget {
  final List<Note> notes; 
  const NotesHome({ super.key, required this.notes });

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {

  void _updateNote(Note updatedNote) {
    setState(() {
      int index = widget.notes.indexWhere((note) => note.id == updatedNote.id);
      widget.notes[index] = updatedNote;
    });
  }

  Widget _noteCard(Note note) {
    return NoteCard(note: note, onNoteUpdated: _updateNote);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Container(
                    width: 400,
                    child:ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 4, 
                    separatorBuilder: (context, index) => 
                    const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return _noteCard(widget.notes[index]);
                    },
                  )),
                  SizedBox(width: context.responsive(100),),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Placeholder()
                  )
              ]);
  }
}