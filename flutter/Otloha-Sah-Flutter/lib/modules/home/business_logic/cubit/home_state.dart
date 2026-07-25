part of 'home_cubit.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class HomeChangeIndex extends HomeState {
  final int index;

  const HomeChangeIndex(this.index);
}

class ChangePageState extends HomeState {}

class ChangeDataState extends HomeState {}
