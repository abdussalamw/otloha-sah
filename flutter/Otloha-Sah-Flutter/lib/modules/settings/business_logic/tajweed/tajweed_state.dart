part of 'tajweed_cubit.dart';

abstract class TajweedState extends Equatable {
  const TajweedState();
}

class TajweedInitial extends TajweedState {
  @override
  List<Object?> get props => [];
}

class TajweedFetched extends TajweedState {
  final List<TajweedBook> tajweed;
  final int selectedBook;
  const TajweedFetched(this.tajweed, this.selectedBook);

  @override
  List<Object?> get props => [tajweed, selectedBook];
}

class TajweedError extends TajweedState {
  final Object error;
  const TajweedError(this.error);

  @override
  List<Object?> get props => [];
}

class TajweedEmpty extends TajweedState {
  final bool isNarrtion;
  const TajweedEmpty(this.isNarrtion);

  @override
  List<Object?> get props => [];
}
