import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'voita_audio_method_channel.dart';

abstract class VoitaAudioPlatform extends PlatformInterface {
  /// Constructs a VoitaAudioPlatform.
  VoitaAudioPlatform() : super(token: _token);

  static final Object _token = Object();

  static VoitaAudioPlatform _instance = MethodChannelVoitaAudio();

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
