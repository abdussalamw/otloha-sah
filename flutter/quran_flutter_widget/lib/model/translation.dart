import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/base_model.dart';

@Entity(
  tableName: 'translation',
)
class Translation extends BaseModel {
  @primaryKey
  int? id;
  String? name;
  String? author;
  String? language;

  Translation({
    this.id,
    this.name,
    this.author,
    this.language,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    String? nameStr = json['name'] is Map
        ? ((json['name'] as Map)['ar']?.toString() ?? (json['name'] as Map)['en']?.toString() ?? (json['name'] as Map).values.first?.toString())
        : json['name']?.toString();

    String? authorStr = json['author'] is Map
        ? ((json['author'] as Map)['ar']?.toString() ?? (json['author'] as Map).values.first?.toString())
        : json['author']?.toString();

    return Translation(
      id: json['id']?.toInt(),
      name: nameStr,
      author: authorStr,
      language: json['language']?.toString(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['author'] = author;
    data['language'] = language;
    return data;
  }
}
