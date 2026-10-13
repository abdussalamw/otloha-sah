import 'dart:io';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:otloha_sah_flutter/modules/quran_hafs/data/quran_hafs_metadata.dart';
import 'package:otloha_sah_flutter/data_source/remote/quranenc_editions_data.dart';

class TafseerEdition {
  final String key;
  final String name;
  final String author;
  final String language;
  final String languageName;
  final double estimatedSizeMb;
  final String? databaseUrl;

  const TafseerEdition({
    required this.key,
    required this.name,
    required this.author,
    required this.language,
    this.languageName = '',
    required this.estimatedSizeMb,
    this.databaseUrl,
  });

  factory TafseerEdition.fromJson(Map<String, dynamic> json) {
    final lang = json['language_iso_code'] ?? json['language'] ?? 'en';
    final langName = QuranEncEditionsData.languageNames[lang] ?? lang;
    return TafseerEdition(
      key: json['key'] ?? '',
      name: json['title'] ?? json['name'] ?? '',
      author: json['description'] ?? json['author'] ?? '',
      language: lang,
      languageName: langName,
      estimatedSizeMb: 2.5,
      databaseUrl: json['database_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'key': key,
    'title': name,
    'description': author,
    'language_iso_code': language,
    'languageName': languageName,
    'database_url': databaseUrl,
  };
}

typedef QuranEncEdition = TafseerEdition;

class QuranEncService {
  QuranEncService._();
  static final QuranEncService instance = QuranEncService._();

  static List<TafseerEdition> _dynamicTranslations = QuranEncEditionsData.defaultTranslationEditions;

  static List<TafseerEdition> get tafseerEditions => QuranEncEditionsData.defaultTafseerEditions;

  static List<TafseerEdition> get translationEditions => _dynamicTranslations;

  static List<TafseerEdition> get availableEditions => [
    ...tafseerEditions,
    ...translationEditions,
  ];

  static const String baseUrl = 'https://quranenc.com/api/v1';
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = '${dir.path}/quranenc_tafseer_cache.db';

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS quranenc_tafseer (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            translation_key TEXT,
            sura INTEGER,
            aya INTEGER,
            text TEXT,
            footnotes TEXT,
            UNIQUE(translation_key, sura, aya)
          )
        ''');
        await db.execute('''
          CREATE INDEX IF NOT EXISTS idx_quranenc_key_sura_aya 
          ON quranenc_tafseer(translation_key, sura, aya)
        ''');
        await db.execute('''
          CREATE TABLE IF NOT EXISTS quranenc_downloads (
            translation_key TEXT PRIMARY KEY,
            downloaded_suras INTEGER,
            total_suras INTEGER,
            bytes_downloaded INTEGER,
            is_complete INTEGER,
            last_updated TEXT
          )
        ''');
      },
    );
  }

  /// جلب تفسير آية واحدة محددة (مع كاش محلي فوري)
  Future<String?> getAyaTafseer({
    required String editionKey,
    required int sura,
    required int aya,
  }) async {
    try {
      final db = await database;
      // 1. البحث في قاعدة البيانات المحلية أولاً (Offline-First)
      final localRows = await db.query(
        'quranenc_tafseer',
        columns: ['text', 'footnotes'],
        where: 'translation_key = ? AND sura = ? AND aya = ?',
        whereArgs: [editionKey, sura, aya],
        limit: 1,
      );

      if (localRows.isNotEmpty) {
        return localRows.first['text'] as String?;
      }

      // 2. إذا لم يكن متوفراً محلياً، الجلب من QuranEnc API
      final url = '$baseUrl/translation/aya/$editionKey/$sura/$aya';
      final response = await _dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final result = data['result'];
        if (result != null) {
          final text = result['translation'] as String?;
          final footnotes = result['footnotes'] as String?;

          if (text != null && text.isNotEmpty) {
            // حفظه في الكاش المحلي للأبد
            await db.insert(
              'quranenc_tafseer',
              {
                'translation_key': editionKey,
                'sura': sura,
                'aya': aya,
                'text': text,
                'footnotes': footnotes ?? '',
              },
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            return text;
          }
        }
      }
    } catch (e) {
      // فشل الاتصال، لا ترمي خطأ ليعود التطبيق للبديل المحلي القديم بأمان
    }
    return null;
  }

  /// التحقق مما إذا كان التفسير منزلاً بالكامل محلياً
  Future<bool> isEditionDownloaded(String editionKey) async {
    try {
      final db = await database;
      final rows = await db.query(
        'quranenc_downloads',
        where: 'translation_key = ? AND is_complete = 1',
        whereArgs: [editionKey],
      );
      return rows.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// جلب حالة التنزيل الحالي
  Future<Map<String, dynamic>> getDownloadStatus(String editionKey) async {
    try {
      final db = await database;
      final rows = await db.query(
        'quranenc_downloads',
        where: 'translation_key = ?',
        whereArgs: [editionKey],
      );
      if (rows.isNotEmpty) {
        final row = rows.first;
        final isComplete = (row['is_complete'] as int?) == 1;
        final downloadedSuras = (row['downloaded_suras'] as int?) ?? 0;
        final bytes = (row['bytes_downloaded'] as int?) ?? 0;
        return {
          'isComplete': isComplete,
          'downloadedSuras': downloadedSuras,
          'totalSuras': 114,
          'progress': downloadedSuras / 114.0,
          'downloadedMb': bytes / (1024 * 1024),
        };
      }
    } catch (_) {}
    return {
      'isComplete': false,
      'downloadedSuras': 0,
      'totalSuras': 114,
      'progress': 0.0,
      'downloadedMb': 0.0,
    };
  }

  bool _isDownloading = false;
  bool _cancelRequested = false;

  void cancelDownload() {
    _cancelRequested = true;
  }

  /// جلب وتحديث قائمة الترجمات من خوادم QuranEnc ديناميكياً مع الحفاظ على البيانات الافتراضية
  Future<List<TafseerEdition>> fetchRemoteTranslationsList({bool forceRefresh = false}) async {
    try {
      final url = '$baseUrl/translations/list/?localization=ar';
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data != null) {
        final List? rawList = response.data['translations'];
        if (rawList != null && rawList.isNotEmpty) {
          final List<TafseerEdition> list = [];
          for (var item in rawList) {
            try {
              list.add(TafseerEdition.fromJson(item));
            } catch (_) {}
          }
          if (list.isNotEmpty) {
            _dynamicTranslations = list;
            return list;
          }
        }
      }
    } catch (_) {
      // استخدام القائمة المحلية كبديل آمن
    }
    return _dynamicTranslations;
  }

  /// تنزيل التفسير كاملاً لجميع سور القرآن (114 سورة) مع تتبع النسبة والحجم المنقول
  Future<void> downloadFullQuran({
    required String editionKey,
    required void Function(double progress, double downloadedMb, double totalEstimatedMb, String currentSuraName) onProgress,
    required void Function() onComplete,
    required void Function(String error) onError,
  }) async {
    if (_isDownloading) return;
    _isDownloading = true;
    _cancelRequested = false;

    final edition = availableEditions.firstWhere(
      (e) => e.key == editionKey,
      orElse: () => availableEditions.first,
    );

    // 1. محاولة التنزيل السريع المباشر عبر قاعدة بيانات SQLite المضغوطة (Fast 1-Click SQLite)
    if (edition.databaseUrl != null && edition.databaseUrl!.isNotEmpty) {
      final success = await _downloadViaSqliteZip(
        edition: edition,
        onProgress: onProgress,
      );
      if (success) {
        _isDownloading = false;
        onComplete();
        return;
      }
    }

    // 2. إذا لم يكن متوفراً كـ ZIP أو فشل، التنزيل عبر الـ API لكل سورة (Fallback مضمون 100%)
    int totalBytes = 0;
    final db = await database;

    try {
      for (int sura = 1; sura <= 114; sura++) {
        if (_cancelRequested) {
          _isDownloading = false;
          onError('تم إلغاء التنزيل');
          return;
        }

        final suraName = QuranHafsMetadata.getSuraName(sura);
        final url = '$baseUrl/translation/sura/$editionKey/$sura';
        final response = await _dio.get(url);

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data;
          final List? result = data['result'];

          if (result != null) {
            final batch = db.batch();
            for (var item in result) {
              final ayaNum = int.tryParse('${item['aya']}') ?? 1;
              final text = item['translation'] as String? ?? '';
              final footnotes = item['footnotes'] as String? ?? '';
              totalBytes += text.length * 2; // تقدير تقريبي للبايتات

              batch.insert(
                'quranenc_tafseer',
                {
                  'translation_key': editionKey,
                  'sura': sura,
                  'aya': ayaNum,
                  'text': text,
                  'footnotes': footnotes,
                },
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
            await batch.commit(noResult: true);
          }
        }

        final progress = sura / 114.0;
        final downloadedMb = (progress * edition.estimatedSizeMb);
        onProgress(progress, downloadedMb, edition.estimatedSizeMb, suraName);

        // حفظ التقدم في جدول التنزيلات
        await db.insert(
          'quranenc_downloads',
          {
            'translation_key': editionKey,
            'downloaded_suras': sura,
            'total_suras': 114,
            'bytes_downloaded': totalBytes,
            'is_complete': sura == 114 ? 1 : 0,
            'last_updated': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      _isDownloading = false;
      onComplete();
    } catch (e) {
      _isDownloading = false;
      onError(e.toString());
    }
  }

  /// التنزيل السريع المباشر عبر ملف SQLite ZIP وفك ضغطه ونسخ الآيات محلياً
  Future<bool> _downloadViaSqliteZip({
    required TafseerEdition edition,
    required void Function(double progress, double downloadedMb, double totalEstimatedMb, String currentSuraName) onProgress,
  }) async {
    try {
      final dbUrl = edition.databaseUrl!;
      final tempDir = await getTemporaryDirectory();
      final tempSqlitePath = '${tempDir.path}/temp_${edition.key}.sqlite';

      onProgress(0.05, 0.1, edition.estimatedSizeMb, 'بدء تنزيل حزمة التفسير المضغوطة...');

      // 1. تنزيل ملف ZIP
      final response = await _dio.get<List<int>>(
        dbUrl,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final p = 0.05 + (received / total) * 0.45; // 5% إلى 50%
            final mb = received / (1024 * 1024);
            final totalMb = total / (1024 * 1024);
            onProgress(p, mb, totalMb > 0 ? totalMb : edition.estimatedSizeMb, 'جاري تنزيل قاعدة البيانات...');
          }
        },
      );

      if (_cancelRequested) return false;
      if (response.data == null || response.data!.isEmpty) return false;

      onProgress(0.55, edition.estimatedSizeMb * 0.55, edition.estimatedSizeMb, 'فك الضغط وتجهيز الآيات...');

      // 2. فك الضغط واستخراج ملف sqlite
      final archive = ZipDecoder().decodeBytes(response.data!);
      ArchiveFile? sqliteArchiveFile;
      for (final f in archive.files) {
        if (f.isFile && f.name.endsWith('.sqlite')) {
          sqliteArchiveFile = f;
          break;
        }
      }
      if (sqliteArchiveFile == null && archive.files.isNotEmpty) {
        for (final f in archive.files) {
          if (f.isFile) {
            sqliteArchiveFile = f;
            break;
          }
        }
      }
      if (sqliteArchiveFile == null) return false;

      final sqliteBytes = sqliteArchiveFile.content as List<int>;
      final sqliteFile = File(tempSqlitePath);
      await sqliteFile.writeAsBytes(sqliteBytes);

      if (_cancelRequested) {
        try { await sqliteFile.delete(); } catch (_) {}
        return false;
      }

      onProgress(0.70, edition.estimatedSizeMb * 0.70, edition.estimatedSizeMb, 'تثبيت التفسير محلياً...');

      // 3. فتح قاعدة البيانات المؤقتة ونقل الآيات إلى جدول quranenc_tafseer
      final tempDb = await openDatabase(tempSqlitePath, readOnly: true);
      final rows = await tempDb.rawQuery('SELECT sura, aya, translation, footnotes FROM translations');

      final db = await database;
      const chunkSize = 500;
      for (int i = 0; i < rows.length; i += chunkSize) {
        if (_cancelRequested) {
          await tempDb.close();
          try { await sqliteFile.delete(); } catch (_) {}
          return false;
        }

        final end = (i + chunkSize < rows.length) ? i + chunkSize : rows.length;
        final chunk = rows.sublist(i, end);
        final batch = db.batch();
        for (var row in chunk) {
          final suraNum = (row['sura'] as num?)?.toInt() ?? 1;
          final ayaNum = (row['aya'] as num?)?.toInt() ?? 1;
          final text = row['translation'] as String? ?? '';
          final footnotes = row['footnotes'] as String? ?? '';
          batch.insert(
            'quranenc_tafseer',
            {
              'translation_key': edition.key,
              'sura': suraNum,
              'aya': ayaNum,
              'text': text,
              'footnotes': footnotes,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        await batch.commit(noResult: true);

        final p = 0.70 + ((end / rows.length) * 0.28);
        onProgress(p, edition.estimatedSizeMb * p, edition.estimatedSizeMb, 'حفظ الآيات ($end/${rows.length})');
      }

      await tempDb.close();
      try { await sqliteFile.delete(); } catch (_) {}

      // 4. حفظ حالة الاكتمال
      await db.insert(
        'quranenc_downloads',
        {
          'translation_key': edition.key,
          'downloaded_suras': 114,
          'total_suras': 114,
          'bytes_downloaded': response.data!.length,
          'is_complete': 1,
          'last_updated': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return true;
    } catch (_) {
      return false; // العودة التلقائية للبديل الآمن في حال أي استثناء
    }
  }

  /// حذف تفسير منزل محلياً لتحرير المساحة
  Future<void> deleteEdition(String editionKey) async {
    try {
      final db = await database;
      await db.delete(
        'quranenc_tafseer',
        where: 'translation_key = ?',
        whereArgs: [editionKey],
      );
      await db.delete(
        'quranenc_downloads',
        where: 'translation_key = ?',
        whereArgs: [editionKey],
      );
    } catch (_) {}
  }
}
