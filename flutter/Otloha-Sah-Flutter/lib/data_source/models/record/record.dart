// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:drift/drift.dart';

class Record {
  final int id;
  final String uuid;
  final String? wave;
  final String duration;
  final bool isPrivate;
  final String filename;
  Record({
    required this.id,
    required this.uuid,
    this.wave,
    required this.duration,
    required this.isPrivate,
    required this.filename,
  });

  Record copyWith({
    int? id,
    String? uuid,
    String? wave,
    String? duration,
    bool? isPrivate,
    String? filename,
  }) {
    return Record(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      wave: wave ?? this.wave,
      duration: duration ?? this.duration,
      isPrivate: isPrivate ?? this.isPrivate,
      filename: filename ?? this.filename,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'wave': wave,
      'duration': duration,
      'is_private': isPrivate,
      'filename': filename,
    };
  }

  factory Record.fromMap(Map<String, dynamic> map) {
    return Record(
      id: map['id'] as int,
      uuid: map['uuid'] as String,
      wave: map['wave'] != null ? map['wave'] as String : null,
      duration: map['duration'] as String,
      isPrivate: map['private'] as bool,
      filename: map['filename'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Record.fromJson(String source) =>
      Record.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Record(id: $id, uuid: $uuid, wave: $wave, duration: $duration, isPrivate: $isPrivate, filename: $filename)';
  }

  @override
  bool operator ==(covariant Record other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.wave == wave &&
        other.duration == duration &&
        other.isPrivate == isPrivate &&
        other.filename == filename;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        wave.hashCode ^
        duration.hashCode ^
        isPrivate.hashCode ^
        filename.hashCode;
  }
}

class RecordConverter extends TypeConverter<Record, String> {
  const RecordConverter();

  @override
  Record fromSql(String fromDb) {
    return Record.fromJson(fromDb);
  }

  @override
  String toSql(Record value) {
    return value.toJson();
  }
}
