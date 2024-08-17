import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/recording/bloc/recording_bloc.dart';
import 'package:voita_app/shared-widgets/navbar/presentation/navbar.dart';
import 'package:voita_app/shared-widgets/note-appbar/note_appbar.dart';

class RecordingScreen extends StatefulWidget {
  final Function(Note)? onNoteCreated;
  const RecordingScreen({super.key, this.onNoteCreated});

  @override
  State<RecordingScreen> createState() {
    return _NoteScreenState();
  }
}

class _NoteScreenState extends State<RecordingScreen> {
  FloatingActionButtonLocation _buttonLocation =
      FloatingActionButtonLocation.centerFloat;

  void setMicroDown() {
    setState(() {
      _buttonLocation = FloatingActionButtonLocation.centerDocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecordingBloc()..add(const OngoingRecording(text: "")),
      child: Scaffold(
        appBar: const NoteAppBar(),
        body: BlocBuilder<RecordingBloc, RecordingState>(
            builder: (context, state) {
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
                          fontWeight: FontWeight.normal),
                    ))
              ],
            );
          } else if (state is RecordingStopped) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              widget.onNoteCreated!(state.note);
              Navigator.pop(context);
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
                          fontWeight: FontWeight.normal))
                ],
              ),
            );
          } else {
            return const Text("Тут поки нічого немає");
          }
        }),
        extendBody: true,
        floatingActionButtonLocation: _buttonLocation,
        floatingActionButton: BlocBuilder<RecordingBloc, RecordingState>(
          builder: (context, state) {
            if (state is RecordingInProgress) {
              return IconButton(
                  onPressed: () {
                    BlocProvider.of<RecordingBloc>(context)
                        .add(const StopRecording());
                  },
                  icon: const Icon(
                    Icons.pause_circle_filled_outlined,
                    size: 90,
                    color: Colors.red,
                  ));
            } else if (state is RecordingStopped) {
              return const SizedBox();
            } else {
              return const Text("Init status");
            }
          },
        ),
        bottomNavigationBar: const Navbar(),
      ),
    );
  }
}
