import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class HafsGlyph {
  final int id;
  final int page;
  final int line;
  final int sura;
  final int ayah;
  final int? wordId;
  final int type;
  final String code;

  HafsGlyph.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        page = map['page'],
        line = map['line'],
        sura = map['sura'],
        ayah = map['ayah'],
        wordId = map['word_id'],
        type = map['type'],
        code = map['code'];
}

class HafsLineAlignment {
  final int page;
  final int line;
  final int centered;
  final String type; 

  HafsLineAlignment.fromMap(Map<String, dynamic> map)
      : page = map['page'],
        line = map['line'],
        centered = map['centered'],
        type = map['type'];
}

class HafsTafseer {
  final int id;
  final int suraNo;
  final int ayaNo;
  final String ayaText;
  final String ayaTafseer;

  HafsTafseer.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        suraNo = map['sura_no'],
        ayaNo = map['aya_no'],
        ayaText = map['aya_text'],
        ayaTafseer = map['aya_tafseer'];
}

class QuranHafsRepository {
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) return;
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/quran_hafs_data.db';
    _db = await openDatabase(dbPath);
  }

  static Future<List<HafsGlyph>> getPageGlyphs(int pageNumber) async {
    await init();
    final result = await _db!.query('glyphs', where: 'page = ?', whereArgs: [pageNumber]);
    return result.map((e) => HafsGlyph.fromMap(e)).toList();
  }

  static Future<List<HafsLineAlignment>> getPageAlignments(int pageNumber) async {
    await init();
    final result = await _db!.query('lines', where: 'page = ?', whereArgs: [pageNumber]);
    return result.map((e) => HafsLineAlignment.fromMap(e)).toList();
  }

  static Future<HafsTafseer?> getTafseer(int sura, int ayah) async {
    await init();
    final result = await _db!.query('tafseer', where: 'sura_no = ? AND aya_no = ?', whereArgs: [sura, ayah]);
    if (result.isNotEmpty) {
      return HafsTafseer.fromMap(result.first);
    }
    return null;
  }
}
