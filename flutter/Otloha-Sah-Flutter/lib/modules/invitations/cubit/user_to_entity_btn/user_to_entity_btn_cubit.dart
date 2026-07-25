import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/user_to_entity_btn/user_to_entity_btn_state.dart';

class UserToEntityBtnCubit extends Cubit<UserToEntityBtnState> {
  UserToEntityBtnCubit({required this.entity})
      : super(UserToEntityBtnInitialState()) {
    if (entity.invitations?.inJoinEntityRequest != null) {
      emit(state);
    } else if (entity.invitations?.outJoinEntityRequest != null) {
      emit(UserToEntityBtnPendingState());
    } else if (entity.relationships?.memberInEntity != null) {
      emit(UserToEntityBtnJoinedState());
    }
  }

  Entity entity;

  sendJoinRequest() async {
    emit(UserToEnityLoadingState());
    emit(UserToEntityBtnPendingState());
  }

  cancelJoinRequest() {
    emit(UserToEnityLoadingState());
    emit(UserToEntityBtnInitialState());
  }

  block() {}

  acceptJoinRequest() {}
}
