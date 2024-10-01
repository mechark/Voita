import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:3000/audio'));

  void send_frame(List<int> frame) {
    var data = {"frame": frame.toList()};
    channel.sink.add(jsonEncode(data));
  }

  void close_connectino() {
    channel.sink.close();
  }
}