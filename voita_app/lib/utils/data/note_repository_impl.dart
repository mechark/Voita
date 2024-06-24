import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voita_app/utils/data/note_repository.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl();

  final supabase = Supabase.instance.client;

  @override
  Future<List<Note>> getAllNotes() async {
    final notes = await supabase.from('notes').select();
    return notes.map((note) => Note.fromMap(note)).toList();
  }

  @override
  Future<Note> getNote(int id) async {
    final note = await supabase.from('notes').select().eq('id', id);
    return note.map((note) => Note.fromMap(note)).first;
  }

  @override
  Future<void> addNote(Note note) async {
    await supabase.from('notes').insert({
      'id': note.id,
      'header': note.header,
      'text': note.text,
      'date': note.date.toString(),
      'duration': note.duration,
      'audio_location': note.audioLocation
    });

    // if (status.error != null) {
    //   throw Exception('Failed to insert note into Notes table');
    // }
  }

  @override
  Future<void> removeNote(int id) async {
    await supabase.from('notes').delete().match({'id': id});
    // if (status.error != null) {
    //   throw Exception('Failed to insert note into Notes table');
    // }
  }

  @override
  Future<void> updateNote(int id, String header, String text) async {
    await supabase
        .from('notes')
        .update({'header': header, 'text': text}).match({'id': id});
    // if (status.error != null) {
    //   throw Exception('Failed to insert note into Notes table');
    // }
  }
}
