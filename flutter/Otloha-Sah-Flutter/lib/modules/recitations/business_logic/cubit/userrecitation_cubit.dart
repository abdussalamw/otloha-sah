// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:otloha_sah_flutter/core/error/exceptions.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/data_source/data_source.dart';
import 'package:otloha_sah_flutter/data_source/local/database/database_repository.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/local_recitation.dart';

import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart'
    as re;
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/audio/service/record_service.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

part 'userrecitation_state.dart';

class UserRecitationCubit extends Cubit<UserRecitationState> {
  UserRecitationCubit() : super(UserRecitationInitial());
  List<re.Recitation> userRecitatios = [];
  List<LocalRecitation> localUserRecitations = [];
  List<List<Verse>> userRecitationVerses = [];
  RecordServiceApp recordServiceApp = RecordServiceApp();

  re.Recitation? recitation;
  String? ayah;
  String? filePath;
  String? filePathWave;
  bool isLocal = false;

  int indexPlay = -2;

  static UserRecitationCubit get(context) => BlocProvider.of(context);

  void setRecitationChange(int index, re.Recitation recitation) {
    print('after change ${recitation.showInRemarkable}');
    con?.itemList![index] = recitation;
    emit(UserRecitationLoading());
    emit(UserRecitationFetched());
  }

  Future fetchSentRecitation(int keyNext) async {
    // if (localUserRecitations.isEmpty || userRecitatios.isEmpty) {
    emit(UserRecitationLoading());
    localUserRecitations = (await DatabaseRepository.instance
            .fetchUserRecitations(UserDataServices.instance.getUserId()!)) ??
        [];

    emit(SentRecitationFetched());

    List<re.Recitation>? userRec;

    try {
      Map<String, dynamic>? result = await AppDataSource()
          .getUserReciataions(keyNext, UserDataServices.instance.getUserId()!);
      userRec = result!['recitations'];

      if (userRec != null && userRec.isNotEmpty) {
        isLocal = result['isLocal'];
        userRecitatios = userRec;

        emit(UserRecitationFetched());
      } else {
        emit(UserRecitationError(EmptyListException()));
      }
    } catch (e) {
      // Fluttertoast.showToast(
      //   msg: e.toString(),
      //   gravity: ToastGravity.BOTTOM,
      // );
      if (e is Exception) {
        emit(UserRecitationError(e));
      }
    }
    // }
  }

  getSetecetReciation(int recitationId) async {
    emit(UserRecitationLoading());
    recitation =
        userRecitatios.firstWhere((element) => element.id == recitationId);

    if (recitation != null) {
      ayah = '';
      for (int verseId in recitation!.getVerseList()) {
        Verse? verse = await DataSource.instance.fetchVerseById(verseId);
        ayah = '${ayah!}${verse?.text ?? '  '}  ';
      }
      emit(UserRecitationFetched());
    } else {
      emit(UserRecitationFetched());
    }
  }

  deleteRecitation(int index) async {
    con?.itemList!.removeAt(index);
    emit(RemoveUserRecitationState());
  }

  getNextData(int nextLink) async {
    Response? response;

    response = await ApiBaseHelper().getHTTP(
      '/api/v1/recitations/',
      queryParameters: {'page': nextLink},
      dioTypes: DioTypes.authRequired,
    );

    List<re.Recitation> recitations = (response?.data['results'] as List)
        .map((e) => re.Recitation.fromJson(e))
        .toList();

    // for (var e in recitations) {
    //   if (e.record != null) {
    //     FileStorage()
    //         .download2(
    //       url: '${Constants.baseUrl}${e.record!.record}',
    //       savePath: '/records/recitations/${e.id}.mp3',
    //       showDownloadProgress: ((p0, p1) {}),
    //     )
    //         .then((value) {
    //       DatabaseRepository.instance
    //           .downloadRecitation(e.copyWith(localRecord: value?.path));
    //     });
    //   }
    // }

    if (response?.statusCode == 200 &&
        response?.data['results'] != null &&
        (response?.data['results'] as List).isNotEmpty) {
      for (var element in (response?.data['results'] as List)) {
        element['chapterName'] = (await DataSource.instance.fetchChapterById(
                int.parse(element['chapter_id'] ?? '0'),
                int.parse(element['narration_id'] ?? '0')))
            ?.name;

        element['narrationName'] = (await DataSource.instance
                .fetchNarrationById(int.parse(element['narration_id'] ?? '0')))
            ?.name;
      }
    }

    return response;
  }

  Future init(context) async {
    recordServiceApp.initRecord(
      context,
      onSubmitPath: (path) {
        filePath = path;
      },
      onChangeDuration: (duration) {},
    );
  }

  Future stop() async {
    recordServiceApp.stop();
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

  void updateDate(String value, int index) {
    emit(UserRecitationInitial());
    con!.itemList![index].finishedAt = value;
    emit(UserRecitationFetched());
  }

  PagingController? con;
  void setCon(PagingController con) {
    this.con = con;
  }

  void setIndexPlay(int index) {
    indexPlay = index;
    emit(ChangeIndexState());
  }

  void reset() {
    emit(UserRecitationInitial());
  }
}
