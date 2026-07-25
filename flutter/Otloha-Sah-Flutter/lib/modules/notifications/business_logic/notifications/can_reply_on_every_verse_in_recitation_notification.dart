import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/alert_popup.dart';
import 'package:otloha_sah_flutter/data_source/models/notifications_model/push_notification.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/splash/business_logic/cubit/splash_cubit.dart';

import '../base_notification.dart';

class CanReplyOnEveryVerseNotification extends BaseNotification {
  CanReplyOnEveryVerseNotification({
    required PushNotification notification,
    RemoteNotification? remoteNotification,
  }) : super(
          notification: notification,
          remoteNotification: remoteNotification,
        );

  @override
  Future<void> pushRoute() async {
    await super.pushRoute();
    if (remoteNotification != null) {
      await SplashCubit().getUsersInfo();
      Get.dialog(
        AlertPopup(
          alertType: AlertType.seccess,
          message: remoteNotification!.body ?? '',
        ),
      );
    }
  }
}
