part of '../language/language_cubit.dart';

abstract class LanguageState {
  const LanguageState();
}

class LanguageInitial extends LanguageState {}

class LanguageChange extends LanguageState {}
