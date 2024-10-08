
import 'dart:typed_data';

import 'voita_audio_platform_interface.dart';

class VoitaAudio {
  Future<bool> setProcessName(String processName) async {
    return await VoitaAudioPlatform.instance.setProcessName(processName);
  }

  Stream<Int32List> getAudioStream() {
    return VoitaAudioPlatform.instance.getAudioStream();
  }
}