import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../audio/service/record_service.dart';
import 'record_state.dart';

class RecordCubit extends Cubit<RecordState> {
  RecordCubit() : super(RecordInitial()) {
    // RecordServiceApp.initRecord();
  }

  RecordServiceApp recordServiceApp = RecordServiceApp();
  AudioPlayer audioPlayer = AudioPlayer();
  late Function onStop;
  bool isReset = false;
  String? filePath;
  Duration duration = const Duration(seconds: 0, minutes: 0);

  void setOnStop(Function onStop) {
    this.onStop = onStop;
  }

  void startRecord(context) async {
    emit(RecordingState(duration: 0));
    duration = const Duration(seconds: 0, minutes: 0);
    await recordServiceApp.initRecord(context, onSubmitPath: (path) {
      filePath = path;
    }, onChangeDuration: (duration) {
      this.duration = duration;
      emit(RecordingState(duration: duration.inSeconds));
    });
  }

  Future<void> stopRecord() async {
    isReset = false;
    if (await recordServiceApp.recorder.isRecording()) {
      await recordServiceApp.stop();
      print(filePath);
      onStop(filePath);
      emit(PauseRecordState());
    }
  }

  Future<void> reset({bool isReset = true}) async {
    if (await recordServiceApp.recorder.isRecording()) {
      await recordServiceApp.stop();
    }
    filePath = null;

    this.isReset = isReset;
    emit(RecordInitial());
  }

  String get timer {
    return '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  static RecordCubit get(BuildContext context) =>
      BlocProvider.of<RecordCubit>(context);

  void playRecordedFile() {
    emit(PlayRecordedFileState());
    audioPlayer = AudioPlayer()
      ..onPlayerComplete.listen((event) {
        emit(PauseRecordedFileState());
      });
    audioPlayer.play(DeviceFileSource(filePath!));
  }

  void pauseRecordedFile() async {
    await audioPlayer.pause();
    emit(PauseRecordedFileState());
  }

  playPauseAction() {
    if (state is PlayRecordedFileState) {
      pauseRecordedFile();
    } else if (state is PauseRecordedFileState || state is PauseRecordState) {
      playRecordedFile();
    } else {
      emit(PauseRecordedFileState());
    }
  }
}
