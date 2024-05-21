import 'package:voita_app/features/notes-overview/models/note_model.dart';

abstract class NoteRepository {
  Future<List<Note>> getAllNotes();
  Future<Note> getNote(int id);
  Future<void> addNote(Note note);
  Future<void> removeNote(int id);
  Future<void> updateNote(int id, String header, String text);
}