import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:otloha_sah_flutter/modules/quran_hafs/data/quran_hafs_metadata.dart';

class TafseerEdition {
  final String key;
  final String name;
  final String author;
  final String language;
  final double estimatedSizeMb;

  const TafseerEdition({
    required this.key,
    required this.name,
    required this.author,
    required this.language,
    required this.estimatedSizeMb,
  });
}

class QuranEncService {
  QuranEncService._();
  static final QuranEncService instance = QuranEncService._();

  static const List<TafseerEdition> availableEditions = [
    TafseerEdition(
      key: 'arabic_mokhtasar',
      name: 'المختصر في التفسير',
      author: 'مركز تفسير للدراسات القرآنية',
      language: 'ar',
      estimatedSizeMb: 4.8,
    ),
    TafseerEdition(
      key: 'arabic_moyassar',
      name: 'التفسير الميسر',
      author: 'مجمع الملك فهد لطباعة المصحف الشريف',
      language: 'ar',
      estimatedSizeMb: 4.2,
    ),
    TafseerEdition(
      key: 'arabic_saadi',
      name: 'تفسير السعدي',
      author: 'الشيخ عبد الرحمن السعدي',
      language: 'ar',
      estimatedSizeMb: 5.5,
    ),
    TafseerEdition(
      key: 'english_saheeh',
      name: 'Saheeh International',
      author: 'Saheeh International (English Translation)',
      language: 'en',
      estimatedSizeMb: 3.9,
    ),
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
