import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/local_recitation.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/model/verse.dart';

import '../../../../data_source/local/database/database_repository.dart';
import '../../../audio/service/record_service.dart';

part 'recitation_state.dart';

class RecitationAddCubit extends Cubit<RecitationAddState> {
  RecitationAddCubit() : super(RecitationInitial());

  static RecitationAddCubit get(context) =>
      BlocProvider.of<RecitationAddCubit>(context);

  AudioPlayer audioPlayer = AudioPlayer();
  RecordServiceApp recordServiceApp = RecordServiceApp();
  Duration? recordDuration;

  bool isPlaying = false;
  final int _narrationId = 1;

  bool checkVersesValue = false;
  List<Verse> selectedVerses = [];
  File? waveFile;
  String? filePath;

  Future init(context, Function() onStop) async {
    await recordServiceApp.initRecord(
      context,
      onSubmitPath: (path) {
        filePath = path;
      },
      onChangeDuration: (duration) {
        recordDuration = duration;
        emit(ChangeDurationState());
        if (duration.inMinutes == 3) {
          Fluttertoast.showToast(
              msg: tr('recitation_duration_cant_be_more_than_3_minutes'));
          emit(PlayerIsPause());
          stop(onStop);
        }
      },
    );
  }

  void onPlayAudio() async {
    if (isPlaying) {
      await audioPlayer.pause();
      isPlaying = false;
      emit(PlayerIsPause());
    } else {
      isPlaying = true;
      emit(PlayerIsPlay());
      await audioPlayer.play(DeviceFileSource(filePath!));
      audioPlayer.onPlayerStateChanged.listen((event) {
        if (event == PlayerState.completed) {
          isPlaying = false;
          emit(PlayerIsPause());
        }
      });
    }
  }

  Future<dynamic> saveRecitation() async {
    // waveFile = File(p.join((await getApplicationDocumentsDirectory()).path,
    //     '${DateTime.now().microsecondsSinceEpoch}.wave'));

    // await WaveFromServiceApp.instance.extract(current!.path, waveFile);
    // print('aslaklkasnlasn');
    List<int> recordedVersesId = [];
    for (var verse in selectedVerses) {
      if (verse.id != null) {
        recordedVersesId.add(verse.id!);
      }
    }

    int chapId = 1;
    if (selectedVerses.isNotEmpty) {
      chapId = selectedVerses.first.chapterId ??
          selectedVerses.first.chapterNumber ??
          QuranCacheRepository.selectedChapterId;
    } else {
      chapId = QuranCacheRepository.selectedChapterId;
    }
    if (chapId <= 0) chapId = 1;

    var userRecitation = LocalRecitation(
      narrationId: _narrationId,
      record: filePath ?? '',
      name: getName(),
      versesList: recordedVersesId,
      chapterId: chapId,
      userId: UserDataServices.instance.getUserDataFast()?.id ?? 0,
    );

    var recitation =
        await DatabaseRepository.instance.insertUserRecitations(userRecitation);
    return recitation;
  }

  setSelectedVerses(List<Verse> verses) {
    selectedVerses = verses;
    emit(state);
  }

  getName() {
    if (selectedVerses.isEmpty) return 'تلاوة مسجلة';
    String? text = selectedVerses.first.text;
    return getFirstWords(text ?? 'تلاوة مسجلة', 5);
  }

  String getFirstWords(String sentence, int wordCounts) {
    try {
      return sentence.split(' ').sublist(0, wordCounts).join(' ');
    } catch (e) {
      return sentence;
    }
  }

  stop(Function() onStop) async {
    final finalPath = await recordServiceApp.stop();
    if (finalPath != null && finalPath.isNotEmpty) {
      filePath = finalPath;
    }
    recordDuration = null;
    onStop();
  }
}
