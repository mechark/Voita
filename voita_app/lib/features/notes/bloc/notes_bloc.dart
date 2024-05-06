import 'dart:ffi';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:voita_app/features/notes/data/repository/note_repository.dart';
import 'package:voita_app/features/notes/models/note_model.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepositoryImpl _noteRepository;

  NotesBloc(this._noteRepository) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<EditNote>(_editNote);
    on<DeleteNote>(_deleteNote);
    on<FailedToLoad>(_failedToLoad);
  }

  void _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    final notes = await _noteRepository.getAllNotes();
    emit(NotesLoaded(notes: notes));
  }

  void _failedToLoad(FailedToLoad event, Emitter<NotesState> emit) async {
    emit(NotesFailedToLoad(notes: event.notes));
  }

  void _onAddNote(AddNote event, Emitter<NotesState> emit) {
    
  }

  void _editNote(EditNote event, Emitter<NotesState> emit) {
    
  }

  void _deleteNote(DeleteNote event, Emitter<NotesState> emit) {
    
  }
}
