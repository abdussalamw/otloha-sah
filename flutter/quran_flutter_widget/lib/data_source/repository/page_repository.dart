import 'package:quran_widget_flutter/data_source/local/local_data_source/page_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/verses_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/remote/page_api.dart';
import 'package:quran_widget_flutter/model/apis_response/my_response.dart';
import 'package:quran_widget_flutter/model/page.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:quran_widget_flutter/network_helper/apis.dart';

class PageRepository {
  final PageLocalDataSource _pageLocalDataSource = PageLocalDataSource();
  final VersesLocalDataSource _versesLocalDataSource = VersesLocalDataSource();
  final PageApi _pageApi = PageApi();

  Future<void> downloadPagesList() async {
    List<Page> pagesList = await _pageLocalDataSource.fetchPagesList() ?? [];
    if (pagesList.isEmpty) {
      final MyResponse<Page> response = await _pageApi.fetchAllPages();
      if (response.code == Apis.codeSUCCESS) {
        pagesList = response.data as List<Page>;
        await _pageLocalDataSource.savePagesList(pagesList);
      }
    }
  }

  Future<List<Page>?> fetchPagesList({
    int? chapterId,
    required int bookId,
    required int narrationId,
  }) async {
    List<Page>? pagesList = await _pageLocalDataSource
        .fetchPageListByNarrationAndBook(book: bookId, narration: narrationId);

    if ((pagesList != null && pagesList.isNotEmpty)) {
      for (var element in pagesList) {
        element.verses = await _pageLocalDataSource.findAllVersesChapterPage(
          bookId: bookId,
          chapterid: chapterId,
          narrationId: narrationId,
          pageId: element.id,
        );
        element.chapters =
            await _pageLocalDataSource.fetchChapterPageById(element.id ?? 0);
      }

      return pagesList;
    } else {
      final MyResponse<Page> response = await _pageApi.fetchPagesList(
          bookId: bookId, narrationId: narrationId);
      if (response.code == Apis.codeSUCCESS) {
        pagesList = response.data as List<Page>;
        _pageLocalDataSource.savePagesList(pagesList);
      }

      return pagesList;
    }
  }

  Future<Page> fetchPage({
    required int pageId,
    required int narrationId,
    required int bookId,
  }) async {
    Page? page = await _pageLocalDataSource.fetchPageById(pageId);
    if (page == null) {
      MyResponse<Page> response = await _pageApi.fetchPageById(pageId);
      if (response.code == Apis.codeSUCCESS) {
        page = response.data as Page;
        await _pageLocalDataSource.savePage(page);
      }
    } else {
      page.verses = await _versesLocalDataSource.findAllVersesChapterPage(
          page: pageId, narration: narrationId, book: bookId);
    }
    page!.verses = await _versesLocalDataSource.findAllVersesChapterPage(
        page: pageId, narration: narrationId, book: bookId);
    return page;
  }

  Future<List<Page>?> fetchPagesListDown({
    int? bookId,
    int? narrationId,
  }) async {
    List<Page>? pagesList = await _pageLocalDataSource.findChapterPage(
        bookId: bookId, chapterid: 1, narrationId: narrationId);

    if ((pagesList != null && pagesList.isNotEmpty)) {
      for (var element in pagesList) {
        element.verses =
            await _pageLocalDataSource.fetchVerseByPageId(element.id ?? 0);
        //print('getVerse ${element.verses}');
      }

      return pagesList;
    } else {
      try {
        List<Page>? pagesList;

        final MyResponse<Page> response = await _pageApi.fetchPagesListDown(
            bookId: bookId, narrationId: narrationId);

        print('done returen');

        if (response.code == Apis.codeSUCCESS) {
          pagesList = response.data as List<Page>;
          print('ResponseDownload ${pagesList.whereType()} $pagesList ');
          _pageLocalDataSource.savePagesList(pagesList);
        } else {
          print('else $response');
        }

        return pagesList;
      } catch (e) {
        print(e.toString());
      }
    }
    return null;
  }

  // Future<Page?> fetchPageById(int pageId) async {
  //   Page? page = await _pageLocalDataSource.fetchPageById(pageId);
  //   if (page != null) {
  //     page.verses = await _pageLocalDataSource.fetchVerseByPageId(page.id ?? 0);
  //     //print('getVerse ${page.verses}');
  //     page.chapters =
  //         await _pageLocalDataSource.fetchChapterPageById(page.id ?? 0);
  //     return page;
  //   } else {
  //     final MyResponse<Page> response = await _pageApi.fetchPageById(pageId);
  //     if (response.code == Apis.codeSUCCESS) {
  //       page = response.data as Page?;
  //     }
  //     return page;
  //   }
  // }

  Future<Verse?> fetchVerseById(int verseId) async {
    Verse? verse = await _pageLocalDataSource.fetchVerseById(verseId);
    if (verse != null) {
      return verse;
    }
    return null;
  }
}
