import 'package:flutter/material.dart';
import '../settings/tafseer_page.dart';

/// Legacy ChapterDownloadTafseerPage - redirected to modern unified TafseerPage
/// Preserves route '/quran/download-center-tafseer' with zero breakage
class ChapterDownloadTafseerPage extends StatelessWidget {
  const ChapterDownloadTafseerPage({Key? key}) : super(key: key);
  static const routeName = '/quran/download-center-tafseer';

  @override
  Widget build(BuildContext context) {
    return const TafseerPage();
  }
}
