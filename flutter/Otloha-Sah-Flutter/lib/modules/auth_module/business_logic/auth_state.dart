part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class ChangeIsLogInTrueStateState extends AuthState {}

class ChangeIsLogInFalseStateState extends AuthState {}

class LogInLoadingState extends AuthState {}

class ForgotPasswordLoadingState extends AuthState {}

class LogInSuccessState extends AuthState {
  LogInSuccessState();
}

class ForgotPasswordSuccessState extends AuthState {}

class ForgotPasswordErrorState extends AuthState {
  final Map<String, dynamic> error;

  ForgotPasswordErrorState(this.error);
}

class LogInErrorState extends AuthState {
  final Map<String, dynamic> error;

  LogInErrorState(this.error);
}

class LogOutLoadingState extends AuthState {}

class ErrorState extends AuthState {
  final Exception error;
  ErrorState({
    required this.error,
  });
}

class LogOutSuccessState extends AuthState {}

class LogOutErrorState extends AuthState {
  final String error;

  LogOutErrorState(this.error);
}

class RegisterLoadingState extends AuthState {}

class ThenAuthState extends AuthState {
  final bool isFirstSocial;
  final bool isProfileCompelete;

  ThenAuthState(
      {required this.isFirstSocial, required this.isProfileCompelete});
}

class RegisterSuccessState extends AuthState {}

class RegisterErrorState extends AuthState {
  final Map<String, dynamic> error;

  RegisterErrorState(this.error);
}

class StudentRolePickedState extends AuthState {}

class TeacherRolePickedState extends AuthState {}

class VerifyPhoneStateLoading extends AuthState {}

class VerifyPhoneErrorState extends AuthState {
  final Map<String, dynamic> error;

  VerifyPhoneErrorState({required this.error});
}

class VerifyPhoneSuccessState extends AuthState {}
