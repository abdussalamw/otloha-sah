import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';

abstract class UsersListSectionState extends Equatable {
  const UsersListSectionState();

  @override
  List<Object> get props => [];
}

// State when the page is loading users
class UsersListSectionLoading extends UsersListSectionState {}

// State when users are successfully loaded
class UsersListSectionLoaded extends UsersListSectionState {
  final List users;

  const UsersListSectionLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

// State when there was an error loading users
class UsersListSectionError extends UsersListSectionState {
  final String message;

  const UsersListSectionError({required this.message});

  @override
  List<Object> get props => [message];
}

abstract class EntitiesSectionState extends Equatable {
  const EntitiesSectionState();

  @override
  List<Object> get props => [];
}

// State when the page is loading users
class EntitiesSectionLoading extends EntitiesSectionState {}

// State when users are successfully loaded
class EntitiesSectionLoaded extends EntitiesSectionState {
  final List<Entity> entities;

  const EntitiesSectionLoaded({required this.entities});

  @override
  List<Object> get props => [entities];
}

// State when there was an error loading users
class EntitiesSectionError extends EntitiesSectionState {
  final String message;

  const EntitiesSectionError({required this.message});

  @override
  List<Object> get props => [message];
}
