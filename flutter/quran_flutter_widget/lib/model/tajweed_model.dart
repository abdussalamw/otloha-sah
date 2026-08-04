import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/base_model.dart';

@Entity(
  tableName: 'tajweed',
)
class TajweedBook extends BaseModel {
  @primaryKey
  int? id;
  String? name;
  String? author;
  int? narration;

  TajweedBook({this.id, this.name, this.author, this.narration});

  factory TajweedBook.fromJson(Map<String, dynamic> json) {
    String? nameStr = json['name'] is Map
        ? ((json['name'] as Map)['ar']?.toString() ?? (json['name'] as Map)['en']?.toString() ?? (json['name'] as Map).values.first?.toString())
        : json['name']?.toString();

    String? authorStr = json['author'] is Map
        ? ((json['author'] as Map)['ar']?.toString() ?? (json['author'] as Map).values.first?.toString())
        : json['author']?.toString();

    return TajweedBook(
      id: json['id']?.toInt(),
      name: nameStr,
      author: authorStr,
      narration: json['narration']?.toInt(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['author'] = author;
    data['narration'] = narration;
    return data;
  }
}
