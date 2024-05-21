import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_voice_processor/flutter_voice_processor.dart';
import 'package:http/http.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/recording/services/model_service.dart';
import 'package:voita_app/features/recording/services/note_creator_service.dart';
import 'package:voita_app/features/recording/services/recorder_service.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';
import 'package:voita_app/utils/services/string_extension.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final RecorderService _recorder = RecorderService(frameLength: 1024, 
                                                    sampleRate: 16000);
  final _stopWatch = Stopwatch();
  final _ModelService = ModelService();
  final NoteRepositoryImpl _noteRepo = NoteRepositoryImpl();
  bool isRecording = true;
  String _text = "";

  RecordingBloc() : super(const RecordingInProgress(text: "")) {
    on<OngoingRecording>(_onOngoingRecording);
    on<StopRecording>(_onStopRecording);
  }

  void _addUtterance(List<int> frame) async {
    if (isRecording) {
        _text += frame[0].toString();
        emit(RecordingInProgress(text: _text));
    }
  }

  void _onOngoingRecording (OngoingRecording event, Emitter<RecordingState> emit) async {
    _recorder.addListener(_addUtterance);
    await _recorder.startProcessing();
    _stopWatch.start();
  }

  void _onStopRecording(StopRecording event, Emitter<RecordingState> emit) async {
    isRecording = false;
    await _recorder.stop();
    _stopWatch.stop();

    Note note = NoteCreator.constructNote(text: _text, 
    duration: _stopWatch.elapsedMilliseconds.ceil(), 
    audioLocation: "voita.com");
    _noteRepo.addNote(note);

    emit(RecordingStopped(note: note));
  }
}