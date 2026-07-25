import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../data_source/models/message_model/message_model.dart';
import '../../../../data_source/remote/room_services.dart';
import 'evaluation_form_state.dart';
import 'package:web_socket_channel/io.dart';

enum FaultType {
  pronunciation,
  word,
  tajweed,
}

FaultType? stringToFaultType(String? faultType) {
  switch (faultType) {
    case 'pronunciation':
      return FaultType.pronunciation;
    case 'word':
      return FaultType.word;
    case 'tajweed':
      return FaultType.tajweed;
    default:
      return null;
  }
}

extension ParseToString on FaultType {
  String toShortString() {
    return toString().split('.').last;
  }

  String toTranslatedString() {
    if (this == FaultType.pronunciation) {
      return 'نطق';
    } else if (this == FaultType.word) {
      return 'كلمه';
    } else if (this == FaultType.tajweed) {
      return 'تجويد';
    } else {
      return 'غير معروف';
    }
  }
}

class EvaluationFormCubit extends Cubit<EvaluationFormState> {
  String? errorText;
  TextEditingController commentController;
  FaultType? faultType;
  String verseText;
  String? recordPath;
  IOWebSocketChannel channel;
  MessageModel? message;

  EvaluationFormCubit({
    required this.commentController,
    required this.verseText,
    required this.channel,
    this.recordPath,
    this.faultType,
    this.errorText,
  }) : super(EvaluationFormInitial());

  static EvaluationFormCubit get(BuildContext context) =>
      BlocProvider.of<EvaluationFormCubit>(context);

  void setErrorText(String? errorText) {
    if (errorText != null) {
      this.errorText = errorText.isNotEmpty ? errorText : null;
      emit(SelectErrorTextState());
    }
  }

  void editMessage(MessageModel message) {
    this.message = message;
    commentController.text = message.text;
    errorText = message.fault != null ? message.fault!.errorText : null;
    faultType = message.fault != null
        ? stringToFaultType(message.fault!.faultType)
        : null;

    // recordPath = message.record != null ? message.record!.record : null;
    emit(EditEvaluationFormState(message));
  }

  void setFaultType(FaultType faultType) {
    this.faultType = faultType;
    emit(SelectFaultTypeState());
  }

  void setRecordPath(String? recordPath) {
    this.recordPath = recordPath;
    emit(SelectRecordPathState());
  }

  void reset() {
    print('reset');
    message = null;
    commentController.clear();
    errorText = null;
    faultType = null;
    recordPath = null;
    emit(EvaluationFormInitial());
  }

  Future<void> submitEvaluationForm() async {
    print('xmvcm,xc,vmnxcvn,');
    int? recordId;
    Map<String, dynamic> message = {
      'recitation': true,
    };
    print(recordPath != null || commentController.text.isNotEmpty);
    if (recordPath != null || commentController.text.isNotEmpty) {
      emit(EvaluationFormLoadingSate());
      if (recordPath != null) {
        try {
          recordId = await RoomServices().uploadRecord(recordPath!);
        } catch (_) {}
        recordId = await RoomServices().uploadRecord(recordPath!);
      }

      if (recordId != null) {
        message['record'] = recordId;
      }
      if (faultType != null) {
        message['fault_type'] = faultType!.toShortString();
      }
      if (commentController.text.isNotEmpty) {
        message['text'] = commentController.text;
      }
      if (errorText != null) {
        message['error_text'] = errorText;
        message['position_from'] = verseText.indexOf(errorText!);
        message['position_to'] =
            errorText!.length + verseText.indexOf(errorText!);
      }
      if (faultType != null) {
        message['fault_type'] = faultType!.toShortString();
      }
      if (recordId != null) {
        message['record'] = recordId;
      }
      if (faultType == null && errorText != null) {
        Fluttertoast.showToast(msg: 'Choose fault type'.tr());
      } else {
        print(message);
        if (this.message == null) {
          channel.sink.add(jsonEncode({
            'type': 'add_message',
            'message': message,
          }));
        } else {
          message['id'] = this.message!.id;
          message['room'] = this.message!.room;
          channel.sink.add(jsonEncode({
            'type': 'edit_message',
            'message': message,
          }));
        }
        reset();
        emit(EvaluationFormSubmitState());
      }
    }
  }

  static deleteMessage(int id) {
    return jsonEncode({
      'type': 'delete_message',
      'message': {'id': id}
    });
  }
}
