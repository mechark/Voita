import 'dart:async';
import 'package:flutter_voice_processor/flutter_voice_processor.dart';
import 'package:voita_app/features/recording/services/recorder_interface.dart';

class RecorderServiceMobile implements Recorder {
  final int frameLength;
  final int sampleRate;
  final VoiceProcessor? _voiceProcessor;

  RecorderServiceMobile({required this.frameLength, required this.sampleRate})
      : _voiceProcessor = VoiceProcessor.instance;

  @override
  Future<void> startProcessing() async {
    if (_voiceProcessor != null) {
      return await _voiceProcessor.start(frameLength, sampleRate);
    }
    throw Exception('Failed to start audio recording. Voice Processor is of a null type');
  }

  @override
  void addListener(void Function(List<int>) listener) {
    if (_voiceProcessor != null) {
      _voiceProcessor.addFrameListener(listener);
    } else {
      throw Exception('VoiceProcessor has a null type');
    }
  }

  @override
  void removeListener(void Function(List<int>) listener) {
    if (_voiceProcessor != null) {
      _voiceProcessor.removeFrameListener(listener);
    } else {
      throw Exception('VoiceProcessor has a null type');
    }
  }

  @override
  Future<void> stopProcessing() async {
    if (_voiceProcessor != null) {
      await _voiceProcessor.stop();
    } else {
      throw Exception('VoiceProcessor has a null type');
    }
  }

  Future<bool?> get isRecording async {
    if (_voiceProcessor != null) {
      return await _voiceProcessor.isRecording();
    }
    return Future(() => false);
  }
}
