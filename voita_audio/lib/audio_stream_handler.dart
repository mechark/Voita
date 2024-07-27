import 'dart:typed_data';

import 'package:flutter/services.dart';

class AudioStreamHandler {
  static const EventChannel _eventChannel = EventChannel("audio_streaming");

  Stream<Int32List> get audioStream {
    return _eventChannel.receiveBroadcastStream()
    .map((dynamic event) {
      return (event as Int32List);
    });
  }
}