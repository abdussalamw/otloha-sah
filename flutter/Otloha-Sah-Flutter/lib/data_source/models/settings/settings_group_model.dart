import 'dart:convert';

import 'package:flutter/foundation.dart';

class SettingsGroupModel {
  final String key;
  final Map<String, String> label;
  final Map<String, String> description;
  final bool value;
  final String valueType;
  final String group;
  final String subGroup;

  SettingsGroupModel({
    required this.key,
    required this.label,
    required this.description,
    required this.value,
    required this.valueType,
    required this.group,
    required this.subGroup,
  });

  SettingsGroupModel copyWith({
    String? key,
    Map<String, String>? label,
    Map<String, String>? description,
    bool? value,
    String? valueType,
    String? group,
    String? subGroup,
  }) {
    return SettingsGroupModel(
      key: key ?? this.key,
      label: label ?? this.label,
      description: description ?? this.description,
      value: value ?? this.value,
      valueType: valueType ?? this.valueType,
      group: group ?? this.group,
      subGroup: subGroup ?? this.subGroup,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'label': label,
      'description': description,
      'value': value,
      'valueType': valueType,
      'group': group,
      'subGroup': subGroup,
    };
  }

  factory SettingsGroupModel.fromMap(Map<String, dynamic> map) {
    return SettingsGroupModel(
      key: map['key'] ?? '',
      label: Map<String, String>.from(map['label']),
      description: Map<String, String>.from(map['description']),
      value: map['value'] ?? false,
      valueType: map['value_type'] ?? '',
      group: map['group'] ?? '',
      subGroup: map['sub_group'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingsGroupModel.fromJson(String source) => SettingsGroupModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SettingsGroupModel(key: $key, label: $label, description: $description, value: $value, valueType: $valueType, group: $group, subGroup: $subGroup)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SettingsGroupModel &&
      other.key == key &&
      mapEquals(other.label, label) &&
      mapEquals(other.description, description) &&
      other.value == value &&
      other.valueType == valueType &&
      other.group == group &&
      other.subGroup == subGroup;
  }

  @override
  int get hashCode {
    return key.hashCode ^
      label.hashCode ^
      description.hashCode ^
      value.hashCode ^
      valueType.hashCode ^
      group.hashCode ^
      subGroup.hashCode;
  }
}
