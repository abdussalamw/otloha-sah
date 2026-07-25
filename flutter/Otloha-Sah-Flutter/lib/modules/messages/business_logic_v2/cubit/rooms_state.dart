part of 'rooms_cubit.dart';

abstract class RoomsState extends Equatable {
  const RoomsState();
}

class RoomsInitial extends RoomsState {
  @override
  List<Object?> get props => [];
}

class RoomsLoadingDataState extends RoomsState {
  @override
  List<Object?> get props => [];
}

class RoomsFetechedDataState extends RoomsState {
  final List<Room> data;

  const RoomsFetechedDataState({required this.data});

  @override
  List<Object?> get props => [data];
}

class RoomsErrorState extends RoomsState {
  final Object exception;

  const RoomsErrorState({required this.exception});

  @override
  List<Object?> get props => [];
}
