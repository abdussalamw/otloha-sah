import 'dart:convert';

import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/model/translatable.dart';

import '../../../core/utils/constant/utils.dart';
import '../../../core/utils/res/icons_app.dart';
import 'language.dart';
import 'setting.dart';
import '../../../modules/settings/presentation/pages/downloads/chapter_download_page.dart';
import '../../../modules/settings/presentation/pages/downloads/chapter_download_tafseer_page.dart';
import '../../../modules/settings/presentation/pages/downloads/chapter_download_tajweed_page.dart';
import '../../../modules/settings/presentation/pages/downloads/chapter_download_targama_page.dart';
import '../../../modules/settings/presentation/pages/settings/languages_page.dart';
import '../../../modules/settings/presentation/pages/settings/narration_page.dart';
import '../../../modules/settings/presentation/pages/settings/quran_translation_language_page.dart';
import '../../../modules/settings/presentation/pages/settings/recitation_page.dart';
import '../../../modules/settings/presentation/pages/settings/tafseer_page.dart';
import '../../../modules/settings/presentation/pages/settings/tajweed_page.dart';

class SettingsMenusData {
  get settings => _settings;

  static String safeTranslate(String? rawJson) {
    if (rawJson == null || rawJson.isEmpty) return '';
    try {
      final decoded = json.decode(rawJson);
      if (decoded is Map<String, dynamic>) {
        return Translatable.fromJson(decoded).translate() ?? '';
      }
      return rawJson;
    } catch (_) {
      return rawJson;
    }
  }

  static String getTajweedName() {
    return safeTranslate(QuranCacheRepository.selectedTajweedName);
  }

  final List<Settings> _settings = [
    Settings(
      name: translate('Narration'),
      image: AppIcons.languageIcon,
      actionTo: NarrationPage.routeName,
      subTitle: safeTranslate(QuranCacheRepository.narrationSelectedName),
    ),
    Settings(
      name: translate('Languages'),
      image: AppIcons.languageIcon,
      actionTo: LanguagesPage.routeName,
      subTitle: translate('english'),
    ),
  ];

  get downloadRecitations => _downloadRecitations;

  final List<Settings> _downloadRecitations = [
    Settings(
      name: translate('Recitations'),
      image: AppIcons.discussioncon,
      actionTo: RecitationPage.routeName,
      subTitle: safeTranslate(QuranCacheRepository.selectedRecitationName),
    ),
    Settings(
      name: translate('RecitationsDownloadCenter'),
      image: AppIcons.downloadIcon,
      actionTo: ChapterDownloadPage.routeName,
    ),
  ];

  get downloadTajweed => _downloadTajweed;

  final List<Settings> _downloadTajweed = [
    Settings(
      name: translate('Tajweed'),
      image: AppIcons.readingIcon,
      actionTo: TajweedPage.routeName,
      subTitle: getTajweedName(),
    ),
    Settings(
      name: translate('TajweedDownloadCenter'),
      image: AppIcons.downloadIcon,
      actionTo: ChapterDownloadTajweedPage.routeName,
    ),
  ];

  get downloadTafsir => _downloadTafsir;

  final List<Settings> _downloadTafsir = [
    Settings(
      name: translate('Tafsir'),
      image: AppIcons.readingIcon,
      actionTo: TafseerPage.routeName,
      subTitle: safeTranslate(QuranCacheRepository.tafsirSelectedName),
    ),
    Settings(
      name: translate('TafsirDownloadCenter'),
      image: AppIcons.downloadIcon,
      actionTo: ChapterDownloadTafseerPage.routeName,
    ),
  ];

  get downloadQTL => _downloadQTL;

  final List<Settings> _downloadQTL = [
    Settings(
      name: translate('QuranTranslationLanguage'),
      image: AppIcons.languageIcon,
      actionTo: QuranTranslationLanguagePage.routeName,
      subTitle: safeTranslate(QuranCacheRepository.quranTranslationSelectedName),
    ),
    Settings(
      name: translate('TranslationsDownloadCenter'),
      image: AppIcons.downloadIcon,
      actionTo: ChapterDownloadTargamaPage.routeName,
    ),
  ];

  final List<Language> lang = [
    Language(langName: 'English', langCode: 'en'),
    Language(langName: 'العربية', langCode: 'ar'),
  ];
}
