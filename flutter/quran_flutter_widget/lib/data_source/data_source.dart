import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/cache/chash_helper.dart';
import 'package:quran_widget_flutter/data_source/local/file_storage/download_book.dart';
import 'package:quran_widget_flutter/data_source/local/file_storage/download_chapter.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/chapter_download_data_source.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/verses_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/repository/book_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/chapter_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/narration_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/part_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/page_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/recitation_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/recitation_verses_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/reciter_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/tafseer_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/tajweed_repository.dart';
import 'package:quran_widget_flutter/data_source/repository/translation_repository.dart';
import 'package:quran_widget_flutter/model/book.dart';
import 'package:quran_widget_flutter/model/chapter.dart';
import 'package:quran_widget_flutter/model/chapter_download.dart';
import 'package:quran_widget_flutter/model/explanation.dart';
import 'package:quran_widget_flutter/model/explanation_verse.dart';
import 'package:quran_widget_flutter/model/narration.dart';
import 'package:quran_widget_flutter/model/page.dart';
import 'package:quran_widget_flutter/model/part.dart';
import 'package:quran_widget_flutter/model/recitation.dart';
import 'package:quran_widget_flutter/model/recitation_verses.dart';
import 'package:quran_widget_flutter/model/reciter.dart';
import 'package:quran_widget_flutter/model/tajweed_model.dart';
import 'package:quran_widget_flutter/model/translation.dart';
import 'package:quran_widget_flutter/model/translation_verse.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:quran_widget_flutter/model/word_tajweed.dart';
import 'package:quran_widget_flutter/plugin_auth/quran_widget_init.dart';
import 'package:quran_widget_flutter/src/plugin_src/data/quran_service.dart';

class DataSource {
  static final DataSource _ds = DataSource._internalInstance();

  DataSource._internalInstance();

  static DataSource get instance => _ds;

  factory DataSource() => instance;

  Future<void> initialApp({
    required String clientId,
    required String clientSecret,
    String? baseUrl,
  }) async =>
      await QuranWidgetInit.init(
        clientId: clientId,
        clientSecret: clientSecret,
        baseUrl: baseUrl,
      );

  Future<void> signOut() async => await CacheHelper.clearAll();

  final NarrationRepository _narrationRepository = NarrationRepository();
  final BookRepository _bookRepository = BookRepository();

  final ChapterRepository _chapterRepository = ChapterRepository();
  final PartRepository _partRepository = PartRepository();
  final PageRepository _pageRepository = PageRepository();
  final RecitationRepository _recitationRepository = RecitationRepository();
  final RecitationVersesRepository _recitationVersesRepository =
      RecitationVersesRepository();
  final ReciterRepository _reciterRepository = ReciterRepository();
  final TajweedRepository _tajweedRepository = TajweedRepository();

  final TranslationRepository _translationRepository = TranslationRepository();

  final TafseerRepository _tafseerRepository = TafseerRepository();

  final ChapterDownloadLocalDataSource _chapterDownloadDataSource =
      ChapterDownloadLocalDataSource();

  Future<List<Narration>?> fetchNarrationsList({
    String? qurey,
    Function(int, int)? onDownloadProgress,
  }) =>
      _narrationRepository.fetchNarrationsList(
          qurey: qurey, onDownloadProgress: onDownloadProgress);

  Future<Narration?> fetchNarrationById(int narrationId) =>
      _narrationRepository.fetchNarrationById(narrationId);

  Future<Verse?>? fetchVerseById(int vsersId) async =>
      await _pageRepository.fetchVerseById(vsersId);

  Future<List<Book>?> fetchBooksList({
    String? qurey,
    int? narrationId,
    Function(int, int)? onDownloadProgress,
  }) =>
      _bookRepository.fetchBooksList(
          qurey: qurey,
          narrationId: narrationId,
          onDownloadProgress: onDownloadProgress);

  Future<Book?> fetchBookById(int bookId) =>
      _bookRepository.fetchBookById(bookId);

  Future<List<Chapter>?> fetchChaptersList({
    String? qurey,
    bool? fromIndex,
    int? bookId,
    int? narrationId,
    Function(int, int)? onDownloadProgress,
  }) =>
      _chapterRepository.fetchChaptersList(
        qurey: qurey,
        fromIndex: fromIndex,
        bookId: bookId,
        narrationId: narrationId,
        onDownloadProgress: onDownloadProgress,
      );

  Future<Chapter?> fetchChapterById(int chapterId, [int? narrationId]) =>
      _chapterRepository.fetchChapterById(chapterId, narrationId);

  Future<List<Part>?> fetchPartsList({
    String? qurey,
    Function(int, int)? onDownloadProgress,
  }) =>
      _partRepository.fetchPartsList(onDownloadProgress: onDownloadProgress);

  Future<Part?> fetchPartById(int partId) =>
      _partRepository.fetchPartById(partId);

  Future<List<Verse>> fetchVersesList({
    Function(int, int)? onDownloadProgress,
    int? chapterNumber,
    String? qurey,
  }) =>
      _narrationRepository.fetchVersesList(
        onDownloadProgress: onDownloadProgress,
        qurey: qurey,
        chapterNumber: chapterNumber,
      );

  Future<void> downloadPages() => _pageRepository.downloadPagesList();

  Future<List<Page>?> fetchPagesList({
    int? bookId,
    int? narrationId,
    int? chapterId,
  }) =>
      _pageRepository.fetchPagesList(
          bookId: bookId ?? 1,
          narrationId: narrationId ?? 1,
          chapterId: chapterId);

  Future<List<Page>?> fetchPagesListDown({
    int? bookId,
    int? narrationId,
  }) =>
      _pageRepository.fetchPagesListDown(
          bookId: bookId, narrationId: narrationId);

  // Future<page.Page?> fetchPageById(int pageId) =>
  //     _pageRepository.fetchPageById(pageId);

  Future<List<Recitation>?> fetchRecitationsList({
    String? qurey,
    int? narrationId,
    Function(int, int)? onDownloadProgress,
  }) =>
      _recitationRepository.fetchRecitationsList(
          narrationId: narrationId,
          qurey: qurey,
          onDownloadProgress: onDownloadProgress);

  Future<Recitation?> fetchRecitationById(int recitationId) =>
      _recitationRepository.fetchRecitationById(recitationId);

  Future<List<RecitationVerses>?> fetchRecitationsVersesList({
    int? chapterId,
    required int recitationId,
  }) =>
      _recitationVersesRepository.fetchRecitationsVersesList(
          recitationId, chapterId);

  Future<RecitationVerses?> fetchRecitationVersesById(
          int recitationId, int recitationVersesId) =>
      _recitationVersesRepository.fetchRecitationVersesById(
          recitationId, recitationVersesId);

  Future<List<RecitationVerses>?> fetchRecitationsVersesChapterList(
          {required int chapterId, required int recitationId}) =>
      _recitationVersesRepository.fetchRecitationsVersesChapterList(
          recitationId, chapterId);

  Future<List<Reciter>?> fetchRecitersList({String? qurey}) =>
      _reciterRepository.fetchRecitersList(qurey: qurey);

  Future<Reciter?> fetchReciterById(int reciterId) =>
      _reciterRepository.fetchReciterById(reciterId);

  Future<ChapterDownload> downloadChapter({
    required int chapterId,
    required int recitationId,
    required int reciterId,
    required int narrationId,
    Function(double)? retunProgress,
  }) async {
    return DownloadChapter.startDownload(
      chapterId: chapterId,
      recitationId: recitationId,
      retunProgress: retunProgress,
      reciterId: reciterId,
      narrationId: narrationId,
    );
  }

  Future<List<ChapterDownload>?> fetchChapterDownloadsList() async =>
      await _chapterDownloadDataSource.fetchChapterDownloadsList();

  Future<void> downloadBook(
      {int? bookId, int? narrationId, Function(double)? retunProgress}) async {
    DownloadBook.startDownload(
        bookId: bookId, narrationId: narrationId, retunProgress: retunProgress);
  }

  Future<List<Verse>> fetchVersesByPageNumber(int pageNumber) {
    return VersesLocalDataSource().filterVersesByPageNumberAndNarrationId(
        pageNumber: pageNumber,
        narrationId: QuranCacheRepository.narrationSelectedId);
  }

  Future<void> changeNarration({required Narration narration}) async {
    await QuranCacheRepository.setNarrationSelectedId(narration.id);
    await QuranCacheRepository.setNarrationSelectedName(narration.name);
    QuranService.instance.getVerses();
    List<Recitation> recitations = await fetchRecitationsList(
          narrationId: QuranCacheRepository.narrationSelectedId,
        ) ??
        [];

    await QuranCacheRepository.setSelectedRecitationId(
      recitations.isEmpty ? 0 : recitations.first.id!,
    );
    await QuranCacheRepository.setSelectedRecitationName(
      recitations.isEmpty ? '' : recitations.first.name!,
    );

    List<TajweedBook> tajweedBooks =
        await fetchTajweedBooksList(narrationId: narration.id) ?? [];
    if (tajweedBooks.isNotEmpty) {
      await QuranCacheRepository.setSelectedTajweedId(tajweedBooks.first.id!);
      await QuranCacheRepository.setSelectedTajweedName(
          tajweedBooks.first.name!);
    } else {
      await QuranCacheRepository.setSelectedTajweedId(0);
      await QuranCacheRepository.setSelectedTajweedName('');
    }

    List<Explanation> explanations =
        await fetchTafseerList(narrationId: narration.id) ?? [];

    if (explanations.isNotEmpty) {
      await QuranCacheRepository.setTafsirSelectedId(explanations.first.id!);
      await QuranCacheRepository.setTafsirSelectedName(
          explanations.first.name!);
    } else {
      await QuranCacheRepository.setTafsirSelectedId(0);
      await QuranCacheRepository.setTafsirSelectedName('');
    }
  }

  Future<void> initCacheData(int nid) async {
    if (nid != QuranCacheRepository.narrationSelectedId) {
      List<Narration> narrations =
          await _narrationRepository.fetchNarrationsList() ?? [];
      int selectedNarration = nid;
      if (nid == 0) {
        selectedNarration = narrations.isNotEmpty ? narrations.first.id : 0;
      }

      List<Book> books = await _bookRepository.fetchBooksList(
              narrationId: selectedNarration) ??
          [];
      int firstBook = books.isNotEmpty ? books.first.id! : 0;

      List<Chapter> chapters = await _chapterRepository.fetchChaptersList(
              narrationId: selectedNarration, bookId: firstBook) ??
          [];
      int firstChapter = chapters.isNotEmpty ? chapters.first.id! : 0;

      List<Recitation> recitations = await _recitationRepository
              .fetchRecitationsList(narrationId: selectedNarration) ??
          [];
      int firstRecitation = recitations.isNotEmpty ? recitations.first.id! : 0;

      await QuranCacheRepository.setNarrationSelectedId(selectedNarration);
      await QuranCacheRepository.setNarrationSelectedName(
          selectedNarration == 0 ? '' : narrations.first.name);
      await QuranCacheRepository.setBookSelectedId(firstBook);
      await QuranCacheRepository.setBookSelectedName(
          firstBook != 0 ? books.first.name! : '');
      await QuranCacheRepository.setSelectedChapterId(firstChapter);
      await QuranCacheRepository.setSelectedChapterName(
          firstChapter != 0 ? chapters.first.name! : '');
      await QuranCacheRepository.setSelectedRecitationId(firstRecitation);
      await QuranCacheRepository.setSelectedRecitationName(
          firstRecitation == 0 ? '' : recitations.first.name!);
      await QuranCacheRepository.setSelectedReciterId(
          firstRecitation == 0 ? 0 : recitations.first.reciterId!);
    }
  }

  // Tajweed
  Future<List<TajweedBook>?> fetchTajweedBooksList(
          {String? qurey, int? narrationId}) =>
      _tajweedRepository.fetchTajweedBooksList(
          qurey: qurey, narrationId: narrationId);

  Future<TajweedBook?> fetchTajweedBookById({required int id}) =>
      _tajweedRepository.fetchTajweedBookById(id: id);

  Future<List<TajweedCharacters>?> fetchTajweedCharactersList(
          {required int bookId}) =>
      _tajweedRepository.fetchTajweedCharactersList(bookId: bookId);

  Future<List<TajweedCharacters>?> fetchTajweedCharactersByVerseList(
          {required int bookId, required int verseId}) =>
      _tajweedRepository.fetchTajweedCharactersByVerseList(verseId: verseId);

  Future<List<TajweedCharacters>?> fetchTajweedCharactersByChapterList({
    required int bookId,
    required int chapterId,
    Function(int, int)? onDownloadProgress,
  }) =>
      _tajweedRepository.fetchTajweedCharactersByChapterList(
          bookId: bookId,
          chapterId: chapterId,
          onDownloadProgress: onDownloadProgress);

  Future<List<TajweedCharacters>?> fetchTajweedWordsByWordList(
          {required int bookId, required int wordId}) =>
      _tajweedRepository.fetchTajweedWordsByWordList(
          bookId: bookId, wordId: wordId);

  Future<TajweedCharacters?> fetchTajweedCharactersById({
    required int bookId,
    required int id,
  }) =>
      _tajweedRepository.fetchTajweedCharactersById(bookId: bookId, id: id);

  Future<List<TajweedCharacters>> getSavedTajweedChapters(
          {required int bookId}) =>
      _tajweedRepository.getSavedChaptersByBookId(bookId);

  Future<List<ExplanationVerse>?> getSavedExplainationChaptersByBookId(
          {required int tafseetId}) =>
      _tafseerRepository.getSavedChaptersByBookId(tafseetId);

  Future<List<Explanation>?> fetchTafseerList({
    String? qurey,
    int? narrationId,
  }) =>
      _tafseerRepository.fetchTafseerList(
          qurey: qurey, narrationId: narrationId);

  Future<Explanation?> fetchTafseerById({
    required int id,
  }) =>
      _tafseerRepository.fetchTafseerById(id: id);

  Future<ExplanationVerse?> fetchTafseerVersesById({
    required int tafseetId,
    required int id,
  }) =>
      _tafseerRepository.fetchTafseerVersesById(tafseetId: tafseetId, id: id);

  Future<List<ExplanationVerse>?> fetchTafseerVersesList({
    required int tafseetId,
    int? chapter,
    int? verseNum,
    int? pageNum,
    Function(int, int)? onDownloadProgress,
  }) =>
      _tafseerRepository.fetchTafseerVersesList(
        tafseerId: tafseetId,
        chapter: chapter,
        pageNum: pageNum,
        verseNum: pageNum,
        onDownloadProgress: onDownloadProgress,
      );

  Future<List<TranslationVerse>?> getTranslationsSavedChapters(
          {required int tranId}) =>
      _translationRepository.getSavedChaptersByBookId(tranId);

  Future<List<Translation>?> fetchTranslationList({
    String? qurey,
  }) =>
      _translationRepository.fetchTranslationList(qurey: qurey);

  Future<Translation?> fetchTranslationById({
    required int id,
    Function(int, int)? onDownloadProgress,
  }) =>
      _translationRepository.fetchTranslationById(
        id,
        onDownloadProgress: onDownloadProgress,
      );

  Future<List<TranslationVerse>?> fetchTranslationVerseList({
    required int tranId,
    int? chapter,
    Function(int, int)? onDownloadProgress,
  }) =>
      _translationRepository.fetchTranslationVerseList(
        tranId: tranId,
        chapter: chapter,
        onDownloadProgress: onDownloadProgress,
      );

  Future<TranslationVerse?> fetchTranslationVerseById({
    required int tranId,
    int? id,
  }) =>
      _translationRepository.fetchTranslationVerseById(
        tranId: tranId,
        id: id ?? 1,
      );

  loadQuranData() async {
    await QuranService.instance.allVersesAsync;
  }
}
