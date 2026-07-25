import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../data_source/models/message_model/relpay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_source/models/message_model/error_type.dart';
import '../../../../data_source/models/message_model/reply_request.dart';
import '../../../../data_source/remote/messages_service.dart';
import '../../../audio/service/record_service.dart';

import 'reply_state.dart';

class ReplyCubit extends Cubit<ReplyState> {
  ReplyCubit() : super(InitialReplyState());

  static ReplyCubit get(context) => BlocProvider.of(context);

  TextEditingController messageController = TextEditingController();

  LocalFileSystem? localFileSystem;
  Stream<Duration> duration = const Stream.empty();
  String? filePath;
  String? filePathWave;
  String? ayahText;
  ErrorType? errorType;
  FocusNode focusNode = FocusNode();

  String? text;
  bool viewMessage = false;
  bool isRelpay = false;
  RecordServiceApp recordServiceApp = RecordServiceApp();

  void setInit() {
    text = null;
    viewMessage = false;
    isRelpay = false;
    emit(InitialReplyState());
  }

  setIsReply(bool b) {
    isRelpay = b;
    emit(ChangeIsReply());
  }

  setText(String str) {
    text = str;
    emit(DataChange());
  }

  setViewMessage(bool b) {
    viewMessage = b;
    emit(DataChange());
  }

  Future saveRelpy(int recitationId, int msgId, int? parentId, String select,
      {ErrorType? errorType}) async {
    try {
      emit(LoadingSaveState());
      this.errorType = errorType;
      String comment = messageController.text;

      if (comment.isNotEmpty || (filePath != null && filePath!.isNotEmpty)) {
        ReplyRequest replyRequest = ReplyRequest(
          recitationId: recitationId,
          messageId: msgId,
          parentId: parentId,
          errorType: (this.errorType != null) ? this.errorType!.key : null,
          record: filePath,
          comment: messageController.text,
          text: select,
          wave: filePathWave,
          positionFrom: (ayahText != null && text != null)
              ? ayahText!.indexOf(text![0])
              : 0,
          positionTo: (ayahText != null && text != null)
              ? ayahText!.indexOf(text![text!.length - 1])
              : 0,
        );

        Response? response = await GetMessages().replyMessages(replyRequest);

        if (response != null &&
            response.statusCode! <= 299 &&
            response.statusCode! >= 200) {
          messageController.clear();
          filePath = null;
          filePathWave = null;
          var reply = Reply.fromJson(response.data['data']);
          emit(SavedState(reply: reply));
        } else {
          emit(SavedErrorState());
        }
      } else {
        emit(SavedErrorState());
      }
    } on Exception catch (e, _) {
      ExceptionHandling.hanleToastFromException(e);
    }
  }

  Future init(context) async {
    try {
      await recordServiceApp.initRecord(context, onSubmitPath: (path) {
        filePath = path;
        emit(StartRecordingState(time: '00:00'));
      }, onChangeDuration: (duration) {
        emit(
          StartRecordingState(
            time:
                '${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}',
          ),
        );
      });
      // filePathWave = await WaveFromServiceApp.instance.init();
      waveFile = File(filePathWave!);
    } catch (e) {
      print(e);
    }
  }

  File? waveFile;

  Future stop() async {
    try {
      await recordServiceApp.stop();
      emit(EndRecordingState());
    } catch (e) {
      print(e);
    }
  }

  Future delete() async {
    File file = File(filePath!);
    file.delete();
    emit(DeleteRecordState());
  }

  AudioPlayer audioPlayer = AudioPlayer();
  void onPlayAudio() async {
    await audioPlayer.play(DeviceFileSource(filePath!));
    emit(PlayerIsPlay());
  }

  void onPauseAudio() async {
    await audioPlayer.pause();
    emit(PlayerIsPause());
  }

  void setErrorType(ErrorType? errorType) {
    this.errorType = errorType;
    emit(ReplyStateDefult());
  }

  void setAyah(String ayah) {
    ayahText = ayah;
    emit(ReplyStateDefult());
  }

  void setFoucs() {
    focusNode.nextFocus();
    focusNode.requestFocus();
  }

  emitLoaading() {
    emit(LoadingSaveState());
  }
}
