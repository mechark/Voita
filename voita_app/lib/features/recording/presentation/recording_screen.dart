import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes-overview/bloc/notes_bloc.dart';
import 'package:voita_app/features/recording/bloc/recording_bloc.dart';
import 'package:voita_app/shared-widgets/navbar/presentation/navbar.dart';
import 'package:voita_app/shared-widgets/note-appbar/note_appbar.dart';
import 'package:voita_app/shared-widgets/record-icon/presentation/record-icon.dart';

class RecordingScreen extends StatefulWidget {
  NotesBloc ?notesBloc;
  RecordingScreen({ Key? key, this.notesBloc }) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<RecordingScreen> {
  FloatingActionButtonLocation _buttonLocation = FloatingActionButtonLocation.centerFloat; 

  void setMicroDown() {
    setState(() {
      _buttonLocation = FloatingActionButtonLocation.centerDocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecordingBloc()..add(const OngoingRecording(text: "")),
      child: BlocBuilder<RecordingBloc, RecordingState> (builder: (context, state) {
      return Scaffold(
          appBar: const NoteAppBar(),
          body: BlocBuilder<RecordingBloc, RecordingState> (builder: (context, state) {
            if (state is RecordingInProgress) {
              return ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Text(
                      state.text,
                      style: const TextStyle(
                        color: AppColor.spaceGray,
                        fontSize: 18,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.normal
                      ),
                    )
                  )
                ],
              );
            } 
            else if (state is RecordingStopped) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                widget.notesBloc?.add(AddNote(note: state.note));
              });

              return Container(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column(
                  children: [
                    Text(state.note.text,
                    style: const TextStyle(
                        color: AppColor.spaceGray,
                        fontSize: 18,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.normal
                      )
                    )
                  ],
                ),
              );
            }
            else {
              return Container(
                child: const Text("Тут поки нічого немає"),
              );
            }
          }),
        extendBody: true,
        floatingActionButtonLocation: _buttonLocation,
        floatingActionButton: BlocBuilder<RecordingBloc, RecordingState> 
            (builder: (context, state) { 
            if (state is RecordingInProgress) {
              return IconButton(
              onPressed: () async {
                setMicroDown();
                BlocProvider.of<RecordingBloc>(context).add(const StopRecording());
              },
              icon: const ImageIcon(AssetImage("assets/stop-button.png")),
              iconSize: 90,
              color: Colors.red,
          );
          }
          else if (state is RecordingStopped) {
              return const RecordIcon(color: AppColor.spaceGray);
            }
          else {
            print("Something went wrong");
            print("State ${state.toString()}");
            return const RecordIcon(color: AppColor.spaceGray);
          }
      },
      ),
        bottomNavigationBar: const Navbar(),
    );},
    ));
  }
}