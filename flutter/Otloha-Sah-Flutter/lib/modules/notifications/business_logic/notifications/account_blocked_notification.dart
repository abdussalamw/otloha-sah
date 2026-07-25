import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/notifications_model/push_notification.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';

import '../../../../data_source/local/database/database_repository.dart';
import '../../../home/presentation/pages/home/block_page.dart';
import '../base_notification.dart';

class AccountBlockedNotification extends BaseNotification {
  AccountBlockedNotification({
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
      final user = UserDataServices().getUserDataFast();
      if (user != null) await DatabaseRepository.usersDao!.blockUser(user.id);
      Get.clearRouteTree();
      Get.to(() => BlockedPage());
    }
  }
}
