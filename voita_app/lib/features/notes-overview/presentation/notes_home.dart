import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/notes-overview/presentation/note_card.dart';
import 'package:voita_app/utils/blocs/notes_bloc/notes_bloc.dart';
import 'package:voita_app/utils/services/context_extension.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<NotesBloc>(context),
        child: BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
          if (state is NotesLoaded) {
            void updateNote(Note updatedNote) {
              setState(() {
                int index =
                    state.notes.indexWhere((note) => note.id == updatedNote.id);
                state.notes[index] = updatedNote;
              });
            }

            Widget noteCard(Note note) {
              return NoteCard(note: note, onNoteUpdated: updateNote);
            }

            return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 400,
                      child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 4,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (BuildContext context, int index) {
                          return noteCard(state.notes[index]);
                        },
                      )),
                  SizedBox(
                    width: context.responsive(100),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const Placeholder())
                ]);
          } else {
            print(BlocProvider.of<NotesBloc>(context).state);
            // TODO change this to the error screen or something
            return const Center(child: CircularProgressIndicator());
          }
        }));
  }
}
