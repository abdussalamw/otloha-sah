import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:quran_widget_flutter/data_source/local/dao/book_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/chapter_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/chapter_download_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/chapters_page_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/explanation_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/explanation_verse_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/glyph_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/narration_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/page_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/part_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/recitation_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/recitation_verse_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/reciter_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/tajweed_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/tajweed_word_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/translation_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/translation_verse_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/verse_dao.dart';
import 'package:quran_widget_flutter/data_source/local/dao/word_dao.dart';
import 'package:quran_widget_flutter/model/book.dart';
import 'package:quran_widget_flutter/model/chapter.dart';
import 'package:quran_widget_flutter/model/chapter_download.dart';
import 'package:quran_widget_flutter/model/chapters_page.dart';
import 'package:quran_widget_flutter/model/explanation.dart';
import 'package:quran_widget_flutter/model/explanation_verse.dart';
import 'package:quran_widget_flutter/model/glyph.dart';
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
import 'package:quran_widget_flutter/model/word.dart';
import 'package:quran_widget_flutter/model/word_tajweed.dart';

part 'quran_database.g.dart';

@Database(version: 1, entities: [
  Part,
  Page,
  Word,
  Book,
  Verse,
  Glyph,
  Reciter,
  Chapter,
  Narration,
  Recitation,
  Translation,
  TajweedBook,
  Explanation,
  ChaptersPage,
  ChapterDownload,
  ExplanationVerse,
  TranslationVerse,
  RecitationVerses,
  TajweedCharacters,
])
abstract class QuranDatabase extends FloorDatabase {
  NarrationDao get narrationDao;
  BookDao get bookDao;
  ChapterDao get chapterDao;
  PartDao get partDao;
  PageDao get pageDao;
  RecitationDao get recitationDao;
  ReciterDao get reciterDao;
  RecitationVersesDao get recitationVersesDao;
  VerseDao get verseDao;
  GlyphDao get glyphDao;
  ChaptersPageDao get chaptersPageDao;
  ChapterDownloadDao get chapterDownloadDao;
  WordDao get wordDao;
  TajweedWordDao get tajweedWordDao;
  TajweedDao get tajweedDao;
  ExplanationDao get explanationDao;
  ExplanationVerseDao get explanationVerseDao;
  TranslationDao get translationDao;
  TranslationVerseDao get translationVerseDao;
}
