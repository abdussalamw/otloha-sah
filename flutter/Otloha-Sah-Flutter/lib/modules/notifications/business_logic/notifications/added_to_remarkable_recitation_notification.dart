import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/notifications_model/push_notification.dart';
import 'package:otloha_sah_flutter/modules/notifications/business_logic/base_notification.dart';

import '../../../messages/presentation_v2/pages/markable_recitations_page.dart';

class AddedToRemarkableRecitations extends BaseNotification {
  AddedToRemarkableRecitations(
      {required super.notification, super.remoteNotification});

  @override
  Future<void> pushRoute() async {
    await super.pushRoute();
    Get.to(() => const MarkableRecitationsPage());
  }
}
