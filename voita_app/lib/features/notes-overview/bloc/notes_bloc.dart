import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesOverviewBloc extends Bloc<OverviewNotesEvent, OverviewNotesState> {
  late NoteRepositoryImpl _noteRepository;

  NotesOverviewBloc() : super(NotesInitial()) {
    // on<AddNote>(_onAddNote);
    // on<EditNote>(_editNote);
    on<LoadNoteGroups>(_onLoadNoteGroups);
    on<LoadAllNotes> (_onLoadAllNotes);
    on<OpenSearchBar> (_onOpenSearchBar);
    // on<FailedToLoad>(_failedToLoad);

    _noteRepository = NoteRepositoryImpl();
  }

  void _onLoadNoteGroups (LoadNoteGroups event, Emitter<OverviewNotesState> emit) {
    emit(const NoteGroupsLoaded());
  }

  void _onLoadAllNotes (LoadAllNotes event, Emitter<OverviewNotesState> emit) {
    emit(const AllNotesLoaded());
  }

  void _onOpenSearchBar (OpenSearchBar event, Emitter<OverviewNotesState> emit) {
    emit(const SearchBarOpened());
  }
}
