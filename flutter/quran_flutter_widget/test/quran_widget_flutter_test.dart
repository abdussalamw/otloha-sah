import 'package:flutter_test/flutter_test.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

void main() {
  test('uses an HTTPS endpoint without embedded OAuth credentials', () {
    expect(Apis.baseUrl, startsWith('https://'));
    expect(Apis.authorization, isEmpty);
  });
}
