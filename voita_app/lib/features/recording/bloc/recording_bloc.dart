import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:voita_app/features/recording/data/repository/records_repository_impl.dart';
import 'package:voita_app/features/recording/services/recorder_service.dart';
import 'package:voita_app/utils/data/db_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:voita_app/utils/services/converter.dart';

part 'recording_event.dart';
part 'recording_state.dart';

class RecordingBloc extends Bloc<RecordingEvent, RecordingState> {
  final _recordsRepository = RecordsRepositoryImpl();
  final _recorder = RecorderService();

  RecordingBloc() : super(const RecordingInProgress(text: "")) {
    on<OngoingRecording>(_onOngoingRecording);
    on<StopRecording>(_onStopRecording);
  }

  void _onOngoingRecording (OngoingRecording event, Emitter<RecordingState> emit) async {
    print("I am in _onOngoingRecording");
    // await _recorder.recordToStream(toStream: audioStreamController.sink);

    final isolate = await FlutterIsolate.spawn(_addUtterance, "Hey");

    emit(RecordingInProgress(text: "text"));
  }

  @pragma('vm:entry-point')
  static void _addUtterance(String args) async {
    print("In _addUtteaudioStreamControllerrance");
    StreamController<Food> audioStreamController = StreamController<Food>.broadcast();
    print("In updateAudio");
    var updateAudio = audioStreamController.sink;
    print("In RecordsRepositoryImpl");
    final _rep = RecordsRepositoryImpl();
    var text;

    print("In RecorderService");
    final isolatedRecorder = RecorderService();
    print("In recordToStream");
    await isolatedRecorder.recordToStream(toStream: audioStreamController.sink);

    print("In audioStreamController.stream.listen((event) async");
    audioStreamController.stream.listen((event) async {
      if (event is FoodData) {
        // TODO sending audio chunks to the server and there is the oldman with a pipeline
        print("In updateAudio.add(event);");
        updateAudio.add(event);
        print("Data ${event.data}");
        // text = _rep.getText(audioStreamController.stream) as String;
      }
    });

    // final byteStream = await Converter.streamToBytes(audioStreamController.stream);
    print("Out runMyIsolate $text");
  }

  void _onStopRecording(StopRecording event, Emitter<RecordingState> emit) async {
    if (_recorder.isRecording) {
      print("Recorder status: ${_recorder.isRecording}");
      _recorder.stopRecorder();
      _recorder.dispose();
    }
  }
}
