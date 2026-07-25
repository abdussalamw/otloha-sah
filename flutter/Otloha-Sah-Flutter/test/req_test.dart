import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  test('verses list', () async {
    var channel = IOWebSocketChannel.connect(
      Uri.parse('app.tag-recycling.com/'),
    );

    channel.stream.listen((message) {});
  });
}
