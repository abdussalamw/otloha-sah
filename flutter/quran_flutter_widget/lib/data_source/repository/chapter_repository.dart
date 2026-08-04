import 'package:quran_widget_flutter/data_source/local/local_data_source/chapter_local_data_source.dart.dart';
import 'package:quran_widget_flutter/data_source/remote/chapter_api.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/src/plugin_src/data/quran_service.dart';

class ChapterRepository {
  final ChapterLocalDataSource _chapterLocalDataSource =
      ChapterLocalDataSource();
  final ChapterApi _chapterApi = ChapterApi();

  Future<List<Chapter>?> fetchChaptersList({
    String? qurey,
    bool? fromIndex,
    int? bookId,
    int? narrationId,
    Function(int, int)? onDownloadProgress,
  }) async {
    List<Chapter>? chaptersList = (qurey != null && qurey.isNotEmpty)
        ? await _chapterLocalDataSource.searchInChapter(qurey: qurey)
        : await _chapterLocalDataSource.fetchChaptersList();

    if ((chaptersList != null && chaptersList.isNotEmpty)) {
      return chaptersList;
    } else {
      try {
        final MyResponse<Chapter> response = await _chapterApi.fetchChaptersList(
            onDownloadProgress: onDownloadProgress);
        if (response.code == Apis.codeSUCCESS && response.data is List<Chapter>) {
          chaptersList = response.data as List<Chapter>;
          _chapterLocalDataSource.saveChaptersList(chaptersList);
          return chaptersList;
        }
      } catch (e) {
        print('Chapter API error (404/Network): $e');
      }

      chaptersList = _generateDefaultChapters();
      if (chaptersList.isNotEmpty) {
        _chapterLocalDataSource.saveChaptersList(chaptersList);
      }
      return chaptersList;
    }
  }

  List<Chapter> _generateDefaultChapters() {
    List<Verse> verses = QuranService.instance.allVerses;
    if (verses.isEmpty) return [];

    Map<int, List<Verse>> chapterMap = {};
    for (var v in verses) {
      if (v.chapterNumber != null) {
        chapterMap.putIfAbsent(v.chapterNumber!, () => []).add(v);
      }
    }

    List<Chapter> list = [];
    chapterMap.forEach((chNum, vList) {
      vList.sort((a, b) => (a.pageNumber ?? 1).compareTo(b.pageNumber ?? 1));
      int pageFrom = vList.first.pageNumber ?? 1;
      int pageTo = vList.last.pageNumber ?? 604;
      String name = _surahNames[chNum] ?? 'سورة $chNum';

      list.add(Chapter(
        id: chNum,
        name: name,
        chapterNumber: chNum,
        origin: chNum == 1 || chNum == 9 ? 'مكية' : 'مدنية',
        pageFrom: pageFrom,
        pageTo: pageTo,
        versesSize: vList.length,
      ));
    });

    list.sort((a, b) => (a.chapterNumber ?? 0).compareTo(b.chapterNumber ?? 0));
    return list;
  }

  static const Map<int, String> _surahNames = {
    1: 'الفاتحة', 2: 'البقرة', 3: 'آل عمران', 4: 'النساء', 5: 'المائدة',
    6: 'الأنعام', 7: 'الأعراف', 8: 'الأنفال', 9: 'التوبة', 10: 'يونس',
    11: 'هود', 12: 'يوسف', 13: 'الرعد', 14: 'إبراهيم', 15: 'الحجر',
    16: 'النحل', 17: 'الإسراء', 18: 'الكهف', 19: 'مريم', 20: 'طه',
    21: 'الأنبياء', 22: 'الحج', 23: 'المؤمنون', 24: 'النور', 25: 'الفرقان',
    26: 'الشعراء', 27: 'النمل', 28: 'القصص', 29: 'العنكبوت', 30: 'الروم',
    31: 'لقمان', 32: 'السجدة', 33: 'الأحزاب', 34: 'سبأ', 35: 'فاطر',
    36: 'يس', 37: 'الصافات', 38: 'ص', 39: 'الزمر', 40: 'غافر',
    41: 'فصلت', 42: 'الشورى', 43: 'الزخرف', 44: 'الدخان', 45: 'الجاثية',
    46: 'الأحقاف', 47: 'محمد', 48: 'الفتح', 49: 'الحجرات', 50: 'ق',
    51: 'الذاريات', 52: 'الطور', 53: 'النجم', 54: 'القمر', 55: 'الرحمن',
    56: 'الواقعة', 57: 'الحديد', 58: 'المجادلة', 59: 'الحشر', 60: 'الممتحنة',
    61: 'الصف', 62: 'الجمعة', 63: 'المنافقون', 64: 'التغابن', 65: 'الطلاق',
    66: 'التحريم', 67: 'الملك', 68: 'القلم', 69: 'الحاقة', 70: 'المعارج',
    71: 'نوح', 72: 'الجن', 73: 'المزمل', 74: 'المدثر', 75: 'القيامة',
    76: 'الإنسان', 77: 'المرسلات', 78: 'النبأ', 79: 'النازعات', 80: 'عبس',
    81: 'التكوير', 82: 'الانفطار', 83: 'المطففين', 84: 'الانشقاق', 85: 'البروج',
    86: 'الطارق', 87: 'الأعلى', 88: 'الغاشية', 89: 'الفجر', 90: 'البلد',
    91: 'الشمس', 92: 'الليل', 93: 'الضحى', 94: 'الشرح', 95: 'التين',
    96: 'العلق', 97: 'القدر', 98: 'البينة', 99: 'الزلزلة', 100: 'العاديات',
    101: 'القارعة', 102: 'التكاثر', 103: 'العصر', 104: 'الهمزة', 105: 'الفيل',
    106: 'قريش', 107: 'الماعون', 108: 'الكوثر', 109: 'الكافرون', 110: 'النصر',
    111: 'المسد', 112: 'الإخلاص', 113: 'الفلق', 114: 'الناس'
  };

  Future<Chapter?> fetchChapterById(int chapterId, [int? narrationId]) async {
    Chapter? chapter =
        await _chapterLocalDataSource.fetchChapterById(chapterId);
    if (chapter != null) {
      return chapter;
    } else {
      try {
        final MyResponse<Chapter> response =
            await _chapterApi.fetchChapterById(chapterId);
        if (response.code == Apis.codeSUCCESS && response.data != null) {
          chapter = response.data as Chapter?;
          await _chapterLocalDataSource.insertChapter(chapter!);
          return chapter;
        }
      } catch (e) {
        print('Error fetching chapter by id: $e');
      }

      final list = _generateDefaultChapters();
      chapter = list.firstWhere(
        (element) => element.id == chapterId,
        orElse: () => list.first,
      );
      return chapter;
    }
  }
}
