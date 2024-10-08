import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:voita_audio/voita_audio_platform_interface.dart';

class AudioStreamHandler extends VoitaAudioPlatform {
  static const EventChannel _eventChannel = EventChannel("audio_streaming");
  static const MethodChannel _methodChannel = MethodChannel("set_process_name");

  @override
  Future<bool> setProcessName(String processName) async {
    String res = await _methodChannel.invokeMethod("set_process_name", processName);
    
    if (res == processName) {
      return true;
    }

    return false;
  }

  @override
  Stream<Int32List> getAudioStream() {
    return _eventChannel.receiveBroadcastStream()
    .map((dynamic event) {
      return (event as Int32List);
    });
  }
}