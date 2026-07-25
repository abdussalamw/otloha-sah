import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class FileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print('Path ${directory.path}');
    return directory.path;
  }

  Future<File?> _createFile(String savePath) async {
    String temp = await _localPath;

    File? file;

    try {
      file = File(temp + savePath);
      file = await file.create(recursive: true);
    } catch (e) {
      print('createFile Error  $e');
    }
    return file;
  }

  Dio dio = Dio();

  Future<File?> download2({
    required String url,
    required String savePath,
    required Function(int, int) showDownloadProgress,
  }) async {
    print('Path $url');

    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            headers: {'Authorization': Apis.authorization},
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      //    authOptions?.headers?['Authorization'] = Apis.authorization;

      var file = await _createFile(savePath);

      var raf = file!.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      print('error ' + e.toString());
    }
    return null;
  }

  Future<Uint8List?> download(
      {required String url,
      required Function(int, int) showDownloadProgress}) async {
    print('Path $url');

    try {
      Response response = await Dio().get(
        url,
        onReceiveProgress: showDownloadProgress,

        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );

      //    authOptions?.headers?['Authorization'] = Apis.authorization;

      print(response.headers);
      List<int> intList =
          response.data.cast<int>().toList(); //This is the magical line.
      Uint8List data = Uint8List.fromList(intList);
      return data;
    } catch (e) {
      print('error ' + e.toString());
    }
    return null;
  }
}

/**
 *  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // static get _httpClient => HttpClient();

  static Future<File> _localFile(String pathToFile) async {
    final path = await _localPath;
    return File('$path/pathFile');
  }

  static Future<File?> readFile(String pathFile) async {
    try {
      return await _localFile(pathFile);
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  static Future<File?> writeCounter(String pathFile, String uri) async {
    final file = await _localFile(pathFile);

    //var requset = await _httpClient.getUri(uri);
    //var response = await requset.close();
    //Uint8List bytes = await consolidateHttpClientResponseBytes(response);

    var dio = Dio();

    Uri data = Uri.file(uri);

    Response<Uint8List> bytes = await dio.getUri<Uint8List>(data);

    // Write the file
    return file.writeAsBytes(bytes.data!);
  }
 */
