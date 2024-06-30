part of 'notes_bloc.dart';

sealed class OverviewNotesEvent extends Equatable {
  const OverviewNotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNoteGroups extends OverviewNotesEvent {
  const LoadNoteGroups();

  @override
  List<Object> get props => [];
}

class LoadAllNotes extends OverviewNotesEvent {
  const LoadAllNotes();

  @override
  List<Object> get props => [];
}

class OpenSearchBar extends OverviewNotesEvent {
  const OpenSearchBar();

  @override
  List<Object> get props => [];
}