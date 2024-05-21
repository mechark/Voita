import 'package:http/http.dart' as http;
import 'dart:convert';

class ModelService {

  Future<http.Response> sendToPipeline(List<int> frame) {
    Map<String, String> body = {
      'audio_input': frame.toList().toString()
    };

    return http.post(
      Uri.parse("http://10.0.2.2:3000/process_audio"),
      body: body
    );
  }

  Future<http.Response> healthCheck() {
    return http.post(Uri.parse("http://10.0.2.2:3000/check"));
  }
}