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
    try {
      if (await recorder.hasPermission()) {
        return true;
      }

      final status = await Permission.microphone.status;
      if (status.isGranted || status.isLimited) {
        return true;
      }

      final req = await Permission.microphone.request();
      if (req.isGranted || req.isLimited) {
        return true;
      }

      if (req.isPermanentlyDenied && context != null) {
        showDialog(
          context: context,
          builder: (BuildContext ctx) => AlertPopup(
            alertType: AlertType.warning,
            message:
                'يحتاج التطبيق إذن الميكروفون لتسجيل تلاوتك الكريمة. يرجى تفعيله يدوياً من إعدادات الهاتف.'
                    .tr(),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.warningAlertColor),
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(ctx);
                },
                child: Text(tr('Settings')),
              )
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('isHasPermission error: $e');
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
      final appDocDirectory = await getApplicationDocumentsDirectory();
      final recordsDir = Directory('${appDocDirectory.path}/FilesGeneratedRecord');
      if (!recordsDir.existsSync()) {
        recordsDir.createSync(recursive: true);
      }

      final customPath =
          '${recordsDir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.wav';

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
      debugPrint('Microphone permission not granted');
    }
  }

  Future resume() async {
    await recorder.resume();
  }

  Future pause() async {
    await recorder.stop();
  }

  Future<String?> stop() async {
    try {
      return await recorder.stop();
    } catch (e) {
      debugPrint('recorder.stop error: $e');
      return null;
    }
  }
}