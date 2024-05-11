import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';

class Converter {
  static Future<Uint8List> streamToBytes(Stream<Food> stream) async {
    final bytesBuilder = BytesBuilder();
    
    await for (final food in stream) {
      if (food is FoodData) {
        if (food.data != null) {
          bytesBuilder.add(food.data!.buffer.asUint8List());
        }
      }
    }

    return bytesBuilder.toBytes();
  }
}