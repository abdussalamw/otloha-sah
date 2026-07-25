import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class ReplyRequest {
  int? recitationId;
  int? messageId;
  int? parentId;
  String? comment;
  String? record;
  String? wave;
  String? errorType;
  String? text;
  int? positionFrom;
  int? positionTo;
  ReplyRequest({
    this.recitationId,
    this.messageId,
    this.parentId,
    this.comment,
    this.record,
    this.wave,
    this.errorType,
    this.text,
    this.positionFrom,
    this.positionTo,
  });

  ReplyRequest copyWith({
    int? recitationId,
    int? messageId,
    int? parentId,
    String? comment,
    String? record,
    String? wave,
    String? errorType,
    String? text,
    int? positionFrom,
    int? positionTo,
  }) {
    return ReplyRequest(
      recitationId: recitationId ?? this.recitationId,
      messageId: messageId ?? this.messageId,
      parentId: parentId ?? this.parentId,
      comment: comment ?? this.comment,
      record: record ?? this.record,
      wave: wave ?? this.wave,
      errorType: errorType ?? this.errorType,
      text: text ?? this.text,
      positionFrom: positionFrom ?? this.positionFrom,
      positionTo: positionTo ?? this.positionTo,
    );
  }

  Future<Map<String, dynamic>> toMap() async {
    File? file;
    File? waveFile;

    MultipartFile? recordFrom;
    MultipartFile? waveFrom;

    try {
      if (record != null || wave != null) {
        waveFile = File(wave ?? '');
        file = File(record ?? '');
        recordFrom = await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last);

        waveFrom = await MultipartFile.fromFile(waveFile.path,
            filename: waveFile.path.split('/').last);
        return {
          'parent': parentId,
          'comment': comment,
          'record': recordFrom,
          'wave': waveFrom,
          'error_type': errorType,
          'text': text,
          'position_from': positionFrom,
          'position_to': positionTo,
        };
      } else {
        //throw UnimplementedError();
      }
    } catch (e) {
      print(e);
    }
    return {
      'parent': parentId,
      'comment': comment,
      'error_type': errorType,
      'text': text,
      'position_from': positionFrom,
      'position_to': positionTo,
    };
  }

  factory ReplyRequest.fromMap(Map<String, dynamic> map) {
    return ReplyRequest(
      recitationId: map['recitationId']?.toInt(),
      messageId: map['messageId']?.toInt(),
      parentId: map['parentId']?.toInt(),
      comment: map['comment'],
      record: map['record'],
      wave: map['wave'],
      errorType: map['errorType'],
      text: map['text'],
      positionFrom: map['positionFrom']?.toInt(),
      positionTo: map['positionTo']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReplyRequest.fromJson(String source) =>
      ReplyRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReplyRequest(recitationId: $recitationId, messageId: $messageId, parentId: $parentId, comment: $comment, record: $record, wave: $wave, errorType: $errorType, text: $text, positionFrom: $positionFrom, positionTo: $positionTo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReplyRequest &&
        other.recitationId == recitationId &&
        other.messageId == messageId &&
        other.parentId == parentId &&
        other.comment == comment &&
        other.record == record &&
        other.wave == wave &&
        other.errorType == errorType &&
        other.text == text &&
        other.positionFrom == positionFrom &&
        other.positionTo == positionTo;
  }

  @override
  int get hashCode {
    return recitationId.hashCode ^
        messageId.hashCode ^
        parentId.hashCode ^
        comment.hashCode ^
        record.hashCode ^
        wave.hashCode ^
        errorType.hashCode ^
        text.hashCode ^
        positionFrom.hashCode ^
        positionTo.hashCode;
  }
}
