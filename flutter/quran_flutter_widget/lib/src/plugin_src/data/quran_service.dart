import 'dart:convert';

import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';
import 'package:quran_widget_flutter/data_source/data_source.dart';
import 'package:quran_widget_flutter/model/verse.dart';

class QuranService {
  static final QuranService _ds = QuranService._internalInstance();

  QuranService._internalInstance();

  static QuranService get instance => _ds;

  factory QuranService() => instance;

  // final VersesLocalDataSource _versesLocalDataSource = VersesLocalDataSource();

  List<Verse>? _allVerses;

  List<Verse> get allVerses => _allVerses ?? [];

  Future<List<Verse>?> get allVersesAsync async =>
      _allVerses ?? await getVerses();

  Future<List<Verse>?> getVerses() async {
    print('reload data');
    try {
      // 1) Try in-memory cache first
      if (_allVerses != null && _allVerses!.isNotEmpty) {
        return _allVerses;
      }

      // 2) Try persisted cache (SharedPreferences) next
      String narrationName = QuranCacheRepository.narrationSelectedName;
      var cached = CacheHelper.getData(key: narrationName);
      if (cached != null) {
        String cachedStr = cached.toString();
        if (cachedStr.isNotEmpty) {
          List jsonVerses = json.decode(cachedStr);
          if (jsonVerses.isNotEmpty) {
            _allVerses = [];
            for (var element in jsonVerses) {
              _allVerses?.add(Verse.fromJson(element));
            }
            return _allVerses;
          }
        }
      }

      // 3) Finally fall back to the database / bundled assets
      _allVerses = await DataSource.instance.fetchVersesList();
    } catch (e) {
      print('Error loading verses in getVerses: $e');
      // Last safety net: never leave _allVerses as null -> use empty list
      _allVerses = _allVerses ?? [];
    }
    print('reload data done ');
    return _allVerses;
  }
}
