import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:voita_app/features/recording/services/model_service.dart';
import 'package:voita_app/utils/data/note_repository_impl.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  late NoteRepositoryImpl _noteRepository;

  NotesBloc() : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNote>(_onAddNote);
    on<EditNote>(_editNote);
    on<DeleteNote>(_deleteNote);
    on<FailedToLoad>(_failedToLoad);

    _noteRepository = NoteRepositoryImpl();
  }

  void _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    final notes = await _noteRepository.getAllNotes();
    final service = ModelService();

    emit(NotesLoaded(notes: notes));
  }

  void _failedToLoad(FailedToLoad event, Emitter<NotesState> emit) async {
    emit(NotesFailedToLoad(notes: event.notes));
  }

  void _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    final notes = await _noteRepository.getAllNotes();
    emit(NotesLoaded(notes: notes));
  }

  void _editNote(EditNote event, Emitter<NotesState> emit) async {
  }

  void _deleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    await _noteRepository.removeNote(event.id);
    final notes = await _noteRepository.getAllNotes();
    emit(NotesLoaded(notes: notes));
  }
}
