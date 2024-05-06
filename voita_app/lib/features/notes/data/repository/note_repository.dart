import 'package:voita_app/features/notes/data/datasources/db_provider.dart';
import 'package:voita_app/features/notes/data/repository/note_repository_abs.dart';
import 'package:postgres/postgres.dart';
import 'package:voita_app/features/notes/models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  Future<Connection> _connection;

  NoteRepositoryImpl() :
     _connection = DBProvider().connection();

  @override
  Future<List<Note>> getAllNotes() async {
    final conn = await _connection;
    final notes = await conn.execute("select * from notes");
    
    final result = notes.map((row) => Note.fromMap(row.toColumnMap())).toList();
    print(result[0]);
    return notes.map((row) => Note.fromMap(row.toColumnMap())).toList();
  }

  @override
  Future<Note> getNote(int id) async {
    final conn = await _connection;
    final note = await conn.execute("SELECT * FROM Notes WHERE id=$id");
    return note.cast()[0];
  }
}