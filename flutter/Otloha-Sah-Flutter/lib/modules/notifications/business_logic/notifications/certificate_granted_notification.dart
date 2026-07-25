import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/notifications_model/push_notification.dart';

import '../../../../core/widgets/warnings_and_alerts/alert_popup.dart';
import '../base_notification.dart';

class CertificateGrantedNotification extends BaseNotification {
  CertificateGrantedNotification(
      {required PushNotification notification,
      RemoteNotification? remoteNotification})
      : super(
          notification: notification,
          remoteNotification: remoteNotification,
        );

  @override
  Future<void> pushRoute() async {
    await super.pushRoute();

    if (remoteNotification != null) {
      Get.dialog(
        AlertPopup(
          alertType: AlertType.seccess,
          message: remoteNotification!.body ?? '',
        ),
      );
    }
  }
}
