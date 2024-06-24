// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      header: json['header'] as String,
      text: json['text'] as String,
      date: DateTime.parse(json['date'] as String),
      id: (json['id'] as num).toInt(),
      duration: (json['duration'] as num).toInt(),
      audioLocation: json['audioLocation'] as String,
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'header': instance.header,
      'text': instance.text,
      'date': instance.date.toIso8601String(),
      'id': instance.id,
      'duration': instance.duration,
      'audioLocation': instance.audioLocation,
    };
