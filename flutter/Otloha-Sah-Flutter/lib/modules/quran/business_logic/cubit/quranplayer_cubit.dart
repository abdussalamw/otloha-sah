import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/audio/service/audio_service.dart';
import 'package:quran_widget_flutter/audio/service/player_service.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/network_helper/network_exception.dart'
    as plugin_exceptions;

part 'quranplayer_state.dart';

class QuranPlayerCubit extends Cubit<QuranPlayerState> {
  QuranPlayerCubit() : super(QuranPlayerInitial());

  bool get isPlaying => _isPlaying;

  bool _isPlaying = false;

  late QuranController quranController;

  void setQuranController(QuranController quranController) {
    this.quranController = quranController;
  }

  static QuranPlayerCubit get(context) =>
      BlocProvider.of<QuranPlayerCubit>(context);

  int chapterId = 0;
  AudioServiceRepeatMode audioServiceRepeatMode = AudioServiceRepeatMode.none;
  int recitationId = 0;
  bool isRecitationVersesFetched = false;
  IconData iconData = Icons.loop;
  List<RecitationVerses>? recitationVerses = [];
  Verse? playingVerse;
  List<Verse>? selectedVerses;
  late StreamSubscription playVerseIndexStreamSubscription;

  Future<bool> initRecitationVerses({
    required int chapterId,
    int? pageNumber,
    List<Verse>? selectedVerses,
    required context,
  }) async {
    emit(InitialLoadingPlayerState());
    try {
      await quranController.playerController.initVerses(onDownload: (progress) {
        emit(DownloadingChapterState(progress: progress));
      }, onCompelete: () {
        emit(DownloadingCompeleteState());
      }, onPlayStateChanged: (event) {
        _isPlaying = event.processingState == ProcessingState.ready &&
            (PlayerServiceApp.isPlaying() ?? false);
        emit(PlayerStateChange(_isPlaying ? 'play' : 'pause'));
      });
    } on plugin_exceptions.NetworkConnectionException catch (_) {
      Fluttertoast.showToast(
        msg: tr('Please check internet'),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
    _isPlaying = true;

    emit(FinishLoadingPlayerState());
    return true;
  }

  onNext() async {
    await quranController.playerController.next();
  }

  onPrevious() async {
    await quranController.playerController.previous();
  }

  void playVerses() async {
    quranController.playerController.play();
    _isPlaying = true;
    emit(const PlayerStateChange('play'));
  }

  void pausePlayer() async {
    await quranController.playerController.pause();
    _isPlaying = false;
    emit(const PlayerStateChange('pause'));
  }

  stopPlayer() async {
    await quranController.playerController.stop();
    _isPlaying = false;
    emit(const PLayerIndexChanged(index: 0));
  }

  setRepeatMode() async {
    AudioServiceRepeatMode audioServiceRepeatMode =
        await quranController.playerController.changeRepeateMode();
    this.audioServiceRepeatMode = audioServiceRepeatMode;
    print('audio repeate mode $audioServiceRepeatMode');
    emit(PlayerRepeatModeChange(repeatMode: audioServiceRepeatMode));
  }

  void setPageChange() async {
    if (_isPlaying == true) {
      _isPlaying = false;
      await stopPlayer();
      emit(const PlayerStateChange('stop'));
    }
  }
}
