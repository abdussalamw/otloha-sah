import 'package:equatable/equatable.dart';

abstract class NotificationIconState extends Equatable {}

class NotificationInitialState implements NotificationIconState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class NewNotificationReceivedState implements NotificationIconState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class NotificationSeenState implements NotificationIconState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}
