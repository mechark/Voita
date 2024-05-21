import 'dart:async';
import 'package:flutter_voice_processor/flutter_voice_processor.dart';

class RecorderService {
  final int frameLength;
  final int sampleRate;
  VoiceProcessor ?_voiceProcessor;

  RecorderService({required this.frameLength, required this.sampleRate}) : 
      _voiceProcessor = VoiceProcessor.instance;

  Future<void> startProcessing() async {
    if (_voiceProcessor != null) {
      return await _voiceProcessor!.start(frameLength, sampleRate);
    }
    throw Exception('Failed to start audio recording. Voice Processor has a null value');
  }

  void addListener(void Function(List<int>) listener) {
    if (_voiceProcessor != null) {
      _voiceProcessor!.addFrameListener(listener);
    }
  }

  Future<void> stop() async {
    if (_voiceProcessor != null) {
      await _voiceProcessor!.stop();
    }
  }

  Future<bool?> get isRecording async {
    if (_voiceProcessor != null) {
      return await _voiceProcessor!.isRecording();
    }
    return Future(() => false);
  }
}