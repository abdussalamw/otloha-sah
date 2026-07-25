import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../data_source/data_source.dart';
import '../../../../data_source/models/room/room.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/verses_local_data_source.dart';
import 'package:quran_widget_flutter/model/verse.dart';

part 'message_details_state.dart';

class MessageDetailsCubit extends Cubit<MessageDetailsState> {
  MessageDetailsCubit() : super(MessageDetailsInitial());

  static MessageDetailsCubit get(BuildContext context) =>
      BlocProvider.of(context);
  String ayha = '';
  String? selectAyha;

  Recitation? recitation;

  bool? isAccept;
  bool isMark = false;
  int? rate;

  Room? room;

  setRoom(Room room) {
    this.room = room;
  }

  resetVerse() {
    selectAyha = '';
    emit(MessageDetailsResetFormState());
  }

  changeIsAccept({required bool isAccept}) {
    this.isAccept = isAccept;
    isMark = isAccept ? isMark : false;
    emit(ActionOnMessageChangeIsAcceptState());
  }

  changeIsMark({required bool isMark}) {
    this.isMark = isMark;
    emit(ActionOnMessageChangeIsMarkState());
  }

  setRecitation(Recitation recitation) async {
    this.recitation = recitation;
    ayha = '';
    // print(recitation.verseIds.);
    if (recitation.verseIds != null && recitation.verseIds!.isNotEmpty) {
      List<Verse> verses = await VersesLocalDataSource().findVersesBetween(
          recitation.getVerseList().first, recitation.getVerseList().last);
      verses.forEach((element) {
        print(element.text);
        ayha += element.text!;
      });
    } else {
      ayha = recitation.name ?? '';
    }
  }

  Future finishEvaluation({String? recitationResult}) async {
    Map<String, dynamic> data;
    String? result = recitationResult ?? 'accepted';

    if (rate == null && recitationResult == 'accepted') {
      Fluttertoast.showToast(
        msg: 'قيم التلاوه',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    data = {
      'result': result,
    };
    if (rate != null) {
      data['teacher_rate'] = rate;
    }
    if (isMark) {
      data['is_remarkable'] = true;
    }
    emit(ActionOnMessagLoading());

    await ExceptionHandling.hanleToastException(() async {
      Response res = await AppDataSource().finishEvaluation(
        data: data,
        id: recitation?.id ?? 0,
      );
      isAccept = null;
      isMark = false;
      rate = null;
      emit(ActionOnMessageFinishDoneState());
      return res;
    }, '', false);

    isAccept = null;
    isMark = false;
    rate = null;
    emit(ActionOnMessageFinishErrorState());
  }

  // void saveForm(Function addMessage) async {
  //   addMessage();

  // if (isFormEdit) {
  //   comments.removeAt(indexComment);
  //   comments.insert(
  //     indexComment,
  //     Comment(
  //       comment: controller.text,
  //       title: selectAyha,
  //       record: isRecorded ? current?.path : null,
  //       type: _getTrypString(),
  //     ),
  //   );
  // } else {
  //   comments.add(
  //     Comment(
  //       comment: controller.text,
  //       title: selectAyha,
  //       record: isRecorded ? current?.path : null,
  //       type: _getTrypString(),
  //     ),
  //   );
  // }

  // isFormEdit = false;
  // indexComment = -1;
  // controller.clear();
  // current = null;
  // selectedType = null;
  // selectAyha = null;
  // isRecorded = false;
  //   emit(MessageDetailsRecetFormState());
  // }

  // changeErrorType(ErrorType errorType) {
  //   selectedType = errorType;

  //   emit(MessageDetailsChangeSelectedTypeState());
  // }

  void onSelectionChanged(
      TextSelection selection, SelectionChangedCause? cause) {
    selectAyha = ayha.substring(selection.start, selection.end);
    emit(MessageDetailsChangeSelectedTextState());
  }

  // deleteComment(int index) {
  //   // comments.removeAt(index);
  //   emit(MessageDetailsDeleteCommentState());
  // }

  // editMessage(int index) {
  //   EvaluationMessage evaluationMessage = messages[index];

  //   // selectAyha = comment.title;
  //   // controller.text = comment.comment ?? '';

  //   // selectedType = _getStringType(comment.type);

  //   indexComment = index;
  //   isFormEdit = true;
  //   emit(MessageDetailsEditCommentState());
  // }

  // List<EvaluationMessage> messages = [];

  // String? _getTrypString() {
  //   switch (selectedType) {
  //     case ErrorType.pronunciation:
  //       return 'نطــق';

  //     case ErrorType.word:
  //       return 'كلمـة';

  //     case ErrorType.tajweed:
  //       return 'تجويد';

  //     default:
  //       return null;
  //   }
  // }

  // ErrorType? _getStringType(String? type) {
  //   switch (type) {
  //     case 'نطــق':
  //       return ErrorType.pronunciation;

  //     case 'كلمـة':
  //       return ErrorType.word;

  //     case 'تجويد':
  //       return ErrorType.tajweed;

  //     default:
  //       return null;
  //   }
  // }

  // void clearDate() {
  //   isFormEdit = false;
  //   indexComment = -1;
  //   controller.text = '';
  //   selectedType = null;
  //   selectAyha = null;
  //   emit(MessageDetailsRecetFormState());
  // }

  // setIndexPlayer(int? index) {
  //   indexPlayer = index ?? -1;
  //   emit(MessageDetailsChangeIndexPlayerState());
  // }

  void setRate(double rating) {
    rate = rating.round();
  }
}
