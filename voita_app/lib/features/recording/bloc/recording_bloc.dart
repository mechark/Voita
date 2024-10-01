import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_silero_vad/flutter_silero_vad.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/recording/data/repository/recording_repository_impl.dart';
import 'package:voita_app/features/recording/services/note_creator_service.dart';
import 'package:voita_app/features/recording/services/recorder_interface.dart';
import 'package:voita_app/features/recording/services/recorder_service_windows.dart';
import 'package:voita_app/features/recording/services/voita_recorder.dart';
import 'package:voita_app/features/recording/services/recorder_service_mobile.dart';
import 'package:voita_app/utils/api/WebSocketClient.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';
import 'package:path_provider/path_provider.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  late Recorder audioProcessor;
  final vad = FlutterSileroVad();
  final _stopWatch = Stopwatch();
  final _modelService = RecordingRepositoryImpl();
  final NoteRepositoryImpl _noteRepo = NoteRepositoryImpl();
  late StreamSubscription audioStreamSubscribition;
  String _text = "";

  RecordingBloc() : super(const RecordingInitial()) {
    on<OngoingRecording>(_onOngoingRecording);
    on<StopRecording>(_onStopRecording);

    if (Platform.isAndroid || Platform.isIOS) {
      const int frameSize = 512;
      const int sampleRate = 16000;
      audioProcessor = VoitaRecorder(RecorderServiceMobile(frameLength: frameSize, sampleRate: sampleRate)).getRecorder;
    }
    else if (Platform.isWindows) {
      audioProcessor = VoitaRecorder(RecorderServiceWindows()).getRecorder;
    }
  }

  void _addUtterance(List<int> frame) async {
    bool? recordingInProgress = await audioProcessor.isRecording;

    if (recordingInProgress!= null && recordingInProgress && !isClosed) {
      // TODO change this bullshit to something more reliable

      if (Platform.isAndroid || Platform.isIOS) {
        try {
          var audioBuffer = Float32List(512);
          for (int i = 0; i < frame.length; i++) {
            audioBuffer[i] = (frame[i] / 32768.0);
          }
          final bool? isActive = await vad.predict(audioBuffer);
          print("Max value in frame: ${frame.reduce(max)}");
          print("Min value in frame: ${frame.reduce(min)}");
          emit(const RecordingInProgress(text: ""));
          if (isActive!) {
            print("Heard me");
            // final value = await _modelService.sendToPipeline(frame);
            _text = "Heard me";
            emit(RecordingInProgress(text: _text));
          }
        } catch (e) {
          print(e);
        }
      }
      else if (Platform.isWindows) {
        //print(frame);
        WebSocketClient client = WebSocketClient();
        client.send_frame(frame);
        emit(const RecordingInProgress(text: ""));
      } 
      else {
        try {
          final value = await _modelService.sendToPipeline(frame);
          _text += value;
          emit(RecordingInProgress(text: _text));
        } catch (e) {}
      }
    }
  }

  Future<void> onnxModelToLocal(String modelPath) async {
    final data = await rootBundle.load('assets/silero-vad/silero_vad.onnx');
    final bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    File("$modelPath/silero_vad.onnx").writeAsBytesSync(bytes);
  }

  void _onOngoingRecording(OngoingRecording event, Emitter<RecordingState> emit) async {
    if (Platform.isAndroid || Platform.isIOS) {
      final directory = await getApplicationDocumentsDirectory();
      String modelPath = directory.path;
      onnxModelToLocal(modelPath);

      await vad.initialize(
          modelPath: "$modelPath/silero_vad.onnx",
          sampleRate: 16000,
          frameSize: 96,
          threshold: 0.7,
          minSilenceDurationMs: 300,
          speechPadMs: 100);

    }

    _stopWatch.start();
    await audioProcessor.startProcessing();
    audioProcessor.addListener(_addUtterance);
  }

  void _onStopRecording(StopRecording event, Emitter<RecordingState> emit) async {
      audioProcessor.stopProcessing();

      Note note = NoteCreator.constructNote(
      text: _text,
      duration: _stopWatch.elapsedMilliseconds.ceil(),
      audioLocation: "voita.com");
      // Add this _noteRepo.addNote(note); when ASR will be here
      emit(RecordingStopped(note: note));
  }
}
