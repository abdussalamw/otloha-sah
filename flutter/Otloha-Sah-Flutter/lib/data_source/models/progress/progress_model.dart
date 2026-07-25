import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProgressModel {
  final Map<String, List<int>> pending;
  final Map<String, List<int>> accepted;
  final Map<String, List<int>> rejected;

  ProgressModel({
    required this.pending,
    required this.accepted,
    required this.rejected,
  });

  ProgressModel copyWith({
    Map<String, List<int>>? pending,
    Map<String, List<int>>? accepted,
    Map<String, List<int>>? rejected,
  }) {
    return ProgressModel(
      pending: pending ?? this.pending,
      accepted: accepted ?? this.accepted,
      rejected: rejected ?? this.rejected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pending': pending,
      'accepted': accepted,
      'rejected': rejected,
    };
  }

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    map['pending'] = Map<String, List<dynamic>>.from(map['pending'])
        .map((key, value) => MapEntry(key, List<int>.from(value)))
        .cast<String, List<int>>();
    map['accepted'] = Map<String, List<dynamic>>.from(map['accepted'])
        .map((key, value) => MapEntry(key, List<int>.from(value)))
        .cast<String, List<int>>();
    map['rejected'] = Map<String, List<dynamic>>.from(map['rejected'])
        .map((key, value) => MapEntry(key, List<int>.from(value)))
        .cast<String, List<int>>();

    return ProgressModel(
      pending: map['pending'],
      accepted: map['accepted'],
      rejected: map['rejected'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProgressModel.fromJson(String source) =>
      ProgressModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProgressModel(pending: $pending, accepted: $accepted, rejected: $rejected)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProgressModel &&
        mapEquals(other.pending, pending) &&
        mapEquals(other.accepted, accepted) &&
        mapEquals(other.rejected, rejected);
  }

  @override
  int get hashCode => pending.hashCode ^ accepted.hashCode ^ rejected.hashCode;
}
