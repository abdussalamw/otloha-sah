import 'package:flutter/material.dart';
import '../settings/quran_translation_language_page.dart';

/// Legacy ChapterDownloadTargamaPage - redirected to modern unified QuranTranslationLanguagePage
/// Preserves route '/quran/download-center-targama' with zero breakage
class ChapterDownloadTargamaPage extends StatelessWidget {
  const ChapterDownloadTargamaPage({Key? key}) : super(key: key);
  static const routeName = '/quran/download-center-targama';

  @override
  Widget build(BuildContext context) {
    return const QuranTranslationLanguagePage();
  }
}
