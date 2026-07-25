import 'package:equatable/equatable.dart';

import '../../../../data_source/models/notifications_model/notifications_model.dart';

abstract class NotificationsState extends Equatable {}

class NotificationsInitial extends NotificationsState {
  @override
  List<Object?> get props => [];
}

class NotificationsLoading extends NotificationsState {
  @override
  List<Object?> get props => [];
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationsModel> notifications;

  NotificationsLoaded({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final Object error;

  NotificationsError({required this.error});

  @override
  List<Object?> get props => [];
}
