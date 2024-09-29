import 'package:web_socket_channel/web_socket_channel.dart';

class Relay {
  String url;
  WebSocketChannel? channel;

  Relay({required this.url}) {
    connect();
  }

  void connect() async {
    channel = WebSocketChannel.connect(Uri.parse(url));
    await channel?.ready;

    channel?.stream.listen((message) {
      print(message);
    });
  }

  void disconnect() {
    channel?.sink.close();
  }

  void sendEvent(String event) {
    channel?.sink.add(event);
  }
}
