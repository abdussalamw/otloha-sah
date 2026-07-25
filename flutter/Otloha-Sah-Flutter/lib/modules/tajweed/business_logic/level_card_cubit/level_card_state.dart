part of 'level_card_cubit.dart';

class LevelCardState extends Equatable {
  const LevelCardState();

  @override
  List<Object> get props => [];
}

class LevelCardInitial extends LevelCardState {}

class LevelCardSelected extends LevelCardState {
  final TajweedLevel tajweedLevel;

  const LevelCardSelected(this.tajweedLevel);

  @override
  List<Object> get props => [tajweedLevel];
}
