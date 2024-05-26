import 'package:flutter/material.dart';

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