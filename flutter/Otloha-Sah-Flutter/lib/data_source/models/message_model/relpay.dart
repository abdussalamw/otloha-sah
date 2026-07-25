import 'dart:convert';

import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../record/record.dart';

Reply replyFromJson(String str) => Reply.fromJson(json.decode(str));
String replyToJson(Reply data) => json.encode(data.toJson());

class Reply {
  Reply({
    this.id,
    this.comment,
    this.errorType,
    this.positionFrom,
    this.positionTo,
    this.owner,
    this.parent,
    this.children,
    this.records,
  });

  Reply.fromJson(dynamic json) {
    id = json['id'];
    comment = json['comment'];
    text = json['text'];
    errorType = json['error_type'];
    positionFrom = json['position_from'];
    positionTo = json['position_to'];
    owner = json['owner'] != null ? User.fromJson(json['owner']) : null;
    parent = json['parent'];
    if (json['children'] != null) {
      children = [];
      json['children'].forEach((v) {
        children?.add(Reply.fromJson(v));
      });
    }
    if (json['records'] != null) {
      records = [];
      json['records'].forEach((v) {
        records?.add(Record.fromJson(v));
      });
    }
  }
  int? id;
  String? comment;
  String? text;
  String? errorType;
  int? positionFrom;
  int? positionTo;
  User? owner;
  int? parent;
  List<Reply>? children;
  List<Record>? records;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['comment'] = comment;
    map['text'] = text;
    map['records'] = records;
    map['error_type'] = errorType;
    map['position_from'] = positionFrom;
    map['position_to'] = positionTo;
    if (owner != null) {
      map['owner'] = owner?.toJson();
    }
    map['parent'] = parent;
    if (children != null) {
      map['children'] = children?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 43
/// username : "Shadyd"
/// first_name : ""
/// last_name : ""
/// level : "Beginner"
/// is_a_teacher : false
/// narration_id : null
/// image : "/media/default/images/profile.png"
