import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/recording/bloc/recording_bloc.dart';
import 'package:voita_app/features/recording/data/repository/records_repository_impl.dart';
import 'package:voita_app/features/recording/presentation/recording.dart';
import 'package:voita_app/features/recording/services/recorder_service.dart';
import 'package:voita_app/shared-widgets/navbar/presentation/navbar.dart';
import 'package:voita_app/shared-widgets/record-icon/presentation/record-icon.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({ Key? key }) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  FloatingActionButtonLocation _buttonLocation = FloatingActionButtonLocation.centerFloat; 
  // final RecorderService _recorder = RecorderService();

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
          appBar: AppBar(
            title: const Text(
                "Нотатка",
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold
                ),
              ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: (){}, 
                icon: const ImageIcon(AssetImage("assets/share.png"),
                      size: 25,
                      color: AppColor.spaceGray,
                )
              )
            ],
          ),
          body: BlocBuilder<RecordingBloc, RecordingState> (builder: (context, state) {
            if (state is RecordingInProgress) {
              return Column(
                  children: [
                    Text(state.text)
                  ],
                );
            } else {
              print("Something went wrong");
              return Container();
            }
          }),

        extendBody: true,
        floatingActionButtonLocation: _buttonLocation,
        floatingActionButton: BlocBuilder<RecordingBloc, RecordingState> 
            (builder: (context, state) { 
            if (state is RecordingInProgress) {
              print("State text from widget point of view ${state.text}");
              print("State ${state.toString()}");
              return IconButton(
              onPressed: () {
                setMicroDown();
                BlocProvider.of<RecordingBloc>(context).emit(const RecordingStopped());
                //BlocProvider.of<RecordingBloc>(context).recorder.dispose();
                print("State ${state.toString()}");
              },
              icon: ImageIcon(AssetImage("assets/stop-button.png")),
              iconSize: 90,
              color: Colors.red,
          );
          }
          else if (state is RecordingStopped) {
              print("State ${state.toString()}");
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