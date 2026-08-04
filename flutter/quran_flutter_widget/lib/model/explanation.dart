import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/base_model.dart';

@Entity(
  tableName: 'explanation',
)
class Explanation extends BaseModel {
  @primaryKey
  int? id;
  String? name;
  int? narration;

  Explanation({this.id, this.name, this.narration});

  factory Explanation.fromJson(Map<String, dynamic> json) {
    String? nameStr = json['name'] is Map
        ? ((json['name'] as Map)['ar']?.toString() ?? (json['name'] as Map).values.first?.toString())
        : json['name']?.toString();

    return Explanation(
      id: json['id']?.toInt(),
      name: nameStr,
      narration: json['narration']?.toInt(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['narration'] = narration;
    return data;
  }
}
