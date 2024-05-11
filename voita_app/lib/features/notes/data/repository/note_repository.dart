import 'package:voita_app/features/notes/data/repository/note_repository_abs.dart';
import 'package:postgres/postgres.dart';
import 'package:voita_app/features/notes/models/note_model.dart';
import 'package:voita_app/utils/data/db_provider.dart';

class NoteRepositoryImpl implements NoteRepository {
  final Future<Connection> _connection;

  NoteRepositoryImpl() :
    _connection = DBProvider.getConnection();

  @override
  Future<List<Note>> getAllNotes() async {
    final conn = await _connection;
    final notes = await conn.execute("select * from notes");

    conn.close();
    return notes.map((row) => Note.fromMap(row.toColumnMap())).toList();
  }

  @override
  Future<Note> getNote(int id) async {
    final conn = await _connection;
    final note = await conn.execute("SELECT * FROM Notes WHERE id=$id");

    conn.close();
    return note.cast()[0];
  }
}