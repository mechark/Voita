import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes-overview/bloc/notes_bloc.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/notes-overview/presentation/note_card.dart';
import 'package:voita_app/features/search/presentation/search_bar.dart';
import 'package:voita_app/shared-widgets/navbar/presentation/navbar.dart';
import 'package:voita_app/shared-widgets/record-icon/presentation/record-icon.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  void _onPress() {}

  Widget _noteCard(Note note, NotesBloc notesBloc) {
    return NoteCard(note: note, notesBloc: notesBloc);
  }

  showAlertDialog(BuildContext context, Bloc bloc, int id) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Ні"),
      onPressed:  () {Navigator.of(context).pop();},
    );
    Widget continueButton = TextButton(
      child: const Text("Так"),
      onPressed:  () {
        bloc.add(DeleteNote(id: id));
        setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc()..add(const LoadNotes()),
      child: Scaffold(
        appBar: AppBar(
          actions: [
                IconButton(
                  onPressed: _onPress,
                  icon: const ImageIcon(AssetImage("assets/person.png")),
                  iconSize: 40,
                  color: AppColor.spaceGray,
                ),
            ],
        ),
        body: BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
          BlocProvider.of<NotesBloc>(context).add(const LoadNotes());
          if (state is NotesLoaded) {
            return Column(children: [
              const SearchBarApp(),
              Expanded (
                child: ListView.separated(
                itemCount: state.notes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    startActionPane: ActionPane(
                      extentRatio: 0.2,
                      motion: const StretchMotion(),
                      children: [    
                          SlidableAction(
                            icon: Icons.share,
                            backgroundColor: Colors.white,
                            foregroundColor: AppColor.spaceGray,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            onPressed: (dialogContext) => {},
                          ),        
                      ]
                    ),
                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      extentRatio: 0.2,
                      children: [ 
                            SlidableAction(
                            icon: Icons.delete,
                            foregroundColor: Colors.redAccent,
                            backgroundColor: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                            onPressed: (dialogContext) => showAlertDialog(context, 
                            BlocProvider.of<NotesBloc>(context), state.notes[index].id),
                          ),],),
                    child: _noteCard(state.notes[index], BlocProvider.of<NotesBloc>(context))
                  );
                },
              ),
              )
            ]);
          } else if (state is NotesFailedToLoad) {
            return const Text("Notes failed to load");
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
          if (state is NotesLoaded) {
            return RecordIcon(color: AppColor.spaceGray, notesBloc: BlocProvider.of<NotesBloc>(context));
          }
          else {return const SizedBox();}
        }
      ),
      bottomNavigationBar: const Navbar(),
    ));
  }
}