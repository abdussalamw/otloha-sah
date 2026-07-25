import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../data_source/data_source.dart';
import '../../../../data_source/models/message_model/message_delails.dart';
import '../../../../data_source/models/message_model/relpay.dart';
import '../../../../data_source/remote/messages_service.dart';
import '../../../../data_source/remote/recitation_services.dart';
import '../../../../data_source/user_services_data.dart';

part 'messagedetails_state.dart';

class MessagedetailsCubit extends Cubit<MessagedetailsState> {
  static MessagedetailsCubit get(context) => BlocProvider.of(context);
  MessagedetailsCubit() : super(MessagedetailsInitial());

  MessageDelails? messageDetails;
  Recitation? recitationDetails;
  String ayah = '';
  User? user;

  int indexPlay = -2;
  bool isPlay = false;

  bool isViewInput = false;
  bool isRelpy = false;
  int? parentId;

  bool isATeacher = false;

  setIsSend() {
    messageDetails?.isSent = true;
    emit(MessageFetchedState());
  }

  Future<void> init() async {
    user = await UserDataServices.instance.getUserData();
    isATeacher = user?.isTeacher ?? false;
  }

  changeRecitation(Recitation recitationDetails) {
    this.recitationDetails = recitationDetails;
    emit(MessageLoadingState());
    emit(MessageFetchedState());
  }

  fetchMessages(int msgId, int recitationId) async {
    await init();

    ayah = '';
    emit(MessageLoadingState());
    AppDataSource()
        .messageDetails(messageId: msgId, recitationId: recitationId)
        .then((value) async {
      if (value != null) {
        messageDetails = MessageDelails.fromMap(value.data);

        Response? response =
            await GetMessages().recitationsDetails(recitationId: recitationId);
        if (response != null &&
            response.statusCode == 200 &&
            response.data != null) {
          recitationDetails = Recitation.fromJson(response.data);
        }

        // print(
        //     'verses is ${messageDetails?.recitation.toString()}  response ${value.data}');

        // messageDetails!.recitation!.chapterName = (await DataSource.instance
        //         .fetchChapterById(messageDetails!.recitation!.chapterId ?? 0))
        //     ?.name;

        // messageDetails!.recitation!.narrationName = (await DataSource.instance
        //         .fetchNarrationById(
        //             messageDetails!.recitation!.narrationId ?? 0))
        //     ?.name;

        // for (var element in messageDetails!.recitation!.verseIds!) {
        //   Verse? text = await DataSource.instance.fetchVerseById(element);
        //   if (text != null) {
        //     ayah += '  ' + (text.text ?? '');
        //   } else {
        //     print('not found ayah $element');
        //   }
        // }
        emit(MessageFetchedState());
      } else {
        emit(MessageErrorState());
      }
    }).catchError((error) {
      ExceptionHandling.hanleToastFromException(error);
      emit(MessageErrorState());
    });
  }

  fetchRecitation(int recitationId) async {
    ayah = '';
    emit(MessageLoadingState());
    AppDataSource().recitationDetails(recitationId).then((value) async {
      if (value != null) {
        recitationDetails = value;
        // for (var element in recitationDetails!.verseIds!) {
        //   Verse? text = await DataSource.instance.fetchVerseById(element);
        //   if (text != null) {
        //     ayah += '  ' + text.text!;
        //     print(ayah);
        //   } else {
        //     print('not found ayah $element');
        //   }
        // }
        emit(MessageFetchedState());
      } else {
        emit(MessageErrorState());
      }
    }).catchError((error) {
      ExceptionHandling.hanleToastFromException(error);
      emit(MessageErrorState());
    });
  }

  markAsFinished(int id) async {
    await GetMessages().markAsFinished(id);
    fetchRecitation(id);
  }

  addToGeneral(int id) async {
    await GetMessages().addToGeneral(id);
    fetchRecitation(id);
  }

  deleteRecitations(int id) async {
    await GetMessages().deleteRecitations(id);
    fetchRecitation(id);
  }

  void setViewInput(bool b, int? id) {
    isViewInput = b;
    isRelpy = b;
    parentId = id;

    emit(MessageEmptyState());
  }

  void reset() {
    indexPlay = -1;
    isPlay = false;
    emit(MessageFetchedState());
    emit(MessagedetailsInitial());
  }

  void setIndexPlay(int i) {
    indexPlay = i;
    isPlay = true;
    emit(MessageFetchedState());
  }

  void addRelpy(Reply reply) {
    for (Reply element in messageDetails!.replies!) {
      if (element.id == reply.parent) {
        //  element.records = reply.records;
        if (element.children != null) {
          element.children!.add(reply);
        } else {
          element.children = [reply];
        }
        emit(MessageFetchedState());
        return;
      }
    }

    if (messageDetails!.replies != null) {
      messageDetails!.replies!.add(reply);
    } else {
      messageDetails!.replies = [reply];
    }
    emit(MessageFetchedState());
  }

  deleteReply(int replyId) async {
    var res = await UserRecitationApi().deleteReply(
        messageDetails?.recitation?.id ?? 0, messageDetails?.id ?? 0, replyId);
    //print('res $res status ${res!.statusCode}');
    if (res != null &&
        (res.statusCode ?? 0) >= 200 &&
        (res.statusCode ?? 0) < 299) {
      for (Reply element in messageDetails!.replies!) {
        if (element.id == replyId) {
          messageDetails!.replies!.remove(element);
          emit(MessageFetchedState());
          return;
        }
        if (element.children != null) {
          for (Reply element2 in element.children!) {
            if (element2.id == replyId) {
              element.children!.remove(element2);
              emit(MessageFetchedState());
              return;
            }
          }
        }
      }
      emit(MessageFetchedState());
    }
  }

  void dispose() {
    indexPlay = -2;
    isPlay = false;
    emit(MessageFetchedState());
  }
}
