import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/cache_helper.dart';
import '../../../../data_source/models/notifications_model/notifications_model.dart';
import '../../../../data_source/remote/notification_service.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial());

  static NotificationsCubit get(context) => BlocProvider.of(context);
  List<NotificationsModel> notifications = [];
  void getNotifications(int page) async {
    // emit(NotificationsLoading());

    List<dynamic> data =
        json.decode(CacheHelper.getData(key: 'notifications') ?? '[]');
    List<NotificationsModel> notifications = [];

    if (data.isNotEmpty) {
      for (var element in data) {
        notifications.add(NotificationsModel.fromMap(element));
      }
      print(notifications);
      emit(NotificationsLoaded(notifications: notifications));
    }
    try {
      final response = await NotificationsService()
          .notificationsListing(page, markUnseen: true);
      List<NotificationsModel> notifications = [];
      await CacheHelper.saveData(
          key: 'notifications', value: json.encode(response?.data['results']));

      response!.data!['results'].map((element) {
        notifications.add(NotificationsModel.fromMap(element));
      });
      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      if (data.isEmpty) {
        emit(NotificationsError(error: e));
      }
    }
  }

  void markAsRead(NotificationsModel notification, int index) async {
    // try {
    await NotificationsService().markAsRead(notification.id);
    if (state is NotificationsLoaded) {
      final newNotification = notification.copyWith(isRead: true);
      notifications[index] = newNotification;
      emit(NotificationsLoaded(notifications: notifications));
    }
    // } on Error catch (e) {
    //   emit(NotificationsError(error: e));
    // }
  }
}
