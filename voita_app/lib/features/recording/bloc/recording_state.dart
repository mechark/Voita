part of 'recording_bloc.dart';

sealed class RecordingState extends Equatable {
  const RecordingState();

  @override
  List<Object> get props => [];
}

final class RecordingInitial extends RecordingState {
  const RecordingInitial();

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
  final Note note;

  const RecordingStopped({required this.note});

  @override
  List<Object> get props => [note];
}
