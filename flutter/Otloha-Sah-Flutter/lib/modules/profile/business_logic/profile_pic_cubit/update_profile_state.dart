import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {
  final User user;

  const UpdateProfileSuccess(this.user);
}

class UpdateProfileError extends UpdateProfileState {
  final Exception error;

  const UpdateProfileError(this.error);

  @override
  List<Object> get props => [error];
}

class UpdateEmailState extends UpdateProfileState {}

class UpdatePhoneState extends UpdateProfileState {}

class UpdatePasswordState extends UpdateProfileState {}

class UpdateProfileDataState extends UpdateProfileState {}

class InvalidDataErrorState extends UpdateProfileState {
  final Map<String, dynamic> errors;

  const InvalidDataErrorState(this.errors);
  @override
  List<Object> get props => [errors];
}

class ImagePickedState extends UpdateProfileState {
  final String path;

  const ImagePickedState(this.path);

  @override
  List<Object> get props => [path];
}
