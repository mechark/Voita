import 'package:http/http.dart';

abstract class RecordingRepository {
  Future<String> sendToPipeline(List<int> frame);
  Future<Response> healthCheck();
}