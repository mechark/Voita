import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/note-review/presentation/note_screen.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/utils/blocs/notes_bloc/notes_bloc.dart';
import 'package:voita_app/utils/services/context_extension.dart';
import 'package:voita_app/utils/services/time_formatter.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

    @override
    State<SearchBarApp> createState() {
      return _SearchBarAppState();
    }
}

class _SearchBarAppState extends State<SearchBarApp> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoaded) {
            void updateNote(Note updatedNote) {
              setState(() {
                int index = state.notes.indexWhere((note) => note.id == updatedNote.id);
                state.notes[index] = updatedNote;
              });
            }

            return Container(
        // constraints: context.responsive(const BoxConstraints(minWidth: 400, maxWidth: 1000), 
        //             xl: const BoxConstraints(minWidth: 150, maxWidth: 250, maxHeight: 60)),
        padding: const EdgeInsets.all(15),
        child: SearchAnchor(
          viewShape: const RoundedRectangleBorder(),
          viewBackgroundColor: Colors.white,
          viewSurfaceTintColor: Colors.white,
          dividerColor: AppColor.spaceGray,
          builder: (BuildContext context, SearchController controller) {
            return SearchBar(
              backgroundColor:
                  context.responsive(MaterialStateProperty.all(AppColor.purplishBlueLight),
                  xl: MaterialStateProperty.all(Colors.white)),
              overlayColor: MaterialStateProperty .all(Colors.white),
              shadowColor: MaterialStateProperty .all(Colors.white),
              surfaceTintColor: MaterialStateProperty .all(Colors.white),
              controller: controller,
              onChanged: (_) {
                controller.openView();
              },
              onSubmitted: (value) => {controller.clear()},
              leading: const Icon(
                Icons.search_outlined,
                weight: 800,
                size: 20,
              ),
            );
          },
          suggestionsBuilder:
              (BuildContext context, SearchController controller) {
            String query = controller.text.toLowerCase();
            List<Note> filteredNotes = state.notes.where((note) {
              String noteText = '${note.header} ${note.text}'.toLowerCase();
              return noteText.contains(query);
            }).toList();
            if (filteredNotes.isEmpty) {
              return List<Column>.generate(1, (index) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 60,
                    ),
                  ],
                );
              });
            } else {
              return List<Expanded>.generate(filteredNotes.length, (index) {
                Note note = filteredNotes[index];
                return Expanded(
                  child: 
                  Container(
                    alignment: Alignment.centerLeft,
                    constraints: context.responsive(const BoxConstraints(minWidth: 250, maxWidth: 250),
                    xl: const BoxConstraints(minWidth: 20, maxWidth: 30)),
                    margin: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: AppColor.purplishBlue,
                    ),
                    child: ListTile(
                        titleTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Open Sans',
                            fontSize: 18,
                            color: AppColor.spaceGray),
                        title: Text(note.header),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 20, width: 200),
                            Text(TimeFormatter.getDay(note.date))
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NoteScreen(
                                  note: note, onNoteUpdated: updateNote)));
                        })
                  ));
              });
            }
          },
        ));
        }       else {
        // TODO change to error message
          return const Placeholder();
        }
      }
    );
  }
}
