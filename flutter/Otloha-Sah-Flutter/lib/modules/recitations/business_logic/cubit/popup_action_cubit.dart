import 'package:dio/dio.dart' as dio;
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/local_recitation.dart';
import '../../../../core/widgets/loading.dart';
import '../../../../data_source/data_source.dart';
import '../../../../data_source/local/database/database_repository.dart';
import '../../../../data_source/models/room/room.dart';
import '../../../../data_source/remote/recitation_services.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/widgets/toasts.dart';
import 'popup_actions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../data_source/remote/messages_service.dart';

class PopupActionsCubit extends Cubit<PopupActionsState> {
  PopupActionsCubit() : super(PopupInitialState());

  bool isShared = false;
  bool isRemarkable = false;

  setShared(bool isShared) {
    this.isShared = isShared;
    emit(AddToGeneralState());
  }

  setIsRemarkable(bool isRemarkable) {
    this.isRemarkable = isRemarkable;
    emit(MarkAsRemarkableState());
  }

  // Future<void> markAsFinished(int id) async {
  //   await GetMessages().markAsFinished(id);
  //   Get.back();
  //   emit(MarkAsFinishedState());
  // }

  Future<void> addToGeneral(
      {int? id, required bool isLocal, LocalRecitation? userRecitation}) async {
    try {
      if (isLocal) {
        var recitation = await UserRecitationApi()
            .saveUserReciataion(userRecitation: userRecitation!);
        id = recitation!.id;
      }
      await GetMessages().addToGeneral(id!);
      isShared = !isShared;
      emit(AddToGeneralState());
    } on InvalidData catch (e) {
      ExceptionHandling.hanleToastFromException(e);
      ErrorToast.toast(e.msg ?? '');
    } on Exception catch (e) {
      ExceptionHandling.hanleToastFromException(e);
    }
  }

  Future<void> deleteRecitations(
      {int? id, required bool isLocal, LocalRecitation? userRecitation}) async {
    if (isLocal) {
      await DatabaseRepository.instance
          .deleteUserRecitation(userRecitation!.id!);
    } else {
      await GetMessages().deleteRecitations(id!);
    }
    Get.back();
  }

  Future<void> markAsRemarkable(int id) async {
    await GetMessages().markAsRemarkable(id: id);
    isRemarkable = !isRemarkable;
    emit(MarkAsRemarkableState());
    Get.back();
  }

  Future<void> markAsAccepted(int id, int messageId) async {
    await GetMessages().markAsAccepted(id: id, messageId: messageId);
    Get.back();
  }

  Future<Room?> createRoom(int id, int userId, context) async {
    Loader.show(context, progressIndicator: const LoadingWidget());
    Room? room;
    await ExceptionHandling.hanleToastException(
      () async {
        dio.Response? response = await AppDataSource().createRoom(id, userId);
        Get.back();
        Loader.hide();
        room = Room.fromJson(response?.data);
        return response;
      },
      '',
      false,
    );

    Loader.hide();

    return room;
  }

  serReport(int id, int messageId) async {
    await GetMessages().markAsReport(id: id, messageId: messageId);
  }

  serAccept(int id, int messageId) async {
    await GetMessages().markAsAccepted(id: id, messageId: messageId);
  }

  void serReject(int id, int messageId) async {
    await GetMessages().markAsReject(id: id, messageId: messageId);
  }
}
