import 'package:voita_app/features/notes/models/note_model.dart';

abstract class NoteRepository {
  Future<List<Note>> getAllNotes();
  Future<Note> getNote(int id);
}