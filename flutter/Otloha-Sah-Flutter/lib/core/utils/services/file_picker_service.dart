import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/alert_popup.dart';
import 'package:permission_handler/permission_handler.dart';

class FilePickerService {
  FilePickerService({
    required this.type,
    this.allowCompression = true,
    required this.onFileLoading,
    required this.allowedExtensions,
    this.allowMultiple = false,
    this.withData = false,
    this.withReadStream = false,
  });

  final FileType type;
  final List<String> allowedExtensions;
  final bool allowCompression;
  final Function(FilePickerStatus) onFileLoading;
  final bool allowMultiple;
  final bool withData;
  final bool withReadStream;

  Future<FilePickerResult?> pickFile(BuildContext context) async {
    FilePickerResult? resultList;
    try {
      await Permission.photos.request();

      if (await Permission.photos.request().isGranted) {
        resultList = await FilePicker.platform.pickFiles(
          type: type,
          allowedExtensions: allowedExtensions,
          allowCompression: allowCompression,
          onFileLoading: onFileLoading,
          allowMultiple: allowMultiple,
          withData: withData,
          withReadStream: withReadStream,
        );
      } else if (await Permission.microphone.isPermanentlyDenied ||
          (Platform.isAndroid && await Permission.microphone.isDenied)) {
        // The user has permanently denied the permission
        // Show a message to the user explaining why the permission is needed
        // and giving them the option to grant the permission manually through the device     settings
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertPopup(
            alertType: AlertType.warning,
            message:
                'The app needs permission to access your storage to pick files. Please grant the permission manually in the device settings.'
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
      } else {
        throw Exception('Storage Permission not granted');
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
    return resultList;
  }
}
