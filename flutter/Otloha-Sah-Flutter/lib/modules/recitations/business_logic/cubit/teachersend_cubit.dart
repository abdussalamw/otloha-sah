import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/widgets/toasts.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/local_recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../data_source/local/database/database_repository.dart';
import '../../../../data_source/remote/recitation_services.dart';
import '../../../../data_source/remote/room_services.dart';
import '../../../../data_source/user_services_data.dart';

part 'teachersend_state.dart';

class TeacherSendCubit extends Cubit<TeacherSendState> {
  TeacherSendCubit() : super(TeacherSendInitial());
  List<User> teachers = [];

  static TeacherSendCubit get(context) => BlocProvider.of(context);

  getTeacher() async {
    try {
      emit(TeacherLoadingState());
      User? teacher = await UserDataServices.instance.getFavTeacherData();
      if (teacher != null) {
        User favTeacherProFile = User.fromJson(jsonDecode(
            UserDataServices.instance.getFavTeacherData().toString()));
        teachers.add(favTeacherProFile);
        emit(TeacherFetchedState());
      } else {
        emit(TeacherErrorState());
      }
    } catch (e) {
      emit(TeacherErrorState());
    }
  }

  filter({String? qurey}) {}

  Future<Recitation?> sendTeacher({
    int? id,
    LocalRecitation? userRecitation,
    bool? sendToFavoriteTeacher,
    required BuildContext context,
  }) async {
    // if (isLocal) {
    Recitation? recitation;
    try {
      var userProfile = await UserDataServices.instance.getUserData();
      if (userRecitation != null) {
        recitation = await UserRecitationApi().saveUserReciataion(
          userRecitation: userRecitation,
          sendToFavoriteTeacher: sendToFavoriteTeacher,
        );

        id = recitation!.id;
        DatabaseRepository.instance.deleteUserRecitation(userRecitation.id!);
      } else {
        recitation = Recitation.fromJson((await RoomServices()
                .createRoom(id!, userProfile!.favoriteTeacher!))!
            .data['recitation']);
      }
      emit(TeacherSentState());
      Get.back();

      return recitation;
    } on InvalidData catch (e) {
      // ignore: use_build_context_synchronously
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.danger,
          title: tr('Error'),
          text: e.errors?[e.errors?.keys.first][0],
          confirmButtonText: tr('ok'),
          confirmButtonColor: AppColor.primaryColor,
        ),
      );
    } on NetworkConnectionException catch (_) {
      Fluttertoast.showToast(
        msg: tr('offline_sending_message'),
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
      Get.back();
    } catch (e, s) {
      print(e);
      print(s);
      ErrorToast.toast(translate('Something went wrong'));
    }
    return null;
  }
}
