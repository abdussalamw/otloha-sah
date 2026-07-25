part of 'entities_cubit.dart';

abstract class EntitiesState extends Equatable {
  const EntitiesState();

  @override
  List<Object> get props => [];
}

class EntitiesInitial extends EntitiesState {}

class EntitiesLoading extends EntitiesState {}

class EntitiesLoaded extends EntitiesState {
  final List<Entity> entites;

  const EntitiesLoaded({required this.entites});
}

class EntitiesError extends EntitiesState {}
