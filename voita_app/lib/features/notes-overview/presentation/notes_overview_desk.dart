import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes-overview/bloc/notes_bloc.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/notes-overview/presentation/note_card.dart';
import 'package:voita_app/utils/blocs/notes_bloc/notes_bloc.dart';

class NotesOverviewDesk extends StatefulWidget {
  final List<Note> notes;
  final StatefulNavigationShell navigationShell;
  const NotesOverviewDesk({ super.key, required this.notes, required this.navigationShell });

  @override
  State<NotesOverviewDesk> createState() {
    return _NotesOverviewDeskState();
  }
}

class _NotesOverviewDeskState extends State<NotesOverviewDesk> {

  void _updateNote(Note updatedNote) {
    setState(() {
      int index = widget.notes.indexWhere((note) => note.id == updatedNote.id);
      widget.notes[index] = updatedNote;
    });
  }

  void _createNote(Note newNote) {
    setState(() {
      widget.notes.insert(0, newNote);
    });
  }

  Widget _noteCard(Note note) {
    return NoteCard(note: note, onNoteUpdated: _updateNote);
  }

  showAlertDialog(BuildContext context, Bloc bloc, int id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Ні"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Так"),
      onPressed: () {
        bloc.add(DeleteNote(id: id));
        setState(() {
          int index = widget.notes.indexWhere((note) => note.id == id);
          widget.notes.removeAt(index);
        });
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Видалення нотатки"),
      content: const Text("Ви бажаєте продовжити?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  int selectedIndex = 1;
  bool showLeading = false;
  bool showTrailing = false;
  double groupAlignment = -1.0;
  
  NavigationRailLabelType labelType = NavigationRailLabelType.none;

  ThemeData theme = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    List<Equatable> events = const <Equatable>[
      OpenSearchBar(),
      LoadNoteGroups(),
      LoadAllNotes(),
    ];

    OverlayPortalController overlayController = OverlayPortalController();

    return BlocProvider(
      create: (context) => NotesOverviewBloc(),
        child: MaterialApp(
          theme: theme,
          home: Scaffold(
          body: BlocBuilder<NotesOverviewBloc, OverviewNotesState>(builder: (context, state) { 

              return Row(
              children: <Widget>[
              NavigationRail(
                selectedIndex: widget.navigationShell.currentIndex,
                elevation: 3,
                groupAlignment: groupAlignment,
                extended: true,
                onDestinationSelected: (int index) {
                  widget.navigationShell.goBranch(
                    index,
                    initialLocation: index == widget.navigationShell.currentIndex
                  );
                },
                labelType: labelType,
                indicatorColor: AppColor.purplishBlueLight,
                leading: Column(
                  children: [
                    SizedBox(
                      width: 250,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(children: [
                        IconButton(
                          onPressed: () => {}, 
                          icon: const CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColor.spaceGray,
                            backgroundImage: AssetImage("assets/base.png"),
                          )
                        ),
                        const Text("Павло",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: 'Lato'
                          )),
                      ],),
                      IconButton(
                        icon: const Icon(Icons.dark_mode),
                        onPressed: () => setState(() {
                            theme = theme == ThemeData.dark() ? ThemeData.light() : ThemeData.dark();
                        })
                      )
                    ],),
                    ),
                    const Divider(height: 20, thickness: 20,color: Colors.black,),
                  ],
                ),
                trailing: 
                Row(
                  children: [
                    const SizedBox(height: 150),
                    SizedBox(
                    width: 110,
                    height: 40,
                    child: FloatingActionButton(
                      backgroundColor: AppColor.purplishBlue,
                      hoverColor: AppColor.darkPurple,
                      onPressed: () => {},
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text('Запис',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            fontFamily: 'Lato'
                          ),),
                        Icon(Icons.mic, size: 25,),
                      ],),
                    ))
                  ],
                ),
                destinations: const <NavigationRailDestination>[
                  NavigationRailDestination(
                    icon: Icon(Icons.search),
                    label: Text('Відкрити пошук',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Lato'
                      ))
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Додому',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Lato'
                      ),),
                    ),
                  NavigationRailDestination(
                    icon: Icon(Icons.folder_shared),
                    label: Text('Групи',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Lato'
                      ),),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.description),
                    label: Text(
                      'Усі нотатки',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        fontFamily: 'Lato'
                      ),
                    ),
                  ),
              ],
            ),
                Expanded(
                  child: widget.navigationShell
              ),
        // SizedBox(
        //   child: OverlayPortal(
        //   controller: overlayController,
        //   overlayChildBuilder: (BuildContext context) {
        //     return Positioned(
        //       child: Align(
        //         alignment: Alignment.topCenter,
        //         child: SearchBarApp(notes: widget.notes)
        //       )
        //     );
        //   },
          
        // )),
        ]);
      }))));
  }
}

