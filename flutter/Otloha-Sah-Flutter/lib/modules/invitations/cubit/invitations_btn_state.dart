import 'package:equatable/equatable.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation.dart';

abstract class InvitationsBtnState extends Equatable {}

class InvitationsBtnInitialState extends InvitationsBtnState {
  @override
  List<Object?> get props => [];
}

class InvitationsBtnFriendRequestLoadingState extends InvitationsBtnState {
  @override
  List<Object?> get props => [];
}

class InvitationsBtnFriendRequestLoadedState extends InvitationsBtnState {
  final Invitation invitation;

  InvitationsBtnFriendRequestLoadedState({required this.invitation});
  @override
  List<Object?> get props => [];
}

class InvitationsBtnFriendRequestErrorState extends InvitationsBtnState {
  @override
  List<Object?> get props => [];
}
