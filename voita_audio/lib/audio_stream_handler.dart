import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:voita_audio/voita_audio_platform_interface.dart';

class AudioStreamHandler extends VoitaAudioPlatform {
  static const EventChannel _eventChannel = EventChannel("audio_streaming");

  @override
  Stream<Int32List> getAudioStream() {
    return _eventChannel.receiveBroadcastStream()
    .map((dynamic event) {
      return (event as Int32List);
    });
  }
}