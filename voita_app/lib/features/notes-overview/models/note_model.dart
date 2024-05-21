import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'note_model.freezed.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String header,
    required String text,
    required DateTime date,
    required int id,
    required int duration,
    required String audio_location
  }) = _Note;

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      header: map['header'],
      text: map['text'],
      date: map['date'],
      duration: map['duration'],
      audio_location: map['audio_location']
    );
  }
}