import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../data_source/remote/recitation_services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../audio/service/record_service.dart';
import 'package:quran_widget_flutter/data_source/data_source.dart';
import 'package:quran_widget_flutter/model/verse.dart';

part 'updaterecitation_state.dart';

class UpdateRecitationCubit extends Cubit<UpdateRecitationState> {
  UpdateRecitationCubit(this.recitation) : super(UpdateRecitationInitial()) {
    getSetecetReciation(recitation);
  }

  static UpdateRecitationCubit get(context) => BlocProvider.of(context);
  Recitation recitation;
  String? ayah;
  bool isRecitationRecordPlaying = false;
  bool isRecording = false;
  String? recordPath;

  RecordServiceApp recordServiceApp = RecordServiceApp();

  playRecitationRecord() {
    isRecitationRecordPlaying = true;
    emit(ChangePlayingNowState(isRecitationRecordPlaying));
  }

  pauseRecitationRecord() {
    isRecitationRecordPlaying = false;
    emit(ChangePlayingNowState(isRecitationRecordPlaying));
  }

  List<RecordUpdate> recitationsUpdate = [];

  getSetecetReciation(Recitation recitationId) async {
    emit(UpdateRecitationLoading());

    recitation = recitationId;

    ayah = '';
    for (int verseId in recitation.getVerseList()) {
      Verse? verse = await DataSource.instance.fetchVerseById(verseId);
      ayah = ayah! + (verse?.text ?? ' ') + ' ';
    }
    emit(UserRecitationFetched());
  }

  updateRecitation(context) async {
    Loader.show(context);
    await ExceptionHandling.hanleToastException(() async {
      if (recordPath != null) {
        recitation = await UserRecitationApi().updateRecitation(
          recitation.id,
          recitation.record?.id ?? 0,
          recordPath!,
        );
        emit(RecitationUpdated());
      }
    }, 'recitation_updated'.tr(), true);
    Loader.hide();
  }

  Future init(context) async {
    await recordServiceApp.initRecord(
      context,
      onSubmitPath: (path) {
        recordPath = path;
      },
      onChangeDuration: (duration) {
        emit(ChangeDurationState(duration));
      },
    );
  }

  bool isPlay = false;

  start(context) async {
    await init(context);
    isRecording = true;
  }

  Future stop() async {
    recordServiceApp.stop();
    isRecording = false;
    emit(UpdatedRecitationRecorded());
  }

  Future delete() async {
    File file = File(recordPath!);
    file.delete();
    emit(DeleteRecordState());
  }

  AudioPlayer audioPlayer = AudioPlayer();
  void onPlayAudio() async {
    await audioPlayer.play(DeviceFileSource(recordPath!));
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.completed) {
        isPlay = false;
        emit(PlayerIsPause());
      }
    });
    isPlay = true;
    emit(PlayerIsPlay());
  }

  void onPauseAudio() async {
    await audioPlayer.pause();
    isPlay = false;
    emit(PlayerIsPause());
  }

  save() async {
    await stop();

    var waveFile = File(p.join((await getApplicationDocumentsDirectory()).path,
        '${DateTime.now().microsecondsSinceEpoch}.wave'));

    // await WaveFromServiceApp.instance.extract(current?.path ?? '', waveFile);
    recitationsUpdate
        .add(RecordUpdate(record: recordPath!, wave: waveFile.path));
    emit(UpdateListState());
  }

  void deleteRecord(int index) {
    recitationsUpdate.removeAt(index);
    emit(UpdateListState());
  }
}

class RecordUpdate {
  final String record;
  final String wave;
  RecordUpdate({
    required this.record,
    required this.wave,
  });

  RecordUpdate copyWith({
    String? record,
    String? wave,
  }) {
    return RecordUpdate(
      record: record ?? this.record,
      wave: wave ?? this.wave,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'record': record});
    result.addAll({'wave': wave});

    return result;
  }

  factory RecordUpdate.fromMap(Map<String, dynamic> map) {
    return RecordUpdate(
      record: map['record'] ?? '',
      wave: map['wave'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordUpdate.fromJson(String source) =>
      RecordUpdate.fromMap(json.decode(source));

  @override
  String toString() => 'RecordUpdate(record: $record, wave: $wave)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RecordUpdate &&
        other.record == record &&
        other.wave == wave;
  }

  @override
  int get hashCode => record.hashCode ^ wave.hashCode;
}
