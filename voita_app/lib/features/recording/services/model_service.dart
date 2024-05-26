import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class ModelService {

  Future<String> sendToPipeline(List<int> frame) async {
    Map<String, String> body = {
      'audio_input': frame.toList().toString()
    };

    Response response = await http.post(
      Uri.parse("http://10.0.2.2:3000/process_audio"),
      body: body
    );

    return response.body;
  }

  Future<http.Response> healthCheck() {
    return http.post(Uri.parse("http://10.0.2.2:3000/check"));
  }
}