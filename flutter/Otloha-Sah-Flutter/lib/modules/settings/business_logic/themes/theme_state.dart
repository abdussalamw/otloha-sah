part of 'theme_cubit.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeChange extends ThemeState {
  final ThemeMode themeMode;

  const ThemeChange(this.themeMode);

  @override
  List<Object> get props => [themeMode];
}
