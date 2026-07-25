part of 'genaralmessage_cubit.dart';

abstract class GenaralmessageState {
  const GenaralmessageState();
}

class GenaralmessageInitial extends GenaralmessageState {}

class GenaralLoadingState extends GenaralmessageState {}

class GenaralSuccessState extends GenaralmessageState {}

class RemoveUserRecitationState extends GenaralmessageState {}

class GenaralErrorState extends GenaralmessageState {
  final Exception error;

  const GenaralErrorState(this.error);
}

class NoAuthState extends GenaralmessageState {}
