import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/constants/app_colors.dart';
import 'package:voita_app/features/recording/bloc/recording_bloc.dart';
import 'package:voita_app/shared-widgets/record-icon/presentation/record-icon.dart';

class Recording extends StatefulWidget {
  final FloatingActionButtonLocation buttonLocation;
  const Recording({ Key? key, required this.buttonLocation}) : super(key: key);

  @override
  _RecordingState createState() => _RecordingState(this.buttonLocation);
}

class _RecordingState extends State<Recording> {

  FloatingActionButtonLocation _buttonLocation;

  _RecordingState(this._buttonLocation);
  
  void setMicroDown() {
    setState(() {
      _buttonLocation = FloatingActionButtonLocation.centerDocked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}