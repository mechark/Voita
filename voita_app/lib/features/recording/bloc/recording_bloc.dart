import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/features/recording/data/repository/recording_repository_impl.dart';
import 'package:voita_app/features/recording/services/note_creator_service.dart';
import 'package:voita_app/features/recording/services/recorder_service.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final RecorderService _recorder = RecorderService(frameLength: 32768, 
                                                    sampleRate: 16000);
  final _stopWatch = Stopwatch();
  final _modelService = RecordingRepositoryImpl();
  final NoteRepositoryImpl _noteRepo = NoteRepositoryImpl();
  bool isRecording = true;
  String _text = "";

  RecordingBloc() : super(const RecordingInProgress(text: "")) {
    on<OngoingRecording>(_onOngoingRecording);
    on<StopRecording>(_onStopRecording);
  }

  void _addUtterance(List<int> frame) async {
    bool? recordingInProgress = await _recorder.isRecording;

    if (recordingInProgress! && !isClosed) {
      // TODO change this bullshit to something more reliable
      try {
        final value = await _modelService.sendToPipeline(frame);
        _text += value;
        emit(RecordingInProgress(text: _text));
        } catch (e) {}
      }
  }

  void _onOngoingRecording (OngoingRecording event, Emitter<RecordingState> emit) async {
    _recorder.addListener(_addUtterance);
    await _recorder.startProcessing();
    _stopWatch.start();
  }

  void _onStopRecording(StopRecording event, Emitter<RecordingState> emit) async {
    _recorder.stop();

    isRecording = false;
    _recorder.removeListener(_addUtterance);
    _stopWatch.stop();

    Note note = NoteCreator.constructNote(text: _text, 
    duration: _stopWatch.elapsedMilliseconds.ceil(), 
    audioLocation: "voita.com");
    _noteRepo.addNote(note);

    emit(RecordingStopped(note: note));
  }
}