part of 'changenarration_cubit.dart';

abstract class ChangenarrationState {}

class ChangenarrationInitial extends ChangenarrationState {}

class ChangenarrationSuccess extends ChangenarrationState {}

class ChangenarrationError extends ChangenarrationState {}

class ChangenarrationLoading extends ChangenarrationState {}
