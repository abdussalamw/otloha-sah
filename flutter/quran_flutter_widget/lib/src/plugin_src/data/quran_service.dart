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
    _allVerses = [];

    String _narrationName = QuranCacheRepository.narrationSelectedName;

    print(
        'narrationName: $_narrationName verse ${CacheHelper.getData(key: _narrationName)} ');

    List jsonVerses =
        json.decode(CacheHelper.getData(key: _narrationName) ?? '[]');

    if (jsonVerses.isNotEmpty) {
      for (var element in jsonVerses) {
        _allVerses?.add(Verse.fromJson(element));
      }
    } else {
      _allVerses = await DataSource.instance.fetchVersesList();
    }
    print('reload data done ');
    return _allVerses;
  }
}
