import 'dart:async';
import 'dart:isolate';

import 'package:flutter_sound/flutter_sound.dart';

class RecorderService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  Future<void> recordToFile({required String toFile}) async {
    await _recorder.openRecorder();

    return _recorder.startRecorder(
          toFile: toFile,
          codec: Codec.pcm16WAV,
          sampleRate: 16000,
      );
  }

  Future<void> _recordToStream(List<dynamic> args) async {
      return await _recorder.startRecorder(
          toStream: args[0],
          codec: Codec.pcm16,
          sampleRate: 16000,
          bufferSize: 20480
        );
  }

  Future<void> recordToStream({required StreamSink<Food> toStream}) async {
    await _recorder.openRecorder();
    
    await _recorder.startRecorder(
          toStream: toStream,
          codec: Codec.pcm16,
        );
  }

  Future<void> stopRecorder() async {
    await _recorder.stopRecorder();
  }

  void dispose() {
    _recorder.closeRecorder();
  }

  bool get isRecording {
    return _recorder.isRecording;
  }
}