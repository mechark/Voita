import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'voita_audio_platform_interface.dart';

/// An implementation of [VoitaAudioPlatform] that uses method channels.
class MethodChannelVoitaAudio extends VoitaAudioPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('voita_audio');
  
  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}