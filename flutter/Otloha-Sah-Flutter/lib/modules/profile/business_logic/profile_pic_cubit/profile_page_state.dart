part of 'profile_page_cubit.dart';

abstract class ProfilePageState {}

class ProfilePageInitial extends ProfilePageState {}

class GetProfilePageLoading extends ProfilePageState {}

class GetProfilePageSuccess extends ProfilePageState {}

class GetProfilePageError extends ProfilePageState {
  final Exception error;
  GetProfilePageError({
    required this.error,
  });
}

class NoAuthState extends ProfilePageState {}
