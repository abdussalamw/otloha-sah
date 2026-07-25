import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:otloha_sah_flutter/modules/notifications/business_logic/notifications/teacher_privilage_granted.dart';
import 'package:otloha_sah_flutter/modules/notifications/business_logic/notifications/teacher_profile_compelete_notification.dart';
import 'package:otloha_sah_flutter/modules/notifications/business_logic/notifications/teacher_profile_incompelete_notification.dart';
import 'package:otloha_sah_flutter/modules/notifications/business_logic/notifications/teacher_privilage_revoked.dart';

import '../../../data_source/models/notifications_model/push_notification.dart';
import '../../../data_source/remote/notification_service.dart';
import 'notifications/account_blocked_notification.dart';
import 'notifications/account_unblock_notification.dart';
import 'notifications/add_to_favorite_notification.dart';
import 'notifications/added_to_general_box_notification.dart';
import 'notifications/added_to_remarkable_recitation_notification.dart';
import 'notifications/added_to_teachers_recitations.dart';
import 'notifications/can_reply_on_every_verse_in_recitation_notification.dart';
import 'notifications/cannot_replay_on_every_verse_notification.dart';
import 'notifications/certificate_granted_notification.dart';
import 'notifications/certificate_revoked_notification.dart';
import 'notifications/message_notification.dart';
import 'notifications/recitation_room_created_notification.dart';

class BaseNotification {
  PushNotification notification;
  RemoteNotification? remoteNotification;

  BaseNotification({
    required this.notification,
    this.remoteNotification,
  });

  Future<void> pushRoute() async {
    try {
      if (notification.notificationId != null) {
        await NotificationsService().markAsRead(notification.notificationId!);
      }
    } catch (_) {}
  }

  void getRouteName() {}

  static Future<BaseNotification> getCls({
    RemoteMessage? message,
    required Map<String, dynamic> pushNotificationMap,
  }) async {
    final pushNotification = PushNotification.fromMap(pushNotificationMap);
    print(pushNotification);
    final notification = notificationsMap[pushNotification.targetName]!(
        pushNotification, message?.notification);
    return notification;
  }
}

typedef NotificationCallback = BaseNotification Function(
  PushNotification notification,
  RemoteNotification? remoteNotification,
);

List<String> notificationsHasNoRoute = [
  'certification_granted',
  'certification_revoked',
  'teacher_privilege_granted',
  'teacher_privilege_revoked',
  'can_reply_on_every_verse_in_recitation',
  'cannot_reply_on_every_verse_in_recitation',
  'teacher_profile_complete',
  'account_blocked',
  'account_unblocked',
];

Map<String, NotificationCallback> notificationsMap = {
  'marked_as_favorite_teacher': (
    PushNotification notification,
    RemoteNotification? remoteNotification,
  ) =>
      AddToFavoriteNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'certification_granted': (
    PushNotification notification,
    RemoteNotification? remoteNotification,
  ) =>
      CertificateGrantedNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'certification_revoked': (
    notification,
    remoteNotification,
  ) =>
      CertificateRevokedNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'teacher_privilege_granted': (
    notification,
    remoteNotification,
  ) =>
      TeacherPrivilageGrantedNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'teacher_privilege_revoked': (
    notification,
    remoteNotification,
  ) =>
      TeacherPrivilageRevokedNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'can_reply_on_every_verse_in_recitation': (
    notification,
    remoteNotification,
  ) =>
      CanReplyOnEveryVerseNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'cannot_reply_on_every_verse_in_recitation': (
    notification,
    remoteNotification,
  ) =>
      CannotReplyOnEveryVerseNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'teacher_approved': (
    notification,
    remoteNotification,
  ) =>
      TeacherProfileCompeleteNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'teacher_rejected': (
    notification,
    remoteNotification,
  ) =>
      TeacherProfileIncompeleteNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'account_blocked': (
    notification,
    remoteNotification,
  ) =>
      AccountBlockedNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'account_unblocked': (
    notification,
    remoteNotification,
  ) =>
      AccountUnblockedNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'added_to_teachers_recitation': (notification, remoteNotification) =>
      AddedToTeachersRecitations(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'recitation_added_to_general': (notification, remoteNotification) =>
      AddedToGeneralBoxRecitations(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'recitation_added_to_remarkable_box': (notification, remoteNotification) =>
      AddedToRemarkableRecitations(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'message': (notification, remoteNotification) => MessageNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
  'recitation_room_created': (notification, remoteNotification) =>
      RecitationRoomCreatedNotification(
        notification: notification,
        remoteNotification: remoteNotification,
      ),
};

// marked_as_favorite_teacher //
// certification_granted //
// certification_revoked //
// teacher_privilege_granted //
// teacher_privilege_revoked //
// can_reply_on_every_verse_in_recitation //
// cannot_reply_on_every_verse_in_recitation //
// teacher_profile_complete //
// teacher_profile_incomplete //
// account_unblocked //
// account_blocked //
// added_to_teachers_recitation //
// added_to_general_box //
// added_to_remarkable_recitations //

// recitation_evaluated
// recitation_rated
// recitation_added_to_remarkable_box
// teacher_rejected
