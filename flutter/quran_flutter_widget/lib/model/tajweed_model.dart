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
    return TajweedBook(
      id: json['id'],
      name: json['name'],
      author: json['author'],
      narration: json['narration'],
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
