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
    return Translation(
      id: json['id'],
      name: json['name'],
      author: json['author'],
      language: json['language'],
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
