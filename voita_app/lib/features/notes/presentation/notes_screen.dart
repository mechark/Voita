import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes/bloc/notes_bloc.dart';
import 'package:voita_app/features/notes/models/note_model.dart';
import 'package:voita_app/features/notes/presentation/note_card.dart';
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

  Widget _noteCard(Note note) {
    return NoteCard(note: note);
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
                  icon: ImageIcon(AssetImage("assets/person.png")),
                  iconSize: 40,
                  color: AppColor.spaceGray,
                ),
            ],
        ),
        body: BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
          if (state is NotesLoaded) {
            return Column(children: [
              SearchBarApp(),
              Expanded (
                child: ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return _noteCard(state.notes[index]);
                },
              ),
              )
              
            ]);
          } else if (state is NotesFailedToLoad) {
            return Text("Notes failed to load");
          }
          else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: const RecordIcon(color: AppColor.spaceGray),
        bottomNavigationBar: const Navbar(),
      ),
    );
  }
}