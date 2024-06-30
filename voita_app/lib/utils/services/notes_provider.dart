import 'package:flutter/material.dart';
import 'package:voita_app/features/notes-overview/models/note_model.dart';

class NotesProvider extends ChangeNotifier {
  List<Note> _notes = <Note>[];

  List<Note> get notes => _notes;

  set notes (List<Note> updatedNotes) {
    _notes = updatedNotes;
    notifyListeners();
  }
}