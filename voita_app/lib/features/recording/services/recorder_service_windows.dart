import 'dart:async';
import 'dart:typed_data';

import 'package:voita_app/features/recording/services/recorder_interface.dart';
import 'package:voita_audio/voita_audio.dart';

class RecorderServiceWindows implements Recorder {
  final VoitaAudio _voitaAudio = VoitaAudio();
  late Stream<Int32List> _audioStream;
  late StreamSubscription _audioStreamSubscribition;
  bool _isRecording = false;

  @override
  Future<void> startProcessing() async {
    _audioStream = _voitaAudio.getAudioStream();
  }

  @override
  void addListener(void Function(List<int>) listener) {
    _audioStreamSubscribition = _audioStream.listen(listener);
    if (!_audioStreamSubscribition.isPaused) {
      _isRecording = true;
    }
  }
  
  // This particular implementation doesn't provide removing of the provided listener
  // Instead it cancels subscribition to the stream, hence there is only one stream
  // May be changed later
  @override
  void removeListener(void Function(List<int>) listener) async {
    await _audioStreamSubscribition.cancel();
    if (!_audioStreamSubscribition.isPaused) {
      _isRecording = false;
    }
  }

  @override
  Future<void> stopProcessing() async {
    await _audioStreamSubscribition.cancel();
    if (!_audioStreamSubscribition.isPaused) {
      _isRecording = false;
    }
  }

  @override
  Future<bool?> get isRecording async {
    return _isRecording;
  }
}