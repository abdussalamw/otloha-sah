part of 'addnote_cubit.dart';

abstract class AddNoteState {
  const AddNoteState();
}

class AddNoteInitial extends AddNoteState {}

class AddNoteSuccess extends AddNoteState {}

class UpdateNote extends AddNoteState {}

class ErrorSaveNote extends AddNoteState {}

class TextChange extends AddNoteState {}

class EnableChange extends AddNoteState {}
