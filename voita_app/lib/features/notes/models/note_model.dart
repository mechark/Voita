import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'note_model.freezed.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String name,
    required String text,
    String? tags, 
    required DateTime date,
    required int note_id,
  }) = _Note;

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      note_id: map['note_id'],
      name: map['name'],
      text: map['text'],
      tags: map['tags'],
      date: map['date']
    );
  }
}