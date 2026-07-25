import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/notifications_model/push_notification.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:otloha_sah_flutter/data_source/remote/room_services.dart';

import '../../../../core/utils/constant/constants.dart';
import '../../../../data_source/cache_helper.dart';
import '../../../../data_source/models/room/room.dart';
import '../../../messages/business_logic_v2/cubit/message_details_cubit.dart';
import '../../../messages/presentation_v2/pages/chating_page.dart';
import '../../../messages/presentation_v2/pages/evaluation_page.dart';
import '../base_notification.dart';

class RecitationRoomCreatedNotification extends BaseNotification {
  RecitationRoomCreatedNotification({
    required super.notification,
    super.remoteNotification,
  });

  @override
  Future<void> pushRoute() async {
    await super.pushRoute();
    if (notification.roomId != null) {
      final res = await RoomServices().roomDetails(notification.roomId!);
      final room = Room.fromJson(res?.data['room']);
      var userData = CacheHelper.getData(key: Constants.userDataKey);
      final user = User.fromJson(userData);
      try {
        await MessageDetailsCubit.get(Get.context!)
            .setRecitation(room.recitation!);
      } catch (_) {}

      if (user.isTeacher && room.recitation?.evaluatedAt == null) {
        Get.to(EvaluationPage(room: room));
      } else {
        Get.to(ChatingPage(room: room));
      }
    }
  }
}
