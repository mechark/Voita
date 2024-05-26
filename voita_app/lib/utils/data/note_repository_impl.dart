import 'package:voita_app/utils/data/note_repository.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/utils/services/supabase_client.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl();

  final supabase = SupabaseClient.instance.client;

  @override
  Future<List<Note>> getAllNotes() async {
    final notes = await supabase.client.from('notes').select();
    return notes.map((note) => Note.fromMap(note)).toList();
  }

  @override
  Future<Note> getNote(int id) async {
    final note = await supabase.client.from('notes').select().eq('id', id);
    return note.map((note) => Note.fromMap(note)).first;
  }

  @override
  Future<void> addNote(Note note) async {
    final status = await supabase.client.from('notes').insert({'id' : note.id, 'header' : note.header, 'text' : note.text, 'date' : note.date.toString(),
        'duration' : note.duration, 'audio_location' : note.audio_location
    });

    // if (status.error != null) {
    //   throw Exception('Failed to insert note into Notes table');
    // }

  }

  @override
  Future<void> removeNote(int id) async {
    final status = await supabase.client.from('notes').delete().match({'id' : id});
    // if (status.error != null) {
    //   throw Exception('Failed to insert note into Notes table');
    // }
  }

  @override
  Future<void> updateNote(int id, String header, String text) async {
    final status = await supabase.client.from('notes').update({'header' : header, 'text' : text}).match({'id' : id});
    // if (status.error != null) {
    //   throw Exception('Failed to insert note into Notes table');
    // }
  }
}