import 'package:quran_widget_flutter/data_source/local/local_data_source/narration_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/verses_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/word_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/remote/narration_api.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/narration.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:quran_widget_flutter/model/word.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class NarrationRepository {
  final NarrationLocalDataSource _narrationLocalDataSource =
      NarrationLocalDataSource();
  final NarrationApi _narrationApi = NarrationApi();

  final VersesLocalDataSource _versesLocalDataSource = VersesLocalDataSource();
  final WordLocalDataSource _wordLocalDataSource = WordLocalDataSource();

  Future<List<Narration>?> fetchNarrationsList({
    String? qurey,
    Function(int, int)? onDownloadProgress,
  }) async {
    List<Narration>? narrationsList = (qurey != null && qurey.isNotEmpty)
        ? await _narrationLocalDataSource.searchInNarration(qurey)
        : await _narrationLocalDataSource.fetchNarrationsList();

    if ((narrationsList != null && narrationsList.isNotEmpty)) {
      return narrationsList;
    } else {
      final MyResponse<Narration> response =
          await _narrationApi.fetchNarrationsList(
        qurey: qurey,
        onDownloadProgress: onDownloadProgress,
      );
      if (response.code == Apis.codeSUCCESS) {
        narrationsList = response.data as List<Narration>;
        _narrationLocalDataSource.saveNarrationsList(narrationsList);
      }
      return narrationsList;
    }
  }

  Future<Narration?> fetchNarrationById(int narrationId) async {
    Narration? narration =
        await _narrationLocalDataSource.fetchNarrationById(narrationId);
    if (narration != null) {
      return narration;
    } else {
      final MyResponse<Narration> response =
          await _narrationApi.fetchNarrationById(narrationId);
      if (response.code == Apis.codeSUCCESS) {
        narration = response.data as Narration?;
        await _narrationLocalDataSource.insertNarrations(narration!);
      }
      return narration;
    }
  }

  Future<List<Verse>> fetchVersesList(
      {Function(int, int)? onDownloadProgress,
      String? qurey,
      int? chapterNumber}) async {
    List<Verse> verses = await VersesLocalDataSource().findAllVerses();
    if (verses.isEmpty) {
      MyResponse<Verse> response = await _narrationApi.fetchWordsList(
        chapterNumber: chapterNumber,
        qurey: qurey,
        onDownloadProgress: onDownloadProgress,
      );
      if (response.code == Apis.codeSUCCESS) {
        verses = response.data as List<Verse>;

        await _versesLocalDataSource.insertVersesList(verses);
        List<Word> words = verses
            .map((element) => element.words)
            .toList()
            .expand((element) => element!)
            .toList();

        await _wordLocalDataSource.insertWordsList(words);
      }
    }
    return verses;
  }
}
