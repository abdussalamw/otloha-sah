import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

import '../data/quran_hafs_repository.dart';
import 'quran_hafs_state.dart';

import '../../../../core/utils/constant/utils.dart';
import '../../../../data_source/data_source.dart';
import '../../../../data_source/local/database/database/database.dart';
import '../../../../data_source/local/database/database_repository.dart';
import '../../../../data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/data_source/models/favorite_pages/favorite_pages.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class QuranHafsCubit extends Cubit<QuranHafsState> {
  QuranHafsCubit() : super(QuranHafsInitial());

  static QuranHafsCubit get(context) => BlocProvider.of(context);

  static final Set<int> _loadedFonts = {};

  // Cache to store already loaded pages
  final Map<int, QuranHafsLoaded> _pageCache = {};

  bool isBookmarked = false;
  FavoritePage? currentBookmark;

  Future<void> loadPage(int pageNumber) async {
    if (_pageCache.containsKey(pageNumber)) {
      emit(_pageCache[pageNumber]!);
      await _checkBookmarkStatus(pageNumber);
      return;
    }

    emit(QuranHafsLoading(pageNumber));
    try {
      await _loadFontIfNeeded(pageNumber);
      final glyphs = await QuranHafsRepository.getPageGlyphs(pageNumber);
      final alignments =
          await QuranHafsRepository.getPageAlignments(pageNumber);

      final loadedState = QuranHafsLoaded(
        pageNumber: pageNumber,
        glyphs: glyphs,
        alignments: alignments,
      );

      _pageCache[pageNumber] = loadedState;
      emit(loadedState);
      await _checkBookmarkStatus(pageNumber);
    } catch (e) {
      emit(QuranHafsError(e.toString()));
    }
  }

  Future<void> _checkBookmarkStatus(int pageNumber) async {
    try {
      int uid = (await UserDataServices.instance.getUserData())?.id ?? 0;
      final marks = await DatabaseRepository.instance.findAllPageMarkeds(uid);
      currentBookmark = null;
      isBookmarked = false;
      for (var mark in marks) {
        if (mark.pageNumber == pageNumber) {
          isBookmarked = true;
          currentBookmark = mark;
          break;
        }
      }
      if (state is QuranHafsLoaded) {
        emit(QuranHafsLoaded(
          pageNumber: (state as QuranHafsLoaded).pageNumber,
          glyphs: (state as QuranHafsLoaded).glyphs,
          alignments: (state as QuranHafsLoaded).alignments,
          isBookmarked: isBookmarked,
        ));
      }
    } catch (e) {
      print('Error checking bookmark: $e');
    }
  }

  Future<void> toggleBookmark(int pageNumber) async {
    if (isBookmarked && currentBookmark != null) {
      await DatabaseRepository.instance.deletePageMarked(currentBookmark!.id);
      isBookmarked = false;
      currentBookmark = null;
    } else {
      List<Verse> verses =
          await DataSource.instance.fetchVersesByPageNumber(pageNumber);
      int uid = (await UserDataServices.instance.getUserData())?.id ?? 0;

      currentBookmark = await DatabaseRepository.instance.insertPageMarked(
        FavoritePage(
          id: 0,
          idPage: verses.first.pageId ?? 0,
          idBook: verses.first.bookId ?? 0,
          pageNumber: pageNumber,
          textVerse: getFirstWords(verses.first.text ?? '', 5),
          userId: uid,
        ),
      );
      isBookmarked = true;
    }

    if (state is QuranHafsLoaded) {
      emit(QuranHafsLoaded(
        pageNumber: (state as QuranHafsLoaded).pageNumber,
        glyphs: (state as QuranHafsLoaded).glyphs,
        alignments: (state as QuranHafsLoaded).alignments,
        isBookmarked: isBookmarked,
      ));
    }
  }

  Future<void> addFavoriteVerse(
      int pageNumber, int sura, int ayah, String textFristVerse) async {
    try {
      List<Verse> verses =
          await DataSource.instance.fetchVersesByPageNumber(pageNumber);
      // find the verse by sura and ayah if possible, else just use the first on page
      Verse? targetVerse;
      for (var v in verses) {
        if (v.chapterId == sura && v.verseNumber == ayah) {
          targetVerse = v;
          break;
        }
      }
      targetVerse ??= verses.first;

      int uid = (await UserDataServices.instance.getUserData())?.id ?? 0;
      await DatabaseRepository.instance.insertVerseLiked(
        FavoriteVerse(
          id: 0,
          idFromVerse: targetVerse.id ?? 0,
          idToVerse: targetVerse.id ?? 0,
          idPage: targetVerse.pageId ?? 0,
          pageNumber: pageNumber,
          textFristVerse: getFirstWords(textFristVerse, 5),
          userId: uid,
        ),
      );
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  String getFirstWords(String sentence, int wordCounts) {
    List<String> words = sentence.split(" ");
    if (words.length <= wordCounts) return sentence;
    return words.sublist(0, wordCounts).join(" ");
  }

  Future<void> _loadFontIfNeeded(int pageNumber) async {
    final fontsToLoad = [pageNumber];
    
    final dir = await getApplicationDocumentsDirectory();
    final fontsDir = Directory('${dir.path}/quran_fonts_qfc4');
    
    // Load BSML font explicitly
    if (!_loadedFonts.contains(605)) { // using 605 as an arbitrary marker for BSML loaded
      final bsmlFontName = 'QCF4_BSML';
      File bsmlFontFile = File('${fontsDir.path}/$bsmlFontName.woff');
      if (!await bsmlFontFile.exists()) {
        bsmlFontFile = File('${fontsDir.path}/$bsmlFontName.ttf');
      }
      
      // Fallback recursive search
      if (!await bsmlFontFile.exists()) {
        if (await fontsDir.exists()) {
          final entities = await fontsDir.list(recursive: true).toList();
          for (var entity in entities) {
            if (entity is File) {
              final p = entity.path.toLowerCase();
              if (p.endsWith('$bsmlFontName.woff'.toLowerCase()) || p.endsWith('$bsmlFontName.ttf'.toLowerCase())) {
                bsmlFontFile = entity;
                break;
              }
            }
          }
        }
      }

      if (await bsmlFontFile.exists()) {
        final fontLoader = FontLoader(bsmlFontName);
        final fontData = bsmlFontFile.readAsBytes().then((data) => ByteData.view(data.buffer));
        fontLoader.addFont(fontData);
        await fontLoader.load();
        _loadedFonts.add(605);
      }
    }

    for (int page in fontsToLoad) {
      if (_loadedFonts.contains(page)) continue;

      final fontName = 'QCF4_${page.toString().padLeft(3, '0')}';
      File fontFile = File('${fontsDir.path}/$fontName.woff');
      if (!await fontFile.exists()) {
        fontFile = File('${fontsDir.path}/$fontName.ttf');
      }
      
      // Fallback: search recursively if not found in flat path
      if (!await fontFile.exists()) {
        if (await fontsDir.exists()) {
          final entities = await fontsDir.list(recursive: true).toList();
          for (var entity in entities) {
            if (entity is File) {
              final p = entity.path.toLowerCase();
              if (p.endsWith('$fontName.woff'.toLowerCase()) || p.endsWith('$fontName.ttf'.toLowerCase())) {
                fontFile = entity;
                break;
              }
            }
          }
        }
      }

      if (await fontFile.exists()) {
        final fontLoader = FontLoader(fontName);
        final fontData = fontFile.readAsBytes().then((data) => ByteData.view(data.buffer));
        fontLoader.addFont(fontData);
        await fontLoader.load();
        _loadedFonts.add(page);
      } else if (page == pageNumber) {
        throw Exception(
            'تعذر العثور على ملف الخط للصفحة $pageNumber. قد تحتاج لإعادة تنزيل الملفات.');
      }
    }
  }

  Future<HafsTafseer?> getTafseer(int sura, int ayah) async {
    return await QuranHafsRepository.getTafseer(sura, ayah);
  }
}
