part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {
  const LoadNotes();

  @override
  List<Object> get props => [];
}

class FailedToLoad extends NotesEvent {
  final List<Note> notes;

  const FailedToLoad({this.notes = const <Note>[]});

  @override
  List<Object> get props => [notes];
}

class AddNote extends NotesEvent {
  final Note note;

  const AddNote({required this.note});

  @override
  List<Object> get props => [note];
}

class EditNote extends NotesEvent {
  final Note note;

  const EditNote({required this.note});

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final int id;

  const DeleteNote({required this.id});

  @override
  List<Object> get props => [id];
}