part of 'notes_bloc.dart';

sealed class OverviewNotesState extends Equatable {
  const OverviewNotesState();

  @override
  List<Object> get props => [];
}

final class NotesInitial extends OverviewNotesState {}

class NoteGroupsLoaded extends OverviewNotesState {
  const NoteGroupsLoaded();

  @override
  List<Object> get props => [];
}

class AllNotesLoaded extends OverviewNotesState {
  const AllNotesLoaded();

  @override
  List<Object> get props => [];
}

class SearchBarOpened extends OverviewNotesState {
  const SearchBarOpened();

  @override
  List<Object> get props => [];
}