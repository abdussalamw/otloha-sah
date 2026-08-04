import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

class Translations extends Equatable {
  const Translations({
    required this.translations,
  });

  factory Translations.fromJson(Map<String, dynamic> json) {
    return Translations(
      translations: json,
    );
  }

  Map<String, dynamic> toJson() => translations;

  String? translate() {
    final currentLocale = Get.locale!.languageCode;
    if (translations.isEmpty) {
      return null;
    } else if (translations[currentLocale] != null) {
      return translations[currentLocale] as String?;
    } else if (translations['ar'] != null) {
      return translations['ar'] as String?;
    } else {
      return null;
    }
  }

  final Map<String, dynamic> translations;

  @override
  List<Object> get props => [translations];
}

typedef Translatable = Translations;

extension StringTranslateExtension on String {
  String translate() => this;
}
