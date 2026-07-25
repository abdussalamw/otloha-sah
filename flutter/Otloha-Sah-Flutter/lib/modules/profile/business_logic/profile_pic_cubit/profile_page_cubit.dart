import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../../../../data_source/data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data_source/remote/recitation_services.dart';

import '../../../../../core/error/exceptions.dart';

part 'profile_page_state.dart';

class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit() : super(ProfilePageInitial());

  static ProfilePageCubit get(context) =>
      BlocProvider.of<ProfilePageCubit>(context);

  User? currentUserProfile;
  List<Recitation>? recitations;
  List<Recitation> accpetedRecitations = [];
  List<Recitation> specialRecitations = [];
  List<Recitation> rejectedRecitations = [];
  bool isRecitationsLocked = false;

  Future<void> userProfile({User? user}) async {
    emit(GetProfilePageLoading());

    try {
      if (user == null) {
        user = await AppDataSource().myProfile();
        currentUserProfile = user;
        recitations = await UserRecitationApi().getAllRecitations(1);
        accpetedRecitations = recitations!
            .where((element) => element.result == 'accepted')
            .toList();
        specialRecitations =
            recitations!.where((element) => element.isRemarkable!).toList();

        rejectedRecitations = recitations!
            .where((element) => element.result == 'rejected')
            .toList();
      } else {
        currentUserProfile = user;
        recitations = await UserRecitationApi().getUserRecitation(user.id);
        isRecitationsLocked = false;
      }

      emit(GetProfilePageSuccess());
    } on Exception catch (error) {
      if (error is AuthError) {
        emit(NoAuthState());
        return;
      } else if (error is InvalidData) {
        isRecitationsLocked = true;
        emit(GetProfilePageSuccess());

        return;
      } else {
        emit(GetProfilePageError(error: error));
      }
    }
  }
}
