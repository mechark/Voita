import 'dart:typed_data';

abstract class RecordsRepository {
  Future<String> getText(Stream<Uint8List> utterance);
}