import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:otloha_sah_flutter/core/error/exceptions.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/data_source/models/record/record.dart';
import 'package:otloha_sah_flutter/modules/audio/business_logic/playback_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:equatable/equatable.dart';

part 'player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final Record? record;
  late AudioPlayer playerController;
  final PlaybackManagerCubit playbackManagerCubit;
  late StreamSubscription streamSubscription;
  final String? localFilePath;

  AudioPlayerCubit(
    this.record,
    this.localFilePath,
    this.playbackManagerCubit,
    this.playerController,
  ) : super(AudioPlayerInitial()) {
    initialize();
  }

  Future<void> initialize() async {
    emit(AudioPlayerLoading());
    final directory = await getApplicationDocumentsDirectory();
    String filePath = '';
    if (localFilePath != null) {
      filePath = localFilePath!;
    }
    if (record != null){
      filePath = '${directory.path}/${record!.filename}';
    }
    final file = File(filePath);

    streamSubscription = playbackManagerCubit.stream.listen((event) {
      if ((event is PlaybackManagerPlaying && (event).filePath != filePath) && state is AudioPlayerPlaying) {
        pause();
      }
    });

    if (await file.exists()) {
      await _preparePlayer(filePath);
      emit(AudioPlayerReady(filePath));
    } else {
      emit(const AudioPlayerError('File not found. Please download it.'));
    }

    playerController.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.paused) {
        emit(AudioPlayerReady(filePath));
      }
    });

    playerController.onPlayerComplete.listen((_) async {
      // await playerController.seekTo(0);
      emit(AudioPlayerReady(filePath));
    });
  }

  Future<void> downloadFile() async {
    emit(AudioPlayerDownloading());
    final dio = ApiBaseHelper().dio;
    final url = '/api/v1/records/${record?.uuid}/download/';

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${record?.filename}';


    try {
      final response = await dio.download(url, filePath);
      if (response.statusCode == 200) {
        await _preparePlayer(filePath);
        emit(AudioPlayerReady(filePath));
      } else {
        emit(const AudioPlayerError('Failed to download file'));
      }
    } on Exception catch (e) {
      ExceptionHandling.hanleToastFromException(
          ExceptionHandling.convertException(e));
      emit(AudioPlayerError('Error downloading file: $e'));
    }
  }

  Future<void> _preparePlayer(String filePath) async {
    await playerController.setSource(
      DeviceFileSource(filePath)
    );
  }

  Future<void> play() async {
    if (state is AudioPlayerReady || state is AudioPlayerStopped) {
      playbackManagerCubit.startPlayback((state as AudioPlayerReady).filePath);
      await playerController.play(DeviceFileSource((state as AudioPlayerReady).filePath));
      emit(AudioPlayerPlaying((state as AudioPlayerReady).filePath));
    }
  }

  Future<void> pause() async {
    await playerController.pause();
  }

  Future<void> stop() async {
    await playerController.stop();
    emit(AudioPlayerReady((state as AudioPlayerPlaying).filePath));
  }

  @override
  Future<void> close() {
    playerController.dispose();
    streamSubscription.cancel();
    return super.close();
  }
}
