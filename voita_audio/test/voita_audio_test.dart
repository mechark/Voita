import 'package:flutter_test/flutter_test.dart';
import 'package:voita_audio/voita_audio.dart';
import 'package:voita_audio/voita_audio_platform_interface.dart';
import 'package:voita_audio/voita_audio_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVoitaAudioPlatform
    with MockPlatformInterfaceMixin
    implements VoitaAudioPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VoitaAudioPlatform initialPlatform = VoitaAudioPlatform.instance;

  test('$MethodChannelVoitaAudio is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVoitaAudio>());
  });

  test('getPlatformVersion', () async {
    VoitaAudio voitaAudioPlugin = VoitaAudio();
    MockVoitaAudioPlatform fakePlatform = MockVoitaAudioPlatform();
    VoitaAudioPlatform.instance = fakePlatform;

    expect(await voitaAudioPlugin.getPlatformVersion(), '42');
  });
}
