import 'dart:typed_data';

class Converter {
  static Future<Uint8List> streamToBytes(Stream<Uint8List> stream) async {
    final bytesBuilder = BytesBuilder();
    
    await for (final food in stream) {
      
    }

    return bytesBuilder.toBytes();
  }
}