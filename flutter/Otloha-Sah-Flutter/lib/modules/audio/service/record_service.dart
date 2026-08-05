import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../../../core/utils/themes/color.dart';
import '../../../core/widgets/warnings_and_alerts/alert_popup.dart';

class RecordServiceApp {
  /// to record
  final AudioRecorder recorder = AudioRecorder();

  Future<bool> isHasPermission(context) async {
    // First check if permission is already granted
    if (await Permission.microphone.isGranted) {
      return true;
    }

    // Request permission
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      return true;
    }

    // Permission not granted
    if (await Permission.microphone.isPermanentlyDenied ||
        (Platform.isAndroid && await Permission.microphone.isDenied)) {
      // The user has permanently denied the permission
      // Show a message to the user explaining why the permission is needed
      // and giving them the option to grant the permission manually through the device settings
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertPopup(
          alertType: AlertType.warning,
          message:
              'The app needs permission to access your microphone to record audio. Please grant the permission manually in the device settings.'
                  .tr(),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.warningAlertColor),
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: Text(tr('Settings')),
            )
          ],
        ),
      );
      return false;
    }

    return false;
  }

  initRecord(
    context, {
    Function(String path)? onSubmitPath,
    Function(Duration duration)? onChangeDuration,
  }) async {
    bool hasPermission = await isHasPermission(context);

    if (hasPermission) {
      String customPath = '/FilesGeneratedRecord';
      Directory appDocDirectory;

      if (Platform.isIOS) {
        appDocDirectory = await getApplicationDocumentsDirectory();
      } else {
        appDocDirectory = (await getApplicationDocumentsDirectory());
      }

      customPath =
          '${appDocDirectory.path}$customPath${DateTime.now().millisecondsSinceEpoch}.wav';

      await recorder.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: customPath,
      );
      onSubmitPath?.call(customPath);
      int seconds = 0;
      final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        onChangeDuration?.call(Duration(seconds: ++seconds));
      });
      recorder.onStateChanged().listen((event) {
        if (event == RecordState.pause || event == RecordState.stop) {
          timer.cancel();
        }
      });
    } else {
      print('You must accept permissions');
    }
  }

  Future resume() async {
    await recorder.resume();
  }

  Future pause() async {
    await recorder.stop();
  }

  Future stop() async {
    await recorder.stop();
  }
}