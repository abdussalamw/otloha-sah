import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/notifications_model/push_notification.dart';
import 'package:otloha_sah_flutter/modules/messages/presentation_v2/pages/general_box_page.dart';
import 'package:otloha_sah_flutter/modules/notifications/business_logic/base_notification.dart';

class AddedToGeneralBoxRecitations extends BaseNotification {
  AddedToGeneralBoxRecitations(
      {required PushNotification notification,
      RemoteNotification? remoteNotification})
      : super(
          notification: notification,
          remoteNotification: remoteNotification,
        );

  @override
  Future<void> pushRoute() async {
    await super.pushRoute();
    Get.to(() => const GeneralMessagePage());
  }
}
