import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/notifications_model/push_notification.dart';
import 'package:otloha_sah_flutter/data_source/models/room/room.dart';
import 'package:otloha_sah_flutter/data_source/remote/room_services.dart';
import 'package:otloha_sah_flutter/modules/notifications/business_logic/base_notification.dart';

import '../../../messages/presentation_v2/pages/chating_page.dart';

class MessageNotification extends BaseNotification {
  MessageNotification({
    required PushNotification notification,
    RemoteNotification? remoteNotification,
  }) : super(
          notification: notification,
          remoteNotification: remoteNotification,
        );

  @override
  Future<void> pushRoute() async {
    await super.pushRoute();
    if (notification.roomId != null) {
      final res = await RoomServices().roomDetails(notification.roomId!);
      final room = Room.fromJson(res?.data['room']);
      Get.to(ChatingPage(room: room));
    }
  }
}
