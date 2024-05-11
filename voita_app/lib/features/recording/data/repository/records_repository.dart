import 'package:flutter_sound/flutter_sound.dart';

abstract class RecordsRepository {
  Future<String> getText(Stream<Food> utterance);
}