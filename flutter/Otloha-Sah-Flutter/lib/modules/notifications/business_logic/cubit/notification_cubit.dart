import 'package:bloc/bloc.dart';

import 'notification_state.dart';

class NotificationIconCubit extends Cubit<NotificationIconState> {
  NotificationIconCubit() : super(NotificationInitialState());

  void newNotificationReceived() {
    emit(NewNotificationReceivedState());
  }

  void notificationSeen() {
    emit(NotificationSeenState());
  }
}
