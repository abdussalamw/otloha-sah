class Translations {
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
    if (translations.isEmpty) {
      return null;
    } else if (translations['ar'] != null) {
      return translations['ar'] as String?;
    } else if (translations.values.isNotEmpty) {
      return translations.values.first?.toString();
    } else {
      return null;
    }
  }

  final Map<String, dynamic> translations;
}

typedef Translatable = Translations;

extension QuranWidgetStringTranslateExtension on String {
  String translate() => this;
}
