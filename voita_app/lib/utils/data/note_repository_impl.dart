import 'package:voita_app/utils/data/note_repository.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'package:voita_app/utils/data/db_provider.dart';

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl();

  @override
  Future<List<Note>> getAllNotes() async {
    final conn = await DBProvider.getConnection();

    if (conn.isOpen) {
      final notes = await conn.execute("SELECT * FROM notes ORDER BY date DESC");
      conn.close();
      return notes.map((row) => Note.fromMap(row.toColumnMap())).toList();
    } else {throw Exception("Can't get all notes. Connection didn't open successfully");}
  }

  @override
  Future<Note> getNote(int id) async {
    final conn = await DBProvider.getConnection();
    final note = await conn.execute("SELECT * FROM notes WHERE id=$id");

    conn.close();
    return note.map((row) => Note.fromMap(row.toColumnMap())).first;
  }

  @override
  Future<void> addNote(Note note) async {
    final conn = await DBProvider.getConnection();

    if (conn.isOpen) {
      final success = await conn.execute(''' INSERT INTO notes(id, header, text, date, duration, audio_location) VALUES  
        ('${note.id}', '${note.header}', '${note.text}', 
        '${note.date}', '${note.duration}', '${note.audio_location}')''');
    }
    else{
      throw Exception("Can't add the note, connection is not open");
    }

    conn.close();
  }

  @override
  Future<void> removeNote(int id) async {
    final conn = await DBProvider.getConnection();

    if (conn.isOpen) {
      final success = await conn.execute(''' DELETE FROM notes WHERE id='$id' ''');
    } 
    else {
      throw Exception("Can't remove the note, connection is not open");
    }

    conn.close();
  }

  @override
  Future<void> updateNote(int id, String header, String text) async {
    final conn = await DBProvider.getConnection();

    if (conn.isOpen) {
      final success = await conn.execute(''' UPDATE notes SET header='$header', text='$text' WHERE id='$id'; ''');
    }
    else {
      throw Exception("Can't update the note, connection is not open");
    }
  }
}