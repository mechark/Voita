// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Note {
  String get header => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  String get audio_location => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NoteCopyWith<Note> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res, Note>;
  @useResult
  $Res call(
      {String header,
      String text,
      DateTime date,
      int id,
      int duration,
      String audio_location});
}

/// @nodoc
class _$NoteCopyWithImpl<$Res, $Val extends Note>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? header = null,
    Object? text = null,
    Object? date = null,
    Object? id = null,
    Object? duration = null,
    Object? audio_location = null,
  }) {
    return _then(_value.copyWith(
      header: null == header
          ? _value.header
          : header // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      audio_location: null == audio_location
          ? _value.audio_location
          : audio_location // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteImplCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$NoteImplCopyWith(
          _$NoteImpl value, $Res Function(_$NoteImpl) then) =
      __$$NoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String header,
      String text,
      DateTime date,
      int id,
      int duration,
      String audio_location});
}

/// @nodoc
class __$$NoteImplCopyWithImpl<$Res>
    extends _$NoteCopyWithImpl<$Res, _$NoteImpl>
    implements _$$NoteImplCopyWith<$Res> {
  __$$NoteImplCopyWithImpl(_$NoteImpl _value, $Res Function(_$NoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? header = null,
    Object? text = null,
    Object? date = null,
    Object? id = null,
    Object? duration = null,
    Object? audio_location = null,
  }) {
    return _then(_$NoteImpl(
      header: null == header
          ? _value.header
          : header // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      audio_location: null == audio_location
          ? _value.audio_location
          : audio_location // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NoteImpl with DiagnosticableTreeMixin implements _Note {
  const _$NoteImpl(
      {required this.header,
      required this.text,
      required this.date,
      required this.id,
      required this.duration,
      required this.audio_location});

  @override
  final String header;
  @override
  final String text;
  @override
  final DateTime date;
  @override
  final int id;
  @override
  final int duration;
  @override
  final String audio_location;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Note(header: $header, text: $text, date: $date, id: $id, duration: $duration, audio_location: $audio_location)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Note'))
      ..add(DiagnosticsProperty('header', header))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('duration', duration))
      ..add(DiagnosticsProperty('audio_location', audio_location));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteImpl &&
            (identical(other.header, header) || other.header == header) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.audio_location, audio_location) ||
                other.audio_location == audio_location));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, header, text, date, id, duration, audio_location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      __$$NoteImplCopyWithImpl<_$NoteImpl>(this, _$identity);
}

abstract class _Note implements Note {
  const factory _Note(
      {required final String header,
      required final String text,
      required final DateTime date,
      required final int id,
      required final int duration,
      required final String audio_location}) = _$NoteImpl;

  @override
  String get header;
  @override
  String get text;
  @override
  DateTime get date;
  @override
  int get id;
  @override
  int get duration;
  @override
  String get audio_location;
  @override
  @JsonKey(ignore: true)
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
