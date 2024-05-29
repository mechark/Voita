import 'package:flutter/material.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/note-review/presentation/note_screen.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/notes-overview/presentation/note_card.dart';
import 'package:voita_app/utils/services/time_formatter.dart';

class SearchBarApp extends StatefulWidget {
  final List<Note> notes;
  const SearchBarApp({ Key? key, required this.notes }) : super(key: key);

  @override
  _SearchBarAppState createState() => _SearchBarAppState();
}



class _SearchBarAppState extends State<SearchBarApp> {

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
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SearchAnchor(
        viewBackgroundColor: Colors.white,
        viewSurfaceTintColor: Colors.white,
        dividerColor: AppColor.spaceGray,
        builder:(BuildContext context, SearchController controller) {
          return SearchBar(
            backgroundColor: MaterialStateProperty.all(AppColor.purplishBlueLight),
            overlayColor: MaterialStateProperty.all(Colors.white),
            shadowColor: MaterialStateProperty.all(Colors.white),
            surfaceTintColor: MaterialStateProperty.all(Colors.white),
            controller: controller,
            onChanged: (_) {
                controller.openView();
              },
            leading: const ImageIcon(
              AssetImage("assets/search.png"),
              size: 30,  
            ),
            
          );
        },
        suggestionsBuilder: (BuildContext context, SearchController controller) {
            String query = controller.text.toLowerCase();
            List<Note> filteredNotes = widget.notes.where((note) {
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
                      ],);
                });
              }
            else {
              return List<Container>.generate(filteredNotes.length, (index) {
              Note note = filteredNotes[index];
                return Container(
                alignment: Alignment.centerLeft,
                constraints: const BoxConstraints(minWidth: 400, maxWidth: 1000),
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: AppColor.purplishBlue,
                ),
                child: ListTile(
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Open Sans',
                  fontSize: 18,
                  color: AppColor.spaceGray
                ),
                title: Text(note.header),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Container(
                    height: 20,
                    width: 200,
                    child: Text(note.text)),
                    Text(TimeFormatter.getDay(note.date))
                  ],),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NoteScreen(note: note, onNoteUpdated: _updateNote))
                  );
                }
              ));
            }
          );
          } 
        },
      )
    );
  }
}