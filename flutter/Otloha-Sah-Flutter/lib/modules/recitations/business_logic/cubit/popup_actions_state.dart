import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';

abstract class PopupActionsState {}

class PopupInitialState extends PopupActionsState {}

class MarkAsFinishedState extends PopupActionsState {}

class AddToGeneralState extends PopupActionsState {}

class RemoveRecitationState extends PopupActionsState {
  final Recitation userRecitatios;
  RemoveRecitationState(this.userRecitatios);
}

class MarkAsAcceptedState extends PopupActionsState {}

class MarkAsRemarkableState extends PopupActionsState {}

class MarkAsReadState extends PopupActionsState {}
