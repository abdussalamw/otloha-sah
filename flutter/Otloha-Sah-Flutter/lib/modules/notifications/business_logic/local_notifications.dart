import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/remote/notification_service.dart';
import 'package:otloha_sah_flutter/modules/home/business_logic/cubit/home_cubit.dart';

import 'base_notification.dart';

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  LocalNotification({
    required this.channelId,
    required this.channelName,
  });

  final String channelId;
  final String channelName;

  Future initialize() async {
    const androidInitialize =
        AndroidInitializationSettings('mipmap/launcher_icon');
    var iosInitialize = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings =
        InitializationSettings(android: androidInitialize, iOS: iosInitialize);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  @pragma('vm:entry-point')
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final message =
        RemoteMessage.fromMap(jsonDecode(notificationResponse.payload ?? '{}'));

    print(message);

    final notification = await BaseNotification.getCls(
      message: message,
      pushNotificationMap: message.data,
    );
    await notification.pushRoute();
    await NotificationsService().notificationsListing(1, markUnseen: true);
    await HomeCubit.get(Get.context).getUnseenCount();
  }

  notificationDetails(String channel) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel,
        channel,
        importance: Importance.max,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future showNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
    required String channel,
  }) async {
    return flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      await notificationDetails(channel),
      payload: payload,
    );
  }

  Future<void> cancelNotification(int notificationID) async {
    await flutterLocalNotificationsPlugin.cancel(notificationID);
  }
}
