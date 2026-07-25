part of 'messagedetails_cubit.dart';

abstract class MessagedetailsState {
  const MessagedetailsState();
}

class MessagedetailsInitial extends MessagedetailsState {}

class MessageFetchedState extends MessagedetailsState {}

class MessageErrorState extends MessagedetailsState {}

class MessageLoadingState extends MessagedetailsState {}

class MessageEmptyState extends MessagedetailsState {}
