
import 'dart:typed_data';

import 'voita_audio_platform_interface.dart';

class VoitaAudio {
  Stream<Int32List> getAudioStream() {
    return VoitaAudioPlatform.instance.getAudioStream();
  }
}
