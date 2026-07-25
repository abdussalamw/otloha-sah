import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';

abstract class EntitiesListingState extends Equatable {
  const EntitiesListingState();

  @override
  List<Object> get props => [];
}

// State when the page is loading EntitiesListing
class EntitiesListingLoading extends EntitiesListingState {}

// State when EntitiesListing are successfully loaded
class EntitiesListingLoaded extends EntitiesListingState {
  final List<Entity> entities;

  const EntitiesListingLoaded({required this.entities});

  @override
  List<Object> get props => [entities];
}

// State when there was an error loading EntitiesListing
class EntitiesListingError extends EntitiesListingState {
  final String message;

  const EntitiesListingError({required this.message});

  @override
  List<Object> get props => [message];
}
