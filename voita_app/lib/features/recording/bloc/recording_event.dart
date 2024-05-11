part of 'recording_bloc.dart';

sealed class RecordingEvent extends Equatable {
  const RecordingEvent();

  @override
  List<Object> get props => [];
}

class StartRecording extends RecordingEvent {

  const StartRecording();

  @override
  List<Object> get props => [];
}

class OngoingRecording extends RecordingEvent {
  final String text;

  const OngoingRecording({required this.text});

  @override
  List<Object> get props => [text];
}

class StopRecording extends RecordingEvent {
  const StopRecording();

  @override
  List<Object> get props => [];
}