
import 'voita_audio_platform_interface.dart';

class VoitaAudio {
  Future<String?> getPlatformVersion() {
    return VoitaAudioPlatform.instance.getPlatformVersion();
  }
}
