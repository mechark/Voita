import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/notes-overview/presentation/note_card.dart';
import 'package:voita_app/features/search/presentation/voita_search_bar.dart';
import 'package:voita_app/utils/blocs/notes_bloc/notes_bloc.dart';
import 'package:voita_audio/voita_audio.dart';

class NotesOverviewDesk extends StatefulWidget {
  final List<Note> notes;
  final StatefulNavigationShell navigationShell;
  const NotesOverviewDesk(
      {super.key, required this.notes, required this.navigationShell});

  @override
  State<NotesOverviewDesk> createState() {
    return _NotesOverviewDeskState();
  }
}

class _NotesOverviewDeskState extends State<NotesOverviewDesk> {
  late final OverlayEntry overlayEntry;
  late final Overlay overlay;
  final VoitaAudio _recorder = VoitaAudio();
  bool fakeSearchEnabled = true;

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
  void initState() {
    super.initState();

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Expanded(
            child:
                Align(
                alignment: const Alignment(0, -0.6), 
                child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 0.8,
                  sigmaY: 0.8
                ),
                child: Container(
                  color: Colors.black.withOpacity(1),
                  child: const VoitaSearchBar()
                )
              ),
              ));
      },
    );
  }

  void showSearch() {
    setState(() => fakeSearchEnabled = false);
    final searchOverlay = Overlay.of(context);
    if (!overlayEntry.mounted) {
      searchOverlay.insert(overlayEntry);
    }
  }

  void hideSearch() {
    setState(() => fakeSearchEnabled = true);
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<NotesBloc>(context),
        child: MaterialApp(
            theme: theme,
            home: Container(
                color: Colors.black.withOpacity(0),
                child: 
              Scaffold(body:
                BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
              return Row(children: <Widget>[
                NavigationRail(
                  selectedIndex: widget.navigationShell.currentIndex,
                  elevation: 3,
                  groupAlignment: groupAlignment,
                  extended: true,
                  onDestinationSelected: (int index) {
                    widget.navigationShell.goBranch(index,
                        initialLocation:
                            index == widget.navigationShell.currentIndex);
                  },
                  labelType: labelType,
                  indicatorColor: AppColor.purplishBlueLight,
                  leading: Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                                    "Voita",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColor.spaceGray
                                    ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () => {},
                                        icon: const CircleAvatar(
                                          radius: 15,
                                          backgroundColor: AppColor.spaceGray,
                                          backgroundImage:
                                              AssetImage("assets/base.png"),
                                        )),
                                    const Text("Павло",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            fontFamily: 'Lato')),
                                  ],
                                ),
                                IconButton(
                                    icon: const Icon(Icons.dark_mode),
                                    onPressed: () => setState(() {
                                          theme = theme == ThemeData.dark()
                                              ? ThemeData.light()
                                              : ThemeData.dark();
                                        })),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TapRegion(
                              onTapInside: (tap) => showSearch(),
                              onTapOutside: (tap) => hideSearch(),
                              child: Container( 
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.spaceGray.withOpacity(0.1),
                                    spreadRadius: 0.5,
                                    blurRadius: 1,
                                    offset: const Offset(0, 2)
                                  )
                                ]
                              ),
                              height: 40,
                              width: 220,
                              child: TextField(
                              cursorColor: const Color.fromARGB(255, 107, 107, 107),
                              textAlignVertical: TextAlignVertical.center,
                              enabled: fakeSearchEnabled,
                              onTap: () {
                                
                                // showSearch();
                              },
                              // onTapOutside: () => hideSearch(),
                              // style: TextStyle(
                              //   fontFamily: 'Lato',
                              //   fontSize: 20,
                              // ),
                               decoration: const InputDecoration(
                                focusColor: AppColor.spaceGray,
                                isDense: true,
                                // labelText: 'Пошук',
                                border: InputBorder.none,
                                // border: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //     width: 0.1,
                                //     color: Color.fromARGB(255, 255, 5, 5)
                                //   ),
                                // ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 20
                                ),
                              )
                            ))),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    children: [
                      const SizedBox(height: 150),
                      SizedBox(
                          width: 110,
                          height: 40,
                          child: FloatingActionButton(
                            backgroundColor: AppColor.purplishBlue,
                            hoverColor: AppColor.darkPurple,
                            onPressed: () {
                              _recorder.getAudioStream().listen(onData);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Запис',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      fontFamily: 'Lato'),
                                ),
                                Icon(
                                  Icons.mic,
                                  size: 25,
                                ),
                              ],
                            ),
                          ))
                    ],
                  ),
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text(
                        'Додому',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: 'Lato'),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.folder_shared),
                      label: Text(
                        'Групи',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: 'Lato'),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.description),
                      label: Text(
                        'Усі нотатки',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: 'Lato'),
                      ),
                    ),
                  ],
                ),
                Expanded(child: widget.navigationShell),
              ]);
            })))));
  }

  void onData(Int32List event) {
    print(event);
  }
}