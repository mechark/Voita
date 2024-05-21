import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:voita_app/features/recording/data/repository/records_repository.dart';
import 'package:voita_app/utils/services/converter.dart';

class RecordsRepositoryImpl implements RecordsRepository {
  
  static const String apiUrl = 'https://api-inference.huggingface.co/models/Yehor/w2v-bert-2.0-uk';
  static const headers = {'Authorization': 'Bearer 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'};

  @override
  Future<String> getText(Stream<Uint8List> utterance) async {
    print("In getText method");
    Uint8List utteranceBytes = await Converter.streamToBytes(utterance);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: utteranceBytes,
    );

    String res = response.body;
    return response.body;
  }
}