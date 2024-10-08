import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:voita_audio/audio_stream_handler.dart';

import 'audio_stream_handler.dart';

abstract class VoitaAudioPlatform extends PlatformInterface {
  /// Constructs a VoitaAudioPlatform.
  VoitaAudioPlatform() : super(token: _token);

  static final Object _token = Object();

  static VoitaAudioPlatform _instance = AudioStreamHandler();

  /// The default instance of [VoitaAudioPlatform] to use.
  ///
  /// Defaults to [MethodChannelVoitaAudio].
  static VoitaAudioPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VoitaAudioPlatform] when
  /// they register themselves.
  static set instance(VoitaAudioPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> setProcessName(String processName) {
     throw UnimplementedError('setProcessName() has not been implemented.');
  }

  Stream<Int32List> getAudioStream() {
    throw UnimplementedError('getAudioStream() has not been implemented.');
  }
}
