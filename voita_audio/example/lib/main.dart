import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:voita_audio/voita_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _platformVersion = 'Unknown';
  final _voitaAudioPlugin = VoitaAudio();
  late Stream<Int32List> audioStream;
  late StreamSubscription audioStreamSubscribition;
  bool isStreaming = false;
  int frameSample = 0;
 
  @override
  void initState() {
    super.initState();
  }

  void cancelRecording() async {
    await audioStreamSubscribition.cancel();
  }

  void onData(Int32List frame) {
    setState(() {
      frameSample = frame[0];
    });
    print(frame[0]);
  }

  void getFrames() async {
    if (isStreaming) {
      isStreaming = false;
      cancelRecording();
      return;
    }
    isStreaming = true;
    audioStream = _voitaAudioPlugin.getAudioStream();
    audioStreamSubscribition = audioStream.listen(onData);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children: [
            Text('Running on: $_platformVersion\n'),
            Text("UI is not dead! $frameSample"),
            TextButton(
              onPressed: getFrames,
              child: const Text("Press"),
            )
          ]
        ),
      ),
    ));
  }
}