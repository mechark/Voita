part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {
  final List<Note> notes;

  const LoadNotes({this.notes = const <Note>[]});

  @override
  List<Object> get props => [notes];
}

class FailedToLoad extends NotesEvent {
  final List<Note> notes;

  const FailedToLoad({this.notes = const <Note>[]});

  @override
  List<Object> get props => [notes];
}

class AddNote extends NotesEvent {
  final Note note;

  AddNote({required this.note});

  @override
  List<Object> get props => [note];
}

class EditNote extends NotesEvent {
  final Note note;

  EditNote({required this.note});

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final Note note;

  DeleteNote({required this.note});

  @override
  List<Object> get props => [note];
}