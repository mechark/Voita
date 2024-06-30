import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  late NoteRepositoryImpl _noteRepository;

  NotesBloc() : super(const NotesLoaded()) {
    on<LoadNotes>(_onLoadNotes);
    // on<AddNote>(_onAddNote);
    // on<EditNote>(_editNote);
    on<DeleteNote>(_onDeleteNote);
    on<LoadNoteGroups>(_onLoadNoteGroups);
    on<LoadAllNotes> (_onLoadAllNotes);
    on<OpenSearchBar> (_onOpenSearchBar);
    // on<FailedToLoad>(_failedToLoad);

    _noteRepository = NoteRepositoryImpl();
  }

  void _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) {
    emit(const NotesLoaded());
  }

  void _onLoadNoteGroups (LoadNoteGroups event, Emitter<NotesState> emit) {
    emit(const NoteGroupsLoaded());
  }

  void _onLoadAllNotes (LoadAllNotes event, Emitter<NotesState> emit) {
    emit(const AllNotesLoaded());
  }

  void _onOpenSearchBar (OpenSearchBar event, Emitter<NotesState> emit) {
    emit(const SearchBarOpened());
  }

  // void _failedToLoad(FailedToLoad event, Emitter<NotesState> emit) async {
  //   emit(NotesFailedToLoad(notes: event.notes));
  // }

  // void _onAddNote(AddNote event, Emitter<NotesState> emit) async {
  //   emit(const NotesLoaded());
  // }

  void _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    await _noteRepository.removeNote(event.id);
    emit(const NotesLoaded());
  }
}
