part of 'splash_cubit.dart';

abstract class SplashState {
  const SplashState();
}

class SplashInitial extends SplashState {}

class SplashFinish extends SplashState {
  final bool isBlocked;
  final bool isProfileCompelete;
  final bool isPhoneVerified;

  SplashFinish({
    required this.isBlocked,
    required this.isProfileCompelete,
    required this.isPhoneVerified,
  });
}

class SplashFinishWithError extends SplashState {
  Exception error;
  SplashFinishWithError({
    required this.error,
  });
}

class StartDownloadState extends SplashState {}

class EndDownloadState extends SplashState {}

class DownloadingState extends SplashState {
  double progress;
  DownloadingState({
    required this.progress,
  });
}

class LoadingState extends SplashState {}
