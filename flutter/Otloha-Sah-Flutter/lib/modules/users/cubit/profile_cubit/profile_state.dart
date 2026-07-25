import 'package:otloha_sah_flutter/data_source/models/user/details_models/student_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final StudentProfile userProfile;

  ProfileLoaded(this.userProfile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
