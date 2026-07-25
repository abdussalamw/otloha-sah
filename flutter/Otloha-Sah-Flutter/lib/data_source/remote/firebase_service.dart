import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/modules/home/business_logic/cubit/home_cubit.dart';
import 'package:otloha_sah_flutter/modules/messages/business_logic_v2/cubit/rooms_cubit.dart';

import '../../core/network/api_base_helper.dart';
import '../../modules/notifications/business_logic/base_notification.dart';
import '../../modules/notifications/business_logic/local_notifications.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  final notification = await BaseNotification.getCls(
    message: message,
    pushNotificationMap: message.data,
  );
  await notification.pushRoute();
  // print(message.)
}

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  final _firebaseMessaging = FirebaseMessaging.instance;

  static FirebaseService get instance => _instance;

  FirebaseService._internal();

  Function(int notificationID)? _uiHanlder;

  setUiHandler(handler) {
    _uiHanlder = handler;
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    await getToken();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        final localNotification = LocalNotification(
            channelId: message.messageId ?? '',
            channelName: message.messageType ?? '');

        await localNotification.initialize();

        await HomeCubit.get(Get.context).getUnseenCount();
        try {
          if (message.data['target_name'] == 'message' ||
              message.data['target_name'] == 'recitation_room_created') {
            RoomsCubit.get(Get.context!).getRooms(withLoading: false);
          }
        } catch (_) {}

        await localNotification.showNotification(
          id: message.notification.hashCode,
          title: message.notification?.title,
          body: message.notification?.body,
          payload: jsonEncode(message.toMap()),
          channel: message.data['target_name'],
        );

        if (notificationsHasNoRoute.contains(message.data['target_name'])) {
          await localNotification
              .cancelNotification(message.notification.hashCode);
          final notification = await BaseNotification.getCls(
            message: message,
            pushNotificationMap: message.data,
          );
          await notification.pushRoute();
        } else {
          _uiHanlder?.call(message.notification.hashCode);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      final notification = await BaseNotification.getCls(
        message: message,
        pushNotificationMap: message.data,
      );
      await notification.pushRoute();
    });
  }

  Future<String> getDeviceName() async {
    String deviceName = '';
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceName = iosInfo.name;
      }
    } catch (e) {
      print('Failed to get device name: $e');
    }

    return deviceName;
  }

  Future<String?> getToken() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.getAPNSToken();
    }
    final fcmToken = await _firebaseMessaging.getToken();
    ApiBaseHelper().postHTTP(
      '/api/v1/notifications/set_token/',
      {
        'device_name': await getDeviceName(),
        'token': fcmToken,
      },
      DioTypes.authRequired,
    );
    return fcmToken;
  }

  Future<void> deleteToken() async {
    return _firebaseMessaging.deleteToken();
  }
}
