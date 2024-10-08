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
  Future<void> startProcessing(String ? whereToRecord) async {
    assert(whereToRecord != null);
    bool res = await _voitaAudio.setProcessName(whereToRecord!);
    if (res) {
      _audioStream = _voitaAudio.getAudioStream();
    }
    else {
      throw Exception("Couldn't start audio processing!");
    }
  }

  @override
  void addListener(void Function(List<int>) listener) {
    _audioStreamSubscribition = _audioStream.listen(listener);
    _audioStreamSubscribition.onDone(onStopProcessing);
      _isRecording = true;
  }
  
  // This particular implementation doesn't provide removing of the provided listener
  // Instead it cancels subscribition to the stream, hence there is only one stream
  // May be changed later
  @override
  void removeListener(void Function(List<int>) listener) async {
    await _audioStreamSubscribition.cancel();
    _audioStreamSubscribition.onDone(() =>_isRecording = false);
    if (!_audioStreamSubscribition.isPaused) {
      _isRecording = false;
    }
  }

  @override
  Future<void> stopProcessing() async {
    await _audioStreamSubscribition.cancel();
  }

  void onStopProcessing() {
    _isRecording = false;
  }

  @override
  Future<bool?> get isRecording async {
    return _isRecording;
  }
}