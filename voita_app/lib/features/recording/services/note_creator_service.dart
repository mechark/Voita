import 'package:voita_app/features/notes-overview/models/note_model.dart';
import 'dart:math';

class NoteCreator {
  static Note constructNote({required String text, required int duration, required String audioLocation}) {
    Random random = Random();
    int id = random.nextInt(1000000);

    return Note(
      header: "Нотатка", 
      text: text, 
      date: DateTime.now(), 
      id: id,
      duration: duration,
      audio_location: audioLocation
    );
  }  
}