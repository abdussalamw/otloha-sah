import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/network_helper/dio_utils.dart';

void main() {
  test('test quran download', () async {
    Apis.authorization = 'yR1i2lD66Rnoxli1iXpJ8abLVJX568';
    Apis.clientId = 'MsD8fKDIbNsQV1gsqTCKrJosAVKuiZqM64dRinN6';
    Apis.clientSecret =
        'f56VHUcwXRJToxbZMKZnmIjkHTESOMsVumzdnc18RuyPofcKuO3v04smE25HDg9i9jBjhO3nUUEHIA0RgxOQB5zym4k6VQkizU69mwXlJOND0V2G06txJdyxRQfgrP6e';
    DioUtils.initDio();
    Response response = await DioUtils.dio!.download(
        'https://api.tag-recycling.com/api/v1/narrations/1/download/', '');
    print(response.data);
  });
}
