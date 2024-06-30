part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

final class NotesInitial extends NotesState {}

class NotesLoaded extends NotesState {
  const NotesLoaded();

  @override
  List<Object> get props => [];
}

class NotesFailedToLoad extends NotesState {
  final List<Note> notes;

  const NotesFailedToLoad({this.notes = const <Note>[]});

  @override
  List<Object> get props => [notes];
}

class NoteAdded extends NotesState {
  final Note note;

  const NoteAdded({required this.note});

  @override
  List<Object> get props => [note];
}

class NoteRemoved extends NotesState {
  final int id;

  const NoteRemoved({required this.id});

  @override
  List<Object> get props => [id];
}

class NoteGroupsLoaded extends NotesState {
  const NoteGroupsLoaded();

  @override
  List<Object> get props => [];
}

class AllNotesLoaded extends NotesState {
  const AllNotesLoaded();

  @override
  List<Object> get props => [];
}

class SearchBarOpened extends NotesState {
  const SearchBarOpened();

  @override
  List<Object> get props => [];
}