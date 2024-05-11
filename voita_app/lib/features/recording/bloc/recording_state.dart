part of 'recording_bloc.dart';

sealed class RecordingState extends Equatable {
  const RecordingState();
  
  @override
  List<Object> get props => [];
}

final class RecordingStarted extends RecordingState {
  const RecordingStarted();

  @override
  List<Object> get props => [];
}

final class RecordingInProgress extends RecordingState {
  final String text;

  const RecordingInProgress({required this.text});

  @override
  List<Object> get props => [text];
}

final class RecordingStopped extends RecordingState {
  const RecordingStopped();

  @override
  List<Object> get props => [];
}