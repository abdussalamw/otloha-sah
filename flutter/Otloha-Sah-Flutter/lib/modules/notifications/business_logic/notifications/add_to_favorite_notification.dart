import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/notifications_model/push_notification.dart';
import 'package:otloha_sah_flutter/data_source/remote/user_services.dart';

import '../../../profile/presentation/page/profile_bnb_page.dart';
import '../base_notification.dart';

class AddToFavoriteNotification extends BaseNotification {
  AddToFavoriteNotification(
      {required PushNotification notification,
      RemoteNotification? remoteNotification})
      : super(
          notification: notification,
          remoteNotification: remoteNotification,
        );

  @override
  void getRouteName() {}

  @override
  Future<void> pushRoute() async {
    await super.pushRoute();

    if (notification.objectId != null) {
      final user = await UserServices().userProfile(notification.objectId!);
      Get.to(
        () => ProfileBNBPage(user: user),
      );
    }
  }
}
