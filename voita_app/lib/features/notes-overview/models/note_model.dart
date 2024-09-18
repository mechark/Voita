import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'note_model.freezed.dart';
part 'note_model.g.dart';

@unfreezed
class Note with _$Note {
  factory Note(
      {required String header,
      required String text,
      required final DateTime date,
      required final int id,
      required final int duration,
      required final String audioLocation}) = _Note;

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
        id: map['id'],
        header: map['header'] ?? "Нотатка",
        text: map['text'],
        date: DateTime.parse(map['date']),
        duration: map['duration'],
        audioLocation: map['audio_location']);
  }

  factory Note.fromJson(Map<String, Object?> json) => _$NoteFromJson(json);
}
