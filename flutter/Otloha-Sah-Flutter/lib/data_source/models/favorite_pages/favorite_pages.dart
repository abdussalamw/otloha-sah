import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:otloha_sah_flutter/data_source/local/database/database/database.dart';

@UseRowClass(FavoritePage)
class FavoritePages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idPage => integer()();
  IntColumn get idBook => integer()();
  IntColumn get pageNumber => integer()();
  IntColumn get userId => integer()();
  TextColumn get textVerse => text().withLength(min: 0, max: 255)();
}

class FavoritePage implements Insertable<FavoritePage> {
  int id;
  int idPage;
  int idBook;
  int pageNumber;
  int userId;
  String textVerse;

  FavoritePage({
    required this.id,
    required this.idPage,
    required this.idBook,
    required this.pageNumber,
    required this.userId,
    required this.textVerse,
  });

  FavoritePage copyWith({
    int? id,
    int? idPage,
    int? idBook,
    int? pageNumber,
    int? userId,
    String? textVerse,
  }) {
    return FavoritePage(
      id: id ?? this.id,
      idPage: idPage ?? this.idPage,
      idBook: idBook ?? this.idBook,
      pageNumber: pageNumber ?? this.pageNumber,
      userId: userId ?? this.userId,
      textVerse: textVerse ?? this.textVerse,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'idPage': idPage,
      'idBook': idBook,
      'pageNumber': pageNumber,
      'userId': userId,
      'textVerse': textVerse,
    };
  }

  factory FavoritePage.fromMap(Map<String, dynamic> map) {
    return FavoritePage(
      id: map['id'] as int,
      idPage: map['idPage'] as int,
      idBook: map['idBook'] as int,
      pageNumber: map['pageNumber'] as int,
      userId: map['userId'] as int,
      textVerse: map['textVerse'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoritePage.fromJson(String source) =>
      FavoritePage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FavoritePage(id: $id, idPage: $idPage, idBook: $idBook, pageNumber: $pageNumber, userId: $userId, textVerse: $textVerse)';
  }

  @override
  bool operator ==(covariant FavoritePage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.idPage == idPage &&
        other.idBook == idBook &&
        other.pageNumber == pageNumber &&
        other.userId == userId &&
        other.textVerse == textVerse;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        idPage.hashCode ^
        idBook.hashCode ^
        pageNumber.hashCode ^
        userId.hashCode ^
        textVerse.hashCode;
  }

  @override
  Map<String, Expression<Object>> toColumns(bool nullToAbsent) {
    return FavoritePagesCompanion(
      id: Value(id),
      idPage: Value(idPage),
      idBook: Value(idBook),
      pageNumber: Value(pageNumber),
      userId: Value(userId),
      textVerse: Value(textVerse),
    ).toColumns(nullToAbsent);
  }
}
