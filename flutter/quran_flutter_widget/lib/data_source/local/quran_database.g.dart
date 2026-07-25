// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorQuranDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$QuranDatabaseBuilder databaseBuilder(String name) =>
      _$QuranDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$QuranDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$QuranDatabaseBuilder(null);
}

class _$QuranDatabaseBuilder {
  _$QuranDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$QuranDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$QuranDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<QuranDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$QuranDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$QuranDatabase extends QuranDatabase {
  _$QuranDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NarrationDao? _narrationDaoInstance;

  BookDao? _bookDaoInstance;

  ChapterDao? _chapterDaoInstance;

  PartDao? _partDaoInstance;

  PageDao? _pageDaoInstance;

  RecitationDao? _recitationDaoInstance;

  ReciterDao? _reciterDaoInstance;

  RecitationVersesDao? _recitationVersesDaoInstance;

  VerseDao? _verseDaoInstance;

  GlyphDao? _glyphDaoInstance;

  ChaptersPageDao? _chaptersPageDaoInstance;

  ChapterDownloadDao? _chapterDownloadDaoInstance;

  WordDao? _wordDaoInstance;

  TajweedWordDao? _tajweedWordDaoInstance;

  TajweedDao? _tajweedDaoInstance;

  ExplanationDao? _explanationDaoInstance;

  ExplanationVerseDao? _explanationVerseDaoInstance;

  TranslationDao? _translationDaoInstance;

  TranslationVerseDao? _translationVerseDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Part` (`id` INTEGER, `name` TEXT, `alias` TEXT, `part_number` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Page` (`id` INTEGER, `page_number` INTEGER, `narration` INTEGER, `book` INTEGER, `part` INTEGER, `sub_part` INTEGER, `image` TEXT, `localImage` TEXT, `chapters` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Word` (`id` INTEGER NOT NULL, `text` TEXT NOT NULL, `narration` INTEGER NOT NULL, `chapter_number` INTEGER NOT NULL, `verse_number` INTEGER NOT NULL, `number` INTEGER NOT NULL, `verse` INTEGER NOT NULL, `position_in_line` INTEGER, `line_number` INTEGER, `font_size` REAL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Book` (`id` INTEGER, `name` TEXT, `narration` INTEGER, `downloaded` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Verse` (`id` INTEGER, `text` TEXT, `uthmanic_text` TEXT, `line_start` INTEGER, `line_end` INTEGER, `image` TEXT, `narration` INTEGER, `chapter` INTEGER, `book` INTEGER, `part` INTEGER, `page` INTEGER, `page_number` INTEGER, `verse_number` INTEGER, `chapter_number` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Glyph` (`id` INTEGER, `verse` INTEGER, `page` INTEGER, `chapter` INTEGER, `line_number` INTEGER, `position` INTEGER, `minX` INTEGER, `maxX` INTEGER, `minY` INTEGER, `maxY` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Reciter` (`id` INTEGER, `name` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Chapter` (`id` INTEGER, `name` TEXT, `chapter_number` INTEGER, `origin` TEXT, `from_page` INTEGER, `to_page` INTEGER, `verses_length` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Narration` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Recitation` (`id` INTEGER, `narration` INTEGER, `reciter` INTEGER, `name` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `translation` (`id` INTEGER, `name` TEXT, `author` TEXT, `language` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tajweed` (`id` INTEGER, `name` TEXT, `author` TEXT, `narration` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `explanation` (`id` INTEGER, `name` TEXT, `narration` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ChaptersPage` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `pageId` INTEGER, `chapterId` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ChapterDownload` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `narrationId` INTEGER, `reciterId` INTEGER, `recitationId` INTEGER, `chapterId` INTEGER, `downloaded` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `explanation_verse` (`id` INTEGER, `explanation` INTEGER, `text` TEXT, `verse_number` INTEGER, `chapter_number` INTEGER, `page_number` INTEGER, `verse` INTEGER, `chapter` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `translation_verse` (`text` TEXT, `chapter` INTEGER, `chapter_number` INTEGER, `verse_number` INTEGER, `translation` INTEGER, PRIMARY KEY (`chapter_number`, `verse_number`, `translation`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RecitationVerses` (`id` INTEGER, `verse_number` INTEGER, `recitation` INTEGER, `chapter` INTEGER, `record` TEXT, `recordLocal` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tajweed_charchter` (`id` INTEGER, `charchter_text` TEXT, `word_number` INTEGER, `word_text` TEXT, `rule` TEXT, `verse_number` INTEGER, `character_text` TEXT, `charachter_number` INTEGER, `rule_text` TEXT, `chapter_number` INTEGER, `word` INTEGER, `chapter` INTEGER, `verse` INTEGER, `book` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NarrationDao get narrationDao {
    return _narrationDaoInstance ??= _$NarrationDao(database, changeListener);
  }

  @override
  BookDao get bookDao {
    return _bookDaoInstance ??= _$BookDao(database, changeListener);
  }

  @override
  ChapterDao get chapterDao {
    return _chapterDaoInstance ??= _$ChapterDao(database, changeListener);
  }

  @override
  PartDao get partDao {
    return _partDaoInstance ??= _$PartDao(database, changeListener);
  }

  @override
  PageDao get pageDao {
    return _pageDaoInstance ??= _$PageDao(database, changeListener);
  }

  @override
  RecitationDao get recitationDao {
    return _recitationDaoInstance ??= _$RecitationDao(database, changeListener);
  }

  @override
  ReciterDao get reciterDao {
    return _reciterDaoInstance ??= _$ReciterDao(database, changeListener);
  }

  @override
  RecitationVersesDao get recitationVersesDao {
    return _recitationVersesDaoInstance ??=
        _$RecitationVersesDao(database, changeListener);
  }

  @override
  VerseDao get verseDao {
    return _verseDaoInstance ??= _$VerseDao(database, changeListener);
  }

  @override
  GlyphDao get glyphDao {
    return _glyphDaoInstance ??= _$GlyphDao(database, changeListener);
  }

  @override
  ChaptersPageDao get chaptersPageDao {
    return _chaptersPageDaoInstance ??=
        _$ChaptersPageDao(database, changeListener);
  }

  @override
  ChapterDownloadDao get chapterDownloadDao {
    return _chapterDownloadDaoInstance ??=
        _$ChapterDownloadDao(database, changeListener);
  }

  @override
  WordDao get wordDao {
    return _wordDaoInstance ??= _$WordDao(database, changeListener);
  }

  @override
  TajweedWordDao get tajweedWordDao {
    return _tajweedWordDaoInstance ??=
        _$TajweedWordDao(database, changeListener);
  }

  @override
  TajweedDao get tajweedDao {
    return _tajweedDaoInstance ??= _$TajweedDao(database, changeListener);
  }

  @override
  ExplanationDao get explanationDao {
    return _explanationDaoInstance ??=
        _$ExplanationDao(database, changeListener);
  }

  @override
  ExplanationVerseDao get explanationVerseDao {
    return _explanationVerseDaoInstance ??=
        _$ExplanationVerseDao(database, changeListener);
  }

  @override
  TranslationDao get translationDao {
    return _translationDaoInstance ??=
        _$TranslationDao(database, changeListener);
  }

  @override
  TranslationVerseDao get translationVerseDao {
    return _translationVerseDaoInstance ??=
        _$TranslationVerseDao(database, changeListener);
  }
}

class _$NarrationDao extends NarrationDao {
  _$NarrationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _narrationInsertionAdapter = InsertionAdapter(
            database,
            'Narration',
            (Narration item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                },
            changeListener),
        _narrationUpdateAdapter = UpdateAdapter(
            database,
            'Narration',
            ['id'],
            (Narration item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                },
            changeListener),
        _narrationDeletionAdapter = DeletionAdapter(
            database,
            'Narration',
            ['id'],
            (Narration item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Narration> _narrationInsertionAdapter;

  final UpdateAdapter<Narration> _narrationUpdateAdapter;

  final DeletionAdapter<Narration> _narrationDeletionAdapter;

  @override
  Future<List<Narration>> findAllNarrations() async {
    return _queryAdapter.queryList('SELECT * FROM Narration',
        mapper: (Map<String, Object?> row) => Narration(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String));
  }

  @override
  Stream<Narration?> findNarrationById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Narration WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Narration(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String),
        arguments: [id],
        queryableName: 'Narration',
        isView: false);
  }

  @override
  Future<List<Narration>> searchInNarration(String qurey) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Narration WHERE name like ?1 or description like ?1',
        mapper: (Map<String, Object?> row) => Narration(
            id: row['id'] as int,
            name: row['name'] as String,
            description: row['description'] as String),
        arguments: [qurey]);
  }

  @override
  Future<void> insertNarration(Narration narration) async {
    await _narrationInsertionAdapter.insert(
        narration, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateNarration(Narration narration) async {
    await _narrationUpdateAdapter.update(narration, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteNarration(Narration narration) async {
    await _narrationDeletionAdapter.delete(narration);
  }
}

class _$BookDao extends BookDao {
  _$BookDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _bookInsertionAdapter = InsertionAdapter(
            database,
            'Book',
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'narration': item.narrationId,
                  'downloaded': item.downloaded == null
                      ? null
                      : (item.downloaded! ? 1 : 0)
                },
            changeListener),
        _bookUpdateAdapter = UpdateAdapter(
            database,
            'Book',
            ['id'],
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'narration': item.narrationId,
                  'downloaded': item.downloaded == null
                      ? null
                      : (item.downloaded! ? 1 : 0)
                },
            changeListener),
        _bookDeletionAdapter = DeletionAdapter(
            database,
            'Book',
            ['id'],
            (Book item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'narration': item.narrationId,
                  'downloaded': item.downloaded == null
                      ? null
                      : (item.downloaded! ? 1 : 0)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Book> _bookInsertionAdapter;

  final UpdateAdapter<Book> _bookUpdateAdapter;

  final DeletionAdapter<Book> _bookDeletionAdapter;

  @override
  Future<List<Book>> findAllBooks() async {
    return _queryAdapter.queryList('SELECT * FROM Book',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            name: row['name'] as String?,
            narrationId: row['narration'] as int?,
            downloaded: row['downloaded'] == null
                ? null
                : (row['downloaded'] as int) != 0));
  }

  @override
  Future<List<Book>> searchInBooks(String qurey) async {
    return _queryAdapter.queryList('SELECT * FROM Book WHERE name like ?1',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            name: row['name'] as String?,
            narrationId: row['narration'] as int?,
            downloaded: row['downloaded'] == null
                ? null
                : (row['downloaded'] as int) != 0),
        arguments: [qurey]);
  }

  @override
  Future<List<Book>> findBooksInNarrationId(int narrationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Book WHERE narration = ?1 or downloaded > 0',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            name: row['name'] as String?,
            narrationId: row['narration'] as int?,
            downloaded: row['downloaded'] == null
                ? null
                : (row['downloaded'] as int) != 0),
        arguments: [narrationId]);
  }

  @override
  Stream<Book?> findBookById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Book WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Book(
            id: row['id'] as int?,
            name: row['name'] as String?,
            narrationId: row['narration'] as int?,
            downloaded: row['downloaded'] == null
                ? null
                : (row['downloaded'] as int) != 0),
        arguments: [id],
        queryableName: 'Book',
        isView: false);
  }

  @override
  Future<void> insertBook(Book book) async {
    await _bookInsertionAdapter.insert(book, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateBook(Book book) async {
    await _bookUpdateAdapter.update(book, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBook(Book book) async {
    await _bookDeletionAdapter.delete(book);
  }
}

class _$ChapterDao extends ChapterDao {
  _$ChapterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _chapterInsertionAdapter = InsertionAdapter(
            database,
            'Chapter',
            (Chapter item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'chapter_number': item.chapterNumber,
                  'origin': item.origin,
                  'from_page': item.pageFrom,
                  'to_page': item.pageTo,
                  'verses_length': item.versesSize
                }),
        _chapterUpdateAdapter = UpdateAdapter(
            database,
            'Chapter',
            ['id'],
            (Chapter item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'chapter_number': item.chapterNumber,
                  'origin': item.origin,
                  'from_page': item.pageFrom,
                  'to_page': item.pageTo,
                  'verses_length': item.versesSize
                }),
        _chapterDeletionAdapter = DeletionAdapter(
            database,
            'Chapter',
            ['id'],
            (Chapter item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'chapter_number': item.chapterNumber,
                  'origin': item.origin,
                  'from_page': item.pageFrom,
                  'to_page': item.pageTo,
                  'verses_length': item.versesSize
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Chapter> _chapterInsertionAdapter;

  final UpdateAdapter<Chapter> _chapterUpdateAdapter;

  final DeletionAdapter<Chapter> _chapterDeletionAdapter;

  @override
  Future<List<Chapter>> findAllChapters() async {
    return _queryAdapter.queryList('SELECT * FROM Chapter',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as int?,
            name: row['name'] as String?,
            chapterNumber: row['chapter_number'] as int?,
            origin: row['origin'] as String?,
            pageFrom: row['from_page'] as int?,
            pageTo: row['to_page'] as int?,
            versesSize: row['verses_length'] as int?));
  }

  @override
  Future<Chapter?> findChapterById(int id) async {
    return _queryAdapter.query('SELECT * FROM Chapter WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as int?,
            name: row['name'] as String?,
            chapterNumber: row['chapter_number'] as int?,
            origin: row['origin'] as String?,
            pageFrom: row['from_page'] as int?,
            pageTo: row['to_page'] as int?,
            versesSize: row['verses_length'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Chapter>> searchInChapter(String qurey) async {
    return _queryAdapter.queryList('SELECT * FROM Chapter WHERE name like ?1',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as int?,
            name: row['name'] as String?,
            chapterNumber: row['chapter_number'] as int?,
            origin: row['origin'] as String?,
            pageFrom: row['from_page'] as int?,
            pageTo: row['to_page'] as int?,
            versesSize: row['verses_length'] as int?),
        arguments: [qurey]);
  }

  @override
  Future<List<Chapter>> getChapters() async {
    return _queryAdapter.queryList(
        'SELECT  *,  COUNT(*) as number_of_verses  FROM Chapter LEFT JOIN Verse  ON Verse.chapter = Chapter.id  LEFT JOIN Page ON Verse.page = Page.id AND Page.chapter = Chapter.id WHERE narration = 1  ORDER BY  Chapter.chapter_number  ASC,  \'verses.page_number\' ASC,      \'verses.verse_number\'  ASC;',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as int?,
            name: row['name'] as String?,
            chapterNumber: row['chapter_number'] as int?,
            origin: row['origin'] as String?,
            pageFrom: row['from_page'] as int?,
            pageTo: row['to_page'] as int?,
            versesSize: row['verses_length'] as int?));
  }

  @override
  Future<Chapter?> getChapterByPageNumber(int pageNumber) async {
    return _queryAdapter.query(
        'SELECT * FROM Chapter WHERE from_page <= ?1 AND to_page >= ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => Chapter(
            id: row['id'] as int?,
            name: row['name'] as String?,
            chapterNumber: row['chapter_number'] as int?,
            origin: row['origin'] as String?,
            pageFrom: row['from_page'] as int?,
            pageTo: row['to_page'] as int?,
            versesSize: row['verses_length'] as int?),
        arguments: [pageNumber]);
  }

  @override
  Future<void> insertChapter(Chapter chapter) async {
    await _chapterInsertionAdapter.insert(chapter, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateChapter(Chapter chapter) async {
    await _chapterUpdateAdapter.update(chapter, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteChapter(Chapter chapter) async {
    await _chapterDeletionAdapter.delete(chapter);
  }
}

class _$PartDao extends PartDao {
  _$PartDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _partInsertionAdapter = InsertionAdapter(
            database,
            'Part',
            (Part item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'alias': item.alias,
                  'part_number': item.partNumber
                },
            changeListener),
        _partUpdateAdapter = UpdateAdapter(
            database,
            'Part',
            ['id'],
            (Part item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'alias': item.alias,
                  'part_number': item.partNumber
                },
            changeListener),
        _partDeletionAdapter = DeletionAdapter(
            database,
            'Part',
            ['id'],
            (Part item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'alias': item.alias,
                  'part_number': item.partNumber
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Part> _partInsertionAdapter;

  final UpdateAdapter<Part> _partUpdateAdapter;

  final DeletionAdapter<Part> _partDeletionAdapter;

  @override
  Future<List<Part>> findAllParts() async {
    return _queryAdapter.queryList('SELECT * FROM Part',
        mapper: (Map<String, Object?> row) => Part(
            row['id'] as int?,
            row['name'] as String?,
            row['alias'] as String?,
            row['part_number'] as int?));
  }

  @override
  Future<List<Part>> searchInPart(String qurey) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Part WHERE name like ?1 or alias like ?1',
        mapper: (Map<String, Object?> row) => Part(
            row['id'] as int?,
            row['name'] as String?,
            row['alias'] as String?,
            row['part_number'] as int?),
        arguments: [qurey]);
  }

  @override
  Stream<Part?> findPartById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Part WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Part(
            row['id'] as int?,
            row['name'] as String?,
            row['alias'] as String?,
            row['part_number'] as int?),
        arguments: [id],
        queryableName: 'Part',
        isView: false);
  }

  @override
  Future<void> insertPart(Part part) async {
    await _partInsertionAdapter.insert(part, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePart(Part part) async {
    await _partUpdateAdapter.update(part, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePart(Part part) async {
    await _partDeletionAdapter.delete(part);
  }
}

class _$PageDao extends PageDao {
  _$PageDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _pageInsertionAdapter = InsertionAdapter(
            database,
            'Page',
            (Page item) => <String, Object?>{
                  'id': item.id,
                  'page_number': item.pageNumber,
                  'narration': item.narrationId,
                  'book': item.bookId,
                  'part': item.partId,
                  'sub_part': item.subPartId,
                  'image': item.image,
                  'localImage': item.localImage,
                  'chapters': item.chaptersId
                }),
        _pageUpdateAdapter = UpdateAdapter(
            database,
            'Page',
            ['id'],
            (Page item) => <String, Object?>{
                  'id': item.id,
                  'page_number': item.pageNumber,
                  'narration': item.narrationId,
                  'book': item.bookId,
                  'part': item.partId,
                  'sub_part': item.subPartId,
                  'image': item.image,
                  'localImage': item.localImage,
                  'chapters': item.chaptersId
                }),
        _pageDeletionAdapter = DeletionAdapter(
            database,
            'Page',
            ['id'],
            (Page item) => <String, Object?>{
                  'id': item.id,
                  'page_number': item.pageNumber,
                  'narration': item.narrationId,
                  'book': item.bookId,
                  'part': item.partId,
                  'sub_part': item.subPartId,
                  'image': item.image,
                  'localImage': item.localImage,
                  'chapters': item.chaptersId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Page> _pageInsertionAdapter;

  final UpdateAdapter<Page> _pageUpdateAdapter;

  final DeletionAdapter<Page> _pageDeletionAdapter;

  @override
  Future<List<Page>> findAllPages() async {
    return _queryAdapter.queryList('SELECT * FROM Page',
        mapper: (Map<String, Object?> row) => Page(
            id: row['id'] as int?,
            pageNumber: row['page_number'] as int?,
            narrationId: row['narration'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            subPartId: row['sub_part'] as int?,
            image: row['image'] as String?,
            localImage: row['localImage'] as String?,
            chaptersId: row['chapters'] as String));
  }

  @override
  Future<List<Page>> findPageListByNarrationAndBook(
      int narration, int book) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Page WHERE narration = ?1 AND book = ?2',
        mapper: (Map<String, Object?> row) => Page(
            id: row['id'] as int?,
            pageNumber: row['page_number'] as int?,
            narrationId: row['narration'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            subPartId: row['sub_part'] as int?,
            image: row['image'] as String?,
            localImage: row['localImage'] as String?,
            chaptersId: row['chapters'] as String),
        arguments: [narration, book]);
  }

  @override
  Future<Page?> findPageById(int id) async {
    return _queryAdapter.query('SELECT * FROM Page WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Page(
            id: row['id'] as int?,
            pageNumber: row['page_number'] as int?,
            narrationId: row['narration'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            subPartId: row['sub_part'] as int?,
            image: row['image'] as String?,
            localImage: row['localImage'] as String?,
            chaptersId: row['chapters'] as String),
        arguments: [id]);
  }

  @override
  Future<Page?> findPageFilters(int narrationId, int chapterid, int bookId,
      int partId, int subPartId) async {
    return _queryAdapter.query(
        'SELECT * FROM Page WHERE narration = ?1 or chapters= ?2 or book =?3 or part =?4 or sub_part =?5',
        mapper: (Map<String, Object?> row) => Page(id: row['id'] as int?, pageNumber: row['page_number'] as int?, narrationId: row['narration'] as int?, bookId: row['book'] as int?, partId: row['part'] as int?, subPartId: row['sub_part'] as int?, image: row['image'] as String?, localImage: row['localImage'] as String?, chaptersId: row['chapters'] as String),
        arguments: [narrationId, chapterid, bookId, partId, subPartId]);
  }

  @override
  Future<List<Page>?> findChapterPage(
      int narrationId, int chapterid, int bookId) async {
    return _queryAdapter.queryList(
        'SELECT  DISTINCT(Page.id), Page.* FROM Page,ChaptersPage WHERE narration = ?1 and ChaptersPage.chapterId = ?2 and book = ?3 and ChaptersPage.pageId = Page.id ORDER by Page.page_number',
        mapper: (Map<String, Object?> row) => Page(id: row['id'] as int?, pageNumber: row['page_number'] as int?, narrationId: row['narration'] as int?, bookId: row['book'] as int?, partId: row['part'] as int?, subPartId: row['sub_part'] as int?, image: row['image'] as String?, localImage: row['localImage'] as String?, chaptersId: row['chapters'] as String),
        arguments: [narrationId, chapterid, bookId]);
  }

  @override
  Future<List<Page>> findPageBetween(int firstPage, int lastPage) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Page WHERE id BETWEEN ?1 AND ?2',
        mapper: (Map<String, Object?> row) => Page(
            id: row['id'] as int?,
            pageNumber: row['page_number'] as int?,
            narrationId: row['narration'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            subPartId: row['sub_part'] as int?,
            image: row['image'] as String?,
            localImage: row['localImage'] as String?,
            chaptersId: row['chapters'] as String),
        arguments: [firstPage, lastPage]);
  }

  @override
  Future<void> insertPage(Page page) async {
    await _pageInsertionAdapter.insert(page, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePage(Page page) async {
    await _pageUpdateAdapter.update(page, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePage(Page page) async {
    await _pageDeletionAdapter.delete(page);
  }
}

class _$RecitationDao extends RecitationDao {
  _$RecitationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _recitationInsertionAdapter = InsertionAdapter(
            database,
            'Recitation',
            (Recitation item) => <String, Object?>{
                  'id': item.id,
                  'narration': item.narrationId,
                  'reciter': item.reciterId,
                  'name': item.name
                },
            changeListener),
        _recitationUpdateAdapter = UpdateAdapter(
            database,
            'Recitation',
            ['id'],
            (Recitation item) => <String, Object?>{
                  'id': item.id,
                  'narration': item.narrationId,
                  'reciter': item.reciterId,
                  'name': item.name
                },
            changeListener),
        _recitationDeletionAdapter = DeletionAdapter(
            database,
            'Recitation',
            ['id'],
            (Recitation item) => <String, Object?>{
                  'id': item.id,
                  'narration': item.narrationId,
                  'reciter': item.reciterId,
                  'name': item.name
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Recitation> _recitationInsertionAdapter;

  final UpdateAdapter<Recitation> _recitationUpdateAdapter;

  final DeletionAdapter<Recitation> _recitationDeletionAdapter;

  @override
  Future<List<Recitation>> findAllRecitations() async {
    return _queryAdapter.queryList('SELECT * FROM Recitation',
        mapper: (Map<String, Object?> row) => Recitation(
            row['id'] as int?,
            row['narration'] as int?,
            row['reciter'] as int?,
            row['name'] as String?));
  }

  @override
  Future<List<Recitation>> findRecitationsByNarration(int narrationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Recitation WHERE narration = ?1',
        mapper: (Map<String, Object?> row) => Recitation(
            row['id'] as int?,
            row['narration'] as int?,
            row['reciter'] as int?,
            row['name'] as String?),
        arguments: [narrationId]);
  }

  @override
  Future<List<Recitation>> findRecitations(
      int narrationId, int reciterId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Recitation WHERE narration = ?1 and reciter = ?2',
        mapper: (Map<String, Object?> row) => Recitation(
            row['id'] as int?,
            row['narration'] as int?,
            row['reciter'] as int?,
            row['name'] as String?),
        arguments: [narrationId, reciterId]);
  }

  @override
  Stream<Recitation?> findRecitationById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Recitation WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Recitation(
            row['id'] as int?,
            row['narration'] as int?,
            row['reciter'] as int?,
            row['name'] as String?),
        arguments: [id],
        queryableName: 'Recitation',
        isView: false);
  }

  @override
  Future<void> insertRecitation(Recitation recitation) async {
    await _recitationInsertionAdapter.insert(
        recitation, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateRecitation(Recitation recitation) async {
    await _recitationUpdateAdapter.update(recitation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRecitation(Recitation recitation) async {
    await _recitationDeletionAdapter.delete(recitation);
  }
}

class _$ReciterDao extends ReciterDao {
  _$ReciterDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _reciterInsertionAdapter = InsertionAdapter(
            database,
            'Reciter',
            (Reciter item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener),
        _reciterUpdateAdapter = UpdateAdapter(
            database,
            'Reciter',
            ['id'],
            (Reciter item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener),
        _reciterDeletionAdapter = DeletionAdapter(
            database,
            'Reciter',
            ['id'],
            (Reciter item) =>
                <String, Object?>{'id': item.id, 'name': item.name},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Reciter> _reciterInsertionAdapter;

  final UpdateAdapter<Reciter> _reciterUpdateAdapter;

  final DeletionAdapter<Reciter> _reciterDeletionAdapter;

  @override
  Future<List<Reciter>> findAllReciters() async {
    return _queryAdapter.queryList('SELECT * FROM Reciter',
        mapper: (Map<String, Object?> row) =>
            Reciter(row['id'] as int?, row['name'] as String?));
  }

  @override
  Future<List<Reciter>> searchInReciter(String qurey) async {
    return _queryAdapter.queryList('SELECT * FROM Reciter WHERE name like ?1',
        mapper: (Map<String, Object?> row) =>
            Reciter(row['id'] as int?, row['name'] as String?),
        arguments: [qurey]);
  }

  @override
  Stream<Reciter?> findReciterById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Reciter WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Reciter(row['id'] as int?, row['name'] as String?),
        arguments: [id],
        queryableName: 'Reciter',
        isView: false);
  }

  @override
  Future<void> insertReciter(Reciter reciter) async {
    await _reciterInsertionAdapter.insert(reciter, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateReciter(Reciter reciter) async {
    await _reciterUpdateAdapter.update(reciter, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteReciter(Reciter reciter) async {
    await _reciterDeletionAdapter.delete(reciter);
  }
}

class _$RecitationVersesDao extends RecitationVersesDao {
  _$RecitationVersesDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _recitationVersesInsertionAdapter = InsertionAdapter(
            database,
            'RecitationVerses',
            (RecitationVerses item) => <String, Object?>{
                  'id': item.id,
                  'verse_number': item.verseNumber,
                  'recitation': item.recitationId,
                  'chapter': item.chapterId,
                  'record': item.record,
                  'recordLocal': item.recordLocal
                },
            changeListener),
        _recitationVersesUpdateAdapter = UpdateAdapter(
            database,
            'RecitationVerses',
            ['id'],
            (RecitationVerses item) => <String, Object?>{
                  'id': item.id,
                  'verse_number': item.verseNumber,
                  'recitation': item.recitationId,
                  'chapter': item.chapterId,
                  'record': item.record,
                  'recordLocal': item.recordLocal
                },
            changeListener),
        _recitationVersesDeletionAdapter = DeletionAdapter(
            database,
            'RecitationVerses',
            ['id'],
            (RecitationVerses item) => <String, Object?>{
                  'id': item.id,
                  'verse_number': item.verseNumber,
                  'recitation': item.recitationId,
                  'chapter': item.chapterId,
                  'record': item.record,
                  'recordLocal': item.recordLocal
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RecitationVerses> _recitationVersesInsertionAdapter;

  final UpdateAdapter<RecitationVerses> _recitationVersesUpdateAdapter;

  final DeletionAdapter<RecitationVerses> _recitationVersesDeletionAdapter;

  @override
  Future<List<RecitationVerses>> findAllRecitationsVerses() async {
    return _queryAdapter.queryList('SELECT * FROM RecitationVerses',
        mapper: (Map<String, Object?> row) => RecitationVerses(
            row['id'] as int?,
            row['chapter'] as int?,
            row['verse_number'] as int?,
            row['recitation'] as int?,
            row['record'] as String?,
            row['recordLocal'] as String?));
  }

  @override
  Stream<RecitationVerses?> findRecitationVersesById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM RecitationVerses WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RecitationVerses(
            row['id'] as int?,
            row['chapter'] as int?,
            row['verse_number'] as int?,
            row['recitation'] as int?,
            row['record'] as String?,
            row['recordLocal'] as String?),
        arguments: [id],
        queryableName: 'RecitationVerses',
        isView: false);
  }

  @override
  Future<List<RecitationVerses>> findRecitationVersesChapterList(
      int chapterId, int recitationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RecitationVerses WHERE recitation = ?2 AND chapter = ?1',
        mapper: (Map<String, Object?> row) => RecitationVerses(
            row['id'] as int?,
            row['chapter'] as int?,
            row['verse_number'] as int?,
            row['recitation'] as int?,
            row['record'] as String?,
            row['recordLocal'] as String?),
        arguments: [chapterId, recitationId]);
  }

  @override
  Future<void> insertRecitationVerses(RecitationVerses recitationVerses) async {
    await _recitationVersesInsertionAdapter.insert(
        recitationVerses, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateRecitationVerses(RecitationVerses recitationVerses) async {
    await _recitationVersesUpdateAdapter.update(
        recitationVerses, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteRecitationVerses(RecitationVerses recitationVerses) async {
    await _recitationVersesDeletionAdapter.delete(recitationVerses);
  }
}

class _$VerseDao extends VerseDao {
  _$VerseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _verseInsertionAdapter = InsertionAdapter(
            database,
            'Verse',
            (Verse item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'uthmanic_text': item.uthmanicText,
                  'line_start': item.lineStart,
                  'line_end': item.lineEnd,
                  'image': item.image,
                  'narration': item.narrationId,
                  'chapter': item.chapterId,
                  'book': item.bookId,
                  'part': item.partId,
                  'page': item.pageId,
                  'page_number': item.pageNumber,
                  'verse_number': item.verseNumber,
                  'chapter_number': item.chapterNumber
                },
            changeListener),
        _verseUpdateAdapter = UpdateAdapter(
            database,
            'Verse',
            ['id'],
            (Verse item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'uthmanic_text': item.uthmanicText,
                  'line_start': item.lineStart,
                  'line_end': item.lineEnd,
                  'image': item.image,
                  'narration': item.narrationId,
                  'chapter': item.chapterId,
                  'book': item.bookId,
                  'part': item.partId,
                  'page': item.pageId,
                  'page_number': item.pageNumber,
                  'verse_number': item.verseNumber,
                  'chapter_number': item.chapterNumber
                },
            changeListener),
        _verseDeletionAdapter = DeletionAdapter(
            database,
            'Verse',
            ['id'],
            (Verse item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'uthmanic_text': item.uthmanicText,
                  'line_start': item.lineStart,
                  'line_end': item.lineEnd,
                  'image': item.image,
                  'narration': item.narrationId,
                  'chapter': item.chapterId,
                  'book': item.bookId,
                  'part': item.partId,
                  'page': item.pageId,
                  'page_number': item.pageNumber,
                  'verse_number': item.verseNumber,
                  'chapter_number': item.chapterNumber
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Verse> _verseInsertionAdapter;

  final UpdateAdapter<Verse> _verseUpdateAdapter;

  final DeletionAdapter<Verse> _verseDeletionAdapter;

  @override
  Future<List<Verse>> findAllVerses(int narration) async {
    return _queryAdapter.queryList('SELECT * FROM Verse WHERE narration = ?1',
        mapper: (Map<String, Object?> row) => Verse(
            id: row['id'] as int?,
            text: row['text'] as String?,
            uthmanicText: row['uthmanic_text'] as String?,
            lineStart: row['line_start'] as int?,
            lineEnd: row['line_end'] as int?,
            image: row['image'] as String?,
            narrationId: row['narration'] as int?,
            chapterId: row['chapter'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            pageId: row['page'] as int?,
            verseNumber: row['verse_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapterNumber: row['chapter_number'] as int?),
        arguments: [narration]);
  }

  @override
  Future<List<Verse>> findAllVersesPage(int page) async {
    return _queryAdapter.queryList('SELECT * FROM Verse WHERE page = ?1',
        mapper: (Map<String, Object?> row) => Verse(
            id: row['id'] as int?,
            text: row['text'] as String?,
            uthmanicText: row['uthmanic_text'] as String?,
            lineStart: row['line_start'] as int?,
            lineEnd: row['line_end'] as int?,
            image: row['image'] as String?,
            narrationId: row['narration'] as int?,
            chapterId: row['chapter'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            pageId: row['page'] as int?,
            verseNumber: row['verse_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapterNumber: row['chapter_number'] as int?),
        arguments: [page]);
  }

  @override
  Future<List<Verse>> findAllVersesByBookAndNarration(
      int book, int narration) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Verse WHERE narration = ?2 and book = ?1;',
        mapper: (Map<String, Object?> row) => Verse(
            id: row['id'] as int?,
            text: row['text'] as String?,
            uthmanicText: row['uthmanic_text'] as String?,
            lineStart: row['line_start'] as int?,
            lineEnd: row['line_end'] as int?,
            image: row['image'] as String?,
            narrationId: row['narration'] as int?,
            chapterId: row['chapter'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            pageId: row['page'] as int?,
            verseNumber: row['verse_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapterNumber: row['chapter_number'] as int?),
        arguments: [book, narration]);
  }

  @override
  Future<List<Verse>> findAllVersesChapterPage(
      int page, int narration, int book) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Verse WHERE page = ?1 and narration = ?2 and book = ?3;',
        mapper: (Map<String, Object?> row) => Verse(
            id: row['id'] as int?,
            text: row['text'] as String?,
            uthmanicText: row['uthmanic_text'] as String?,
            lineStart: row['line_start'] as int?,
            lineEnd: row['line_end'] as int?,
            image: row['image'] as String?,
            narrationId: row['narration'] as int?,
            chapterId: row['chapter'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            pageId: row['page'] as int?,
            verseNumber: row['verse_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapterNumber: row['chapter_number'] as int?),
        arguments: [page, narration, book]);
  }

  @override
  Stream<Verse?> findVerseById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Verse WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Verse(
            id: row['id'] as int?,
            text: row['text'] as String?,
            uthmanicText: row['uthmanic_text'] as String?,
            lineStart: row['line_start'] as int?,
            lineEnd: row['line_end'] as int?,
            image: row['image'] as String?,
            narrationId: row['narration'] as int?,
            chapterId: row['chapter'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            pageId: row['page'] as int?,
            verseNumber: row['verse_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapterNumber: row['chapter_number'] as int?),
        arguments: [id],
        queryableName: 'Verse',
        isView: false);
  }

  @override
  Future<List<Verse>> findVersesBetween(int first, int last) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Verse WHERE id BETWEEN ?1 AND ?2',
        mapper: (Map<String, Object?> row) => Verse(
            id: row['id'] as int?,
            text: row['text'] as String?,
            uthmanicText: row['uthmanic_text'] as String?,
            lineStart: row['line_start'] as int?,
            lineEnd: row['line_end'] as int?,
            image: row['image'] as String?,
            narrationId: row['narration'] as int?,
            chapterId: row['chapter'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            pageId: row['page'] as int?,
            verseNumber: row['verse_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapterNumber: row['chapter_number'] as int?),
        arguments: [first, last]);
  }

  @override
  Future<List<Verse>> filterVersesByPageNumberAndNarrationId(
      int pageNumber, int narrationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Verse WHERE page_number = ?1 AND narration = ?2',
        mapper: (Map<String, Object?> row) => Verse(
            id: row['id'] as int?,
            text: row['text'] as String?,
            uthmanicText: row['uthmanic_text'] as String?,
            lineStart: row['line_start'] as int?,
            lineEnd: row['line_end'] as int?,
            image: row['image'] as String?,
            narrationId: row['narration'] as int?,
            chapterId: row['chapter'] as int?,
            bookId: row['book'] as int?,
            partId: row['part'] as int?,
            pageId: row['page'] as int?,
            verseNumber: row['verse_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapterNumber: row['chapter_number'] as int?),
        arguments: [pageNumber, narrationId]);
  }

  @override
  Future<List<Verse>> filterVersesByPageNumberAndNarrationIdBetweenPages(
      int narrationId, int startPage, int endPage) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Verse WHERE page_number BETWEEN ?2 AND ?3 AND narration = ?1',
        mapper: (Map<String, Object?> row) => Verse(id: row['id'] as int?, text: row['text'] as String?, uthmanicText: row['uthmanic_text'] as String?, lineStart: row['line_start'] as int?, lineEnd: row['line_end'] as int?, image: row['image'] as String?, narrationId: row['narration'] as int?, chapterId: row['chapter'] as int?, bookId: row['book'] as int?, partId: row['part'] as int?, pageId: row['page'] as int?, verseNumber: row['verse_number'] as int?, pageNumber: row['page_number'] as int?, chapterNumber: row['chapter_number'] as int?),
        arguments: [narrationId, startPage, endPage]);
  }

  @override
  Future<void> insertVerse(Verse verse) async {
    await _verseInsertionAdapter.insert(verse, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertVersesList(List<Verse> verses) async {
    await _verseInsertionAdapter.insertList(verses, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateVerse(Verse verse) async {
    await _verseUpdateAdapter.update(verse, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteVerse(Verse verse) async {
    await _verseDeletionAdapter.delete(verse);
  }
}

class _$GlyphDao extends GlyphDao {
  _$GlyphDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _glyphInsertionAdapter = InsertionAdapter(
            database,
            'Glyph',
            (Glyph item) => <String, Object?>{
                  'id': item.id,
                  'verse': item.verseId,
                  'page': item.pageId,
                  'chapter': item.chapterId,
                  'line_number': item.lineNumber,
                  'position': item.position,
                  'minX': item.minX,
                  'maxX': item.maxX,
                  'minY': item.minY,
                  'maxY': item.maxY
                },
            changeListener),
        _glyphUpdateAdapter = UpdateAdapter(
            database,
            'Glyph',
            ['id'],
            (Glyph item) => <String, Object?>{
                  'id': item.id,
                  'verse': item.verseId,
                  'page': item.pageId,
                  'chapter': item.chapterId,
                  'line_number': item.lineNumber,
                  'position': item.position,
                  'minX': item.minX,
                  'maxX': item.maxX,
                  'minY': item.minY,
                  'maxY': item.maxY
                },
            changeListener),
        _glyphDeletionAdapter = DeletionAdapter(
            database,
            'Glyph',
            ['id'],
            (Glyph item) => <String, Object?>{
                  'id': item.id,
                  'verse': item.verseId,
                  'page': item.pageId,
                  'chapter': item.chapterId,
                  'line_number': item.lineNumber,
                  'position': item.position,
                  'minX': item.minX,
                  'maxX': item.maxX,
                  'minY': item.minY,
                  'maxY': item.maxY
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Glyph> _glyphInsertionAdapter;

  final UpdateAdapter<Glyph> _glyphUpdateAdapter;

  final DeletionAdapter<Glyph> _glyphDeletionAdapter;

  @override
  Future<List<Glyph>> findAllGlyphs() async {
    return _queryAdapter.queryList('SELECT * FROM Glyph',
        mapper: (Map<String, Object?> row) => Glyph(
            row['id'] as int?,
            row['verse'] as int?,
            row['page'] as int?,
            row['chapter'] as int?,
            row['line_number'] as int?,
            row['position'] as int?,
            row['minX'] as int?,
            row['maxX'] as int?,
            row['minY'] as int?,
            row['maxY'] as int?));
  }

  @override
  Stream<Glyph?> findGlyphById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Glyph WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Glyph(
            row['id'] as int?,
            row['verse'] as int?,
            row['page'] as int?,
            row['chapter'] as int?,
            row['line_number'] as int?,
            row['position'] as int?,
            row['minX'] as int?,
            row['maxX'] as int?,
            row['minY'] as int?,
            row['maxY'] as int?),
        arguments: [id],
        queryableName: 'Glyph',
        isView: false);
  }

  @override
  Future<void> insertGlyph(Glyph glyph) async {
    await _glyphInsertionAdapter.insert(glyph, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertGlyphs(List<Glyph> glyph) async {
    await _glyphInsertionAdapter.insertList(glyph, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateGlyph(Glyph glyph) async {
    await _glyphUpdateAdapter.update(glyph, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteGlyph(Glyph glyph) async {
    await _glyphDeletionAdapter.delete(glyph);
  }
}

class _$ChaptersPageDao extends ChaptersPageDao {
  _$ChaptersPageDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _chaptersPageInsertionAdapter = InsertionAdapter(
            database,
            'ChaptersPage',
            (ChaptersPage item) => <String, Object?>{
                  'id': item.id,
                  'pageId': item.pageId,
                  'chapterId': item.chapterId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ChaptersPage> _chaptersPageInsertionAdapter;

  @override
  Future<List<ChaptersPage>> searchInChapter(int pageId) async {
    return _queryAdapter.queryList(
        'SELECT DISTINCT(pageId),* FROM ChaptersPage WHERE pageId = ?1',
        mapper: (Map<String, Object?> row) => ChaptersPage(
            id: row['id'] as int?,
            pageId: row['pageId'] as int?,
            chapterId: row['chapterId'] as int?),
        arguments: [pageId]);
  }

  @override
  Future<void> insertChaptersPage(List<ChaptersPage> chaptersPage) async {
    await _chaptersPageInsertionAdapter.insertList(
        chaptersPage, OnConflictStrategy.replace);
  }
}

class _$ChapterDownloadDao extends ChapterDownloadDao {
  _$ChapterDownloadDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _chapterDownloadInsertionAdapter = InsertionAdapter(
            database,
            'ChapterDownload',
            (ChapterDownload item) => <String, Object?>{
                  'id': item.id,
                  'narrationId': item.narrationId,
                  'reciterId': item.reciterId,
                  'recitationId': item.recitationId,
                  'chapterId': item.chapterId,
                  'downloaded': item.downloaded ? 1 : 0
                }),
        _chapterDownloadUpdateAdapter = UpdateAdapter(
            database,
            'ChapterDownload',
            ['id'],
            (ChapterDownload item) => <String, Object?>{
                  'id': item.id,
                  'narrationId': item.narrationId,
                  'reciterId': item.reciterId,
                  'recitationId': item.recitationId,
                  'chapterId': item.chapterId,
                  'downloaded': item.downloaded ? 1 : 0
                }),
        _chapterDownloadDeletionAdapter = DeletionAdapter(
            database,
            'ChapterDownload',
            ['id'],
            (ChapterDownload item) => <String, Object?>{
                  'id': item.id,
                  'narrationId': item.narrationId,
                  'reciterId': item.reciterId,
                  'recitationId': item.recitationId,
                  'chapterId': item.chapterId,
                  'downloaded': item.downloaded ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ChapterDownload> _chapterDownloadInsertionAdapter;

  final UpdateAdapter<ChapterDownload> _chapterDownloadUpdateAdapter;

  final DeletionAdapter<ChapterDownload> _chapterDownloadDeletionAdapter;

  @override
  Future<List<ChapterDownload>> findAllChapterDownloads(
      int narrationId, int recitationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ChapterDownload WHERE narrationId = ?1 AND recitationId = ?2',
        mapper: (Map<String, Object?> row) => ChapterDownload(id: row['id'] as int?, narrationId: row['narrationId'] as int?, reciterId: row['reciterId'] as int?, recitationId: row['recitationId'] as int?, chapterId: row['chapterId'] as int?, downloaded: (row['downloaded'] as int) != 0),
        arguments: [narrationId, recitationId]);
  }

  @override
  Future<ChapterDownload?> findChapterDownloadById(int id) async {
    return _queryAdapter.query('SELECT * FROM ChapterDownload WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ChapterDownload(
            id: row['id'] as int?,
            narrationId: row['narrationId'] as int?,
            reciterId: row['reciterId'] as int?,
            recitationId: row['recitationId'] as int?,
            chapterId: row['chapterId'] as int?,
            downloaded: (row['downloaded'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<void> insertChapterDownload(ChapterDownload chapterDownload) async {
    await _chapterDownloadInsertionAdapter.insert(
        chapterDownload, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateChapterDownload(ChapterDownload chapterDownload) async {
    await _chapterDownloadUpdateAdapter.update(
        chapterDownload, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteChapterDownload(ChapterDownload chapterDownload) async {
    await _chapterDownloadDeletionAdapter.delete(chapterDownload);
  }
}

class _$WordDao extends WordDao {
  _$WordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _wordInsertionAdapter = InsertionAdapter(
            database,
            'Word',
            (Word item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'narration': item.narration,
                  'chapter_number': item.chapterNumber,
                  'verse_number': item.verseNumber,
                  'number': item.number,
                  'verse': item.verse,
                  'position_in_line': item.positionInLine,
                  'line_number': item.lineNumber,
                  'font_size': item.fontSize
                }),
        _wordUpdateAdapter = UpdateAdapter(
            database,
            'Word',
            ['id'],
            (Word item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'narration': item.narration,
                  'chapter_number': item.chapterNumber,
                  'verse_number': item.verseNumber,
                  'number': item.number,
                  'verse': item.verse,
                  'position_in_line': item.positionInLine,
                  'line_number': item.lineNumber,
                  'font_size': item.fontSize
                }),
        _wordDeletionAdapter = DeletionAdapter(
            database,
            'Word',
            ['id'],
            (Word item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'narration': item.narration,
                  'chapter_number': item.chapterNumber,
                  'verse_number': item.verseNumber,
                  'number': item.number,
                  'verse': item.verse,
                  'position_in_line': item.positionInLine,
                  'line_number': item.lineNumber,
                  'font_size': item.fontSize
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Word> _wordInsertionAdapter;

  final UpdateAdapter<Word> _wordUpdateAdapter;

  final DeletionAdapter<Word> _wordDeletionAdapter;

  @override
  Future<List<Word>> findAllWords() async {
    return _queryAdapter.queryList('SELECT * FROM Word',
        mapper: (Map<String, Object?> row) => Word(
            id: row['id'] as int,
            text: row['text'] as String,
            narration: row['narration'] as int,
            chapterNumber: row['chapter_number'] as int,
            verseNumber: row['verse_number'] as int,
            number: row['number'] as int,
            verse: row['verse'] as int,
            positionInLine: row['position_in_line'] as int?,
            lineNumber: row['line_number'] as int?,
            fontSize: row['font_size'] as double?));
  }

  @override
  Future<List<Word>> findWordsBetweenVerses(
      int firstVerse, int lastVerse) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Word WHERE verse BETWEEN ?1 AND ?2 ORDER BY number',
        mapper: (Map<String, Object?> row) => Word(
            id: row['id'] as int,
            text: row['text'] as String,
            narration: row['narration'] as int,
            chapterNumber: row['chapter_number'] as int,
            verseNumber: row['verse_number'] as int,
            number: row['number'] as int,
            verse: row['verse'] as int,
            positionInLine: row['position_in_line'] as int?,
            lineNumber: row['line_number'] as int?,
            fontSize: row['font_size'] as double?),
        arguments: [firstVerse, lastVerse]);
  }

  @override
  Future<void> insertWord(Word word) async {
    await _wordInsertionAdapter.insert(word, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertWordsList(List<Word> word) async {
    await _wordInsertionAdapter.insertList(word, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateWord(Word word) async {
    await _wordUpdateAdapter.update(word, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWords(List<Word> word) async {
    await _wordUpdateAdapter.updateList(word, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWord(Word word) async {
    await _wordDeletionAdapter.delete(word);
  }
}

class _$TajweedWordDao extends TajweedWordDao {
  _$TajweedWordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _tajweedCharactersInsertionAdapter = InsertionAdapter(
            database,
            'tajweed_charchter',
            (TajweedCharacters item) => <String, Object?>{
                  'id': item.id,
                  'charchter_text': item.chrachterText,
                  'word_number': item.wordNumber,
                  'word_text': item.wordText,
                  'rule': item.rule,
                  'verse_number': item.verseNumber,
                  'character_text': item.characterText,
                  'charachter_number': item.characterNumber,
                  'rule_text': item.ruleText,
                  'chapter_number': item.chapterNumber,
                  'word': item.word,
                  'chapter': item.chapter,
                  'verse': item.verse,
                  'book': item.book
                },
            changeListener),
        _tajweedCharactersUpdateAdapter = UpdateAdapter(
            database,
            'tajweed_charchter',
            ['id'],
            (TajweedCharacters item) => <String, Object?>{
                  'id': item.id,
                  'charchter_text': item.chrachterText,
                  'word_number': item.wordNumber,
                  'word_text': item.wordText,
                  'rule': item.rule,
                  'verse_number': item.verseNumber,
                  'character_text': item.characterText,
                  'charachter_number': item.characterNumber,
                  'rule_text': item.ruleText,
                  'chapter_number': item.chapterNumber,
                  'word': item.word,
                  'chapter': item.chapter,
                  'verse': item.verse,
                  'book': item.book
                },
            changeListener),
        _tajweedCharactersDeletionAdapter = DeletionAdapter(
            database,
            'tajweed_charchter',
            ['id'],
            (TajweedCharacters item) => <String, Object?>{
                  'id': item.id,
                  'charchter_text': item.chrachterText,
                  'word_number': item.wordNumber,
                  'word_text': item.wordText,
                  'rule': item.rule,
                  'verse_number': item.verseNumber,
                  'character_text': item.characterText,
                  'charachter_number': item.characterNumber,
                  'rule_text': item.ruleText,
                  'chapter_number': item.chapterNumber,
                  'word': item.word,
                  'chapter': item.chapter,
                  'verse': item.verse,
                  'book': item.book
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TajweedCharacters> _tajweedCharactersInsertionAdapter;

  final UpdateAdapter<TajweedCharacters> _tajweedCharactersUpdateAdapter;

  final DeletionAdapter<TajweedCharacters> _tajweedCharactersDeletionAdapter;

  @override
  Future<List<TajweedCharacters>> findAllTajweedCharacters(int bookId) async {
    return _queryAdapter
        .queryList('SELECT * FROM tajweed_charchter where book = ?1',
            mapper: (Map<String, Object?> row) => TajweedCharacters(
                  id: row['id'] as int?,
                  chrachterText: row['charchter_text'] as String?,
                  wordNumber: row['word_number'] as int?,
                  wordText: row['word_text'] as String?,
                  rule: row['rule'] as String?,
                  verseNumber: row['verse_number'] as int?,
                  characterText: row['character_text'] as String?,
                  characterNumber: row['charachter_number'] as int?,
                  ruleText: row['rule_text'] as String?,
                  chapterNumber: row['chapter_number'] as int?,
                  word: row['word'] as int?,
                  chapter: row['chapter'] as int?,
                  verse: row['verse'] as int?,
                  book: row['book'] as int?,
                ),
            arguments: [bookId]);
  }

  @override
  Future<List<TajweedCharacters>> searchInTajweedCharacters(
      String qurey) async {
    return _queryAdapter
        .queryList('SELECT * FROM tajweed_charchter WHERE name like ?1',
            mapper: (Map<String, Object?> row) => TajweedCharacters(
                  id: row['id'] as int?,
                  chrachterText: row['charchter_text'] as String?,
                  wordNumber: row['word_number'] as int?,
                  wordText: row['word_text'] as String?,
                  rule: row['rule'] as String?,
                  verseNumber: row['verse_number'] as int?,
                  characterText: row['character_text'] as String?,
                  characterNumber: row['charachter_number'] as int?,
                  ruleText: row['rule_text'] as String?,
                  chapterNumber: row['chapter_number'] as int?,
                  word: row['word'] as int?,
                  chapter: row['chapter'] as int?,
                  verse: row['verse'] as int?,
                  book: row['book'] as int?,
                ),
            arguments: [qurey]);
  }

  @override
  Future<List<TajweedCharacters>> findAllTajweedChapter(
      int bookId, int chapter) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tajweed_charchter where book = ?1 and chapter = ?2',
        mapper: (Map<String, Object?> row) => TajweedCharacters(
              id: row['id'] as int?,
              chrachterText: row['charchter_text'] as String?,
              wordNumber: row['word_number'] as int?,
              wordText: row['word_text'] as String?,
              rule: row['rule'] as String?,
              verseNumber: row['verse_number'] as int?,
              characterText: row['character_text'] as String?,
              characterNumber: row['charachter_number'] as int?,
              ruleText: row['rule_text'] as String?,
              chapterNumber: row['chapter_number'] as int?,
              word: row['word'] as int?,
              chapter: row['chapter'] as int?,
              verse: row['verse'] as int?,
              book: row['book'] as int?,
            ),
        arguments: [bookId, chapter]);
  }

  @override
  Future<List<TajweedCharacters>> findAllTajweedVerse(
      int bookId, int verse) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tajweed_charchter where book = ?1 and verse = ?2',
        mapper: (Map<String, Object?> row) => TajweedCharacters(
              id: row['id'] as int?,
              chrachterText: row['charchter_text'] as String?,
              wordNumber: row['word_number'] as int?,
              wordText: row['word_text'] as String?,
              rule: row['rule'] as String?,
              verseNumber: row['verse_number'] as int?,
              characterText: row['character_text'] as String?,
              characterNumber: row['charachter_number'] as int?,
              ruleText: row['rule_text'] as String?,
              chapterNumber: row['chapter_number'] as int?,
              word: row['word'] as int?,
              chapter: row['chapter'] as int?,
              verse: row['verse'] as int?,
              book: row['book'] as int?,
            ),
        arguments: [bookId, verse]);
  }

  @override
  Future<List<TajweedCharacters>> findAllTajweedWord(
      int bookId, int word) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tajweed_charchter where book = ?1 and word = ?2',
        mapper: (Map<String, Object?> row) => TajweedCharacters(),
        arguments: [bookId, word]);
  }

  @override
  Future<List<TajweedCharacters>> findTajweedWordsInNarrationId(
      int bookId, int narrationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tajweed_charchter WHERE where book = ?1 and narration = ?2',
        mapper: (Map<String, Object?> row) => TajweedCharacters(),
        arguments: [bookId, narrationId]);
  }

  @override
  Stream<TajweedCharacters?> findTajweedWordById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM tajweed_charchter WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TajweedCharacters(),
        arguments: [id],
        queryableName: 'tajweed_charchter',
        isView: false);
  }

  @override
  Future<List<TajweedCharacters>> getSavedChaptersByBookId(int bookId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tajweed_charchter WHERE book = ?1 GROUP BY chapter',
        mapper: (Map<String, Object?> row) => TajweedCharacters(
              id: row['id'] as int?,
              chrachterText: row['charchter_text'] as String?,
              wordNumber: row['word_number'] as int?,
              wordText: row['word_text'] as String?,
              rule: row['rule'] as String?,
              verseNumber: row['verse_number'] as int?,
              characterText: row['character_text'] as String?,
              characterNumber: row['charachter_number'] as int?,
              ruleText: row['rule_text'] as String?,
              chapterNumber: row['chapter_number'] as int?,
              word: row['word'] as int?,
              chapter: row['chapter'] as int?,
              verse: row['verse'] as int?,
              book: row['book'] as int?,
            ),
        arguments: [bookId]);
  }

  @override
  Future<void> insertTajweedWord(TajweedCharacters tajweedWord) async {
    await _tajweedCharactersInsertionAdapter.insert(
        tajweedWord, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTajweedWord(TajweedCharacters tajweedWord) async {
    await _tajweedCharactersUpdateAdapter.update(
        tajweedWord, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTajweedWord(TajweedCharacters tajweedWord) async {
    await _tajweedCharactersDeletionAdapter.delete(tajweedWord);
  }
}

class _$TajweedDao extends TajweedDao {
  _$TajweedDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _tajweedBookInsertionAdapter = InsertionAdapter(
            database,
            'tajweed',
            (TajweedBook item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'author': item.author,
                  'narration': item.narration
                },
            changeListener),
        _tajweedBookUpdateAdapter = UpdateAdapter(
            database,
            'tajweed',
            ['id'],
            (TajweedBook item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'author': item.author,
                  'narration': item.narration
                },
            changeListener),
        _tajweedBookDeletionAdapter = DeletionAdapter(
            database,
            'tajweed',
            ['id'],
            (TajweedBook item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'author': item.author,
                  'narration': item.narration
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TajweedBook> _tajweedBookInsertionAdapter;

  final UpdateAdapter<TajweedBook> _tajweedBookUpdateAdapter;

  final DeletionAdapter<TajweedBook> _tajweedBookDeletionAdapter;

  @override
  Future<List<TajweedBook>> findAllTajweed() async {
    return _queryAdapter.queryList('SELECT * FROM tajweed',
        mapper: (Map<String, Object?> row) => TajweedBook(
            id: row['id'] as int?,
            name: row['name'] as String?,
            author: row['author'] as String?,
            narration: row['narration'] as int?));
  }

  @override
  Future<List<TajweedBook>> findAllTajweedQurey(
      String qurey, int narrationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tajweed WHERE narration = ?2 and name like ?1 or author like ?1',
        mapper: (Map<String, Object?> row) => TajweedBook(id: row['id'] as int?, name: row['name'] as String?, author: row['author'] as String?, narration: row['narration'] as int?),
        arguments: [qurey, narrationId]);
  }

  @override
  Future<List<TajweedBook>> searchInTajweeds(String qurey) async {
    return _queryAdapter.queryList(
        'SELECT * FROM tajweed WHERE name like ?1 or author like ?1',
        mapper: (Map<String, Object?> row) => TajweedBook(
            id: row['id'] as int?,
            name: row['name'] as String?,
            author: row['author'] as String?,
            narration: row['narration'] as int?),
        arguments: [qurey]);
  }

  @override
  Future<List<TajweedBook>> findTajweedInNarrationId(int narrationId) async {
    return _queryAdapter.queryList('SELECT * FROM tajweed WHERE narration = ?1',
        mapper: (Map<String, Object?> row) => TajweedBook(
            id: row['id'] as int?,
            name: row['name'] as String?,
            author: row['author'] as String?,
            narration: row['narration'] as int?),
        arguments: [narrationId]);
  }

  @override
  Stream<TajweedBook?> findTajweedById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM tajweed WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TajweedBook(
            id: row['id'] as int?,
            name: row['name'] as String?,
            author: row['author'] as String?,
            narration: row['narration'] as int?),
        arguments: [id],
        queryableName: 'tajweed',
        isView: false);
  }

  @override
  Future<void> insertTajweed(TajweedBook tajweedModel) async {
    await _tajweedBookInsertionAdapter.insert(
        tajweedModel, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTajweed(TajweedBook tajweedModel) async {
    await _tajweedBookUpdateAdapter.update(
        tajweedModel, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTajweed(TajweedBook tajweedModel) async {
    await _tajweedBookDeletionAdapter.delete(tajweedModel);
  }
}

class _$ExplanationDao extends ExplanationDao {
  _$ExplanationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _explanationInsertionAdapter = InsertionAdapter(
            database,
            'explanation',
            (Explanation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'narration': item.narration
                },
            changeListener),
        _explanationUpdateAdapter = UpdateAdapter(
            database,
            'explanation',
            ['id'],
            (Explanation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'narration': item.narration
                },
            changeListener),
        _explanationDeletionAdapter = DeletionAdapter(
            database,
            'explanation',
            ['id'],
            (Explanation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'narration': item.narration
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Explanation> _explanationInsertionAdapter;

  final UpdateAdapter<Explanation> _explanationUpdateAdapter;

  final DeletionAdapter<Explanation> _explanationDeletionAdapter;

  @override
  Future<List<Explanation>> findAllExplanation() async {
    return _queryAdapter.queryList('SELECT * FROM explanation',
        mapper: (Map<String, Object?> row) => Explanation(
            id: row['id'] as int?,
            name: row['name'] as String?,
            narration: row['narration'] as int?));
  }

  @override
  Future<List<Explanation>> searchInExplanation(String qurey) async {
    return _queryAdapter.queryList(
        'SELECT * FROM explanation WHERE name like ?1',
        mapper: (Map<String, Object?> row) => Explanation(
            id: row['id'] as int?,
            name: row['name'] as String?,
            narration: row['narration'] as int?),
        arguments: [qurey]);
  }

  @override
  Future<List<Explanation>> findExplanationsByNarrationId(
      int narrationId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM explanation WHERE narration = ?1',
        mapper: (Map<String, Object?> row) => Explanation(
            id: row['id'] as int?,
            name: row['name'] as String?,
            narration: row['narration'] as int?),
        arguments: [narrationId]);
  }

  @override
  Stream<Explanation?> findExplanationById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM explanation WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Explanation(
            id: row['id'] as int?,
            name: row['name'] as String?,
            narration: row['narration'] as int?),
        arguments: [id],
        queryableName: 'explanation',
        isView: false);
  }

  @override
  Future<void> insertExplanation(Explanation explanation) async {
    await _explanationInsertionAdapter.insert(
        explanation, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateExplanation(Explanation explanation) async {
    await _explanationUpdateAdapter.update(
        explanation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteExplanation(Explanation explanation) async {
    await _explanationDeletionAdapter.delete(explanation);
  }
}

class _$ExplanationVerseDao extends ExplanationVerseDao {
  _$ExplanationVerseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _explanationVerseInsertionAdapter = InsertionAdapter(
            database,
            'explanation_verse',
            (ExplanationVerse item) => <String, Object?>{
                  'id': item.id,
                  'explanation': item.explanation,
                  'text': item.text,
                  'verse_number': item.verseNumber,
                  'chapter_number': item.chapterNumber,
                  'page_number': item.pageNumber,
                  'verse': item.verse,
                  'chapter': item.chapter
                },
            changeListener),
        _explanationVerseUpdateAdapter = UpdateAdapter(
            database,
            'explanation_verse',
            ['id'],
            (ExplanationVerse item) => <String, Object?>{
                  'id': item.id,
                  'explanation': item.explanation,
                  'text': item.text,
                  'verse_number': item.verseNumber,
                  'chapter_number': item.chapterNumber,
                  'page_number': item.pageNumber,
                  'verse': item.verse,
                  'chapter': item.chapter
                },
            changeListener),
        _explanationVerseDeletionAdapter = DeletionAdapter(
            database,
            'explanation_verse',
            ['id'],
            (ExplanationVerse item) => <String, Object?>{
                  'id': item.id,
                  'explanation': item.explanation,
                  'text': item.text,
                  'verse_number': item.verseNumber,
                  'chapter_number': item.chapterNumber,
                  'page_number': item.pageNumber,
                  'verse': item.verse,
                  'chapter': item.chapter
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ExplanationVerse> _explanationVerseInsertionAdapter;

  final UpdateAdapter<ExplanationVerse> _explanationVerseUpdateAdapter;

  final DeletionAdapter<ExplanationVerse> _explanationVerseDeletionAdapter;

  @override
  Future<List<ExplanationVerse>> findAllExplanationVerse(
      int explanation) async {
    return _queryAdapter.queryList(
        'SELECT * FROM explanation_verse where explanation = ?1',
        mapper: (Map<String, Object?> row) => ExplanationVerse(
            id: row['id'] as int?,
            explanation: row['explanation'] as int?,
            text: row['text'] as String?,
            verseNumber: row['verse_number'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapter: row['chapter'] as int?,
            verse: row['verse'] as int?),
        arguments: [explanation]);
  }

  @override
  Future<List<ExplanationVerse>> searchInExplanationVerse(String qurey) async {
    return _queryAdapter.queryList(
        'SELECT * FROM explanation_verse WHERE text like ?1',
        mapper: (Map<String, Object?> row) => ExplanationVerse(
            id: row['id'] as int?,
            explanation: row['explanation'] as int?,
            text: row['text'] as String?,
            verseNumber: row['verse_number'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapter: row['chapter'] as int?,
            verse: row['verse'] as int?),
        arguments: [qurey]);
  }

  @override
  Future<List<ExplanationVerse>> findExplanationVersesFliterVerse(
      int verse) async {
    return _queryAdapter.queryList(
        'SELECT * FROM explanation_verse WHERE verse_number = ?1',
        mapper: (Map<String, Object?> row) => ExplanationVerse(
            id: row['id'] as int?,
            explanation: row['explanation'] as int?,
            text: row['text'] as String?,
            verseNumber: row['verse_number'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapter: row['chapter'] as int?,
            verse: row['verse'] as int?),
        arguments: [verse]);
  }

  @override
  Future<List<ExplanationVerse>> findExplanationVersesFliterChapter(
      int chapter) async {
    return _queryAdapter.queryList(
        'SELECT * FROM explanation_verse WHERE chapter = ?1',
        mapper: (Map<String, Object?> row) => ExplanationVerse(
            id: row['id'] as int?,
            explanation: row['explanation'] as int?,
            text: row['text'] as String?,
            verseNumber: row['verse_number'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapter: row['chapter'] as int?,
            verse: row['verse'] as int?),
        arguments: [chapter]);
  }

  @override
  Future<List<ExplanationVerse>> getSavedChaptersByBookId(int bookId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM explanation_verse WHERE explanation = ?1 GROUP BY chapter',
        mapper: (Map<String, Object?> row) => ExplanationVerse(id: row['id'] as int?, explanation: row['explanation'] as int?, text: row['text'] as String?, verseNumber: row['verse_number'] as int?, chapterNumber: row['chapter_number'] as int?, pageNumber: row['page_number'] as int?, chapter: row['chapter'] as int?, verse: row['verse'] as int?),
        arguments: [bookId]);
  }

  @override
  Future<List<ExplanationVerse>> findExplanationVersesFliterPage(
      int page) async {
    return _queryAdapter.queryList(
        'SELECT * FROM explanation_verse WHERE page_number = ?1',
        mapper: (Map<String, Object?> row) => ExplanationVerse(
            id: row['id'] as int?,
            explanation: row['explanation'] as int?,
            text: row['text'] as String?,
            verseNumber: row['verse_number'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapter: row['chapter'] as int?,
            verse: row['verse'] as int?),
        arguments: [page]);
  }

  @override
  Stream<ExplanationVerse?> findExplanationById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM explanation_verse WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ExplanationVerse(
            id: row['id'] as int?,
            explanation: row['explanation'] as int?,
            text: row['text'] as String?,
            verseNumber: row['verse_number'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapter: row['chapter'] as int?,
            verse: row['verse'] as int?),
        arguments: [id],
        queryableName: 'explanation_verse',
        isView: false);
  }

  @override
  Future<ExplanationVerse?> findExplanationVersesByVerse(int verse) async {
    return _queryAdapter.query(
        'SELECT * FROM explanation_verse WHERE verse = ?1',
        mapper: (Map<String, Object?> row) => ExplanationVerse(
            id: row['id'] as int?,
            explanation: row['explanation'] as int?,
            text: row['text'] as String?,
            verseNumber: row['verse_number'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            pageNumber: row['page_number'] as int?,
            chapter: row['chapter'] as int?,
            verse: row['verse'] as int?),
        arguments: [verse]);
  }

  @override
  Future<void> insertExplanationVerse(ExplanationVerse explanation) async {
    await _explanationVerseInsertionAdapter.insert(
        explanation, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateExplanationVerse(ExplanationVerse explanation) async {
    await _explanationVerseUpdateAdapter.update(
        explanation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteExplanationVerse(ExplanationVerse explanation) async {
    await _explanationVerseDeletionAdapter.delete(explanation);
  }
}

class _$TranslationDao extends TranslationDao {
  _$TranslationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _translationInsertionAdapter = InsertionAdapter(
            database,
            'translation',
            (Translation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'author': item.author,
                  'language': item.language
                },
            changeListener),
        _translationUpdateAdapter = UpdateAdapter(
            database,
            'translation',
            ['id'],
            (Translation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'author': item.author,
                  'language': item.language
                },
            changeListener),
        _translationDeletionAdapter = DeletionAdapter(
            database,
            'translation',
            ['id'],
            (Translation item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'author': item.author,
                  'language': item.language
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Translation> _translationInsertionAdapter;

  final UpdateAdapter<Translation> _translationUpdateAdapter;

  final DeletionAdapter<Translation> _translationDeletionAdapter;

  @override
  Future<List<Translation>> findAllTranslation() async {
    return _queryAdapter.queryList('SELECT * FROM translation',
        mapper: (Map<String, Object?> row) => Translation(
            id: row['id'] as int?,
            name: row['name'] as String?,
            author: row['author'] as String?,
            language: row['language'] as String?));
  }

  @override
  Stream<Translation?> findTranslationById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM translation WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Translation(
            id: row['id'] as int?,
            name: row['name'] as String?,
            author: row['author'] as String?,
            language: row['language'] as String?),
        arguments: [id],
        queryableName: 'translation',
        isView: false);
  }

  @override
  Future<void> insertTranslation(Translation translation) async {
    await _translationInsertionAdapter.insert(
        translation, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTranslation(Translation translation) async {
    await _translationUpdateAdapter.update(
        translation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTranslation(Translation translation) async {
    await _translationDeletionAdapter.delete(translation);
  }
}

class _$TranslationVerseDao extends TranslationVerseDao {
  _$TranslationVerseDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _translationVerseInsertionAdapter = InsertionAdapter(
            database,
            'translation_verse',
            (TranslationVerse item) => <String, Object?>{
                  'text': item.text,
                  'chapter': item.chapter,
                  'chapter_number': item.chapterNumber,
                  'verse_number': item.verseNumber,
                  'translation': item.translation
                },
            changeListener),
        _translationVerseUpdateAdapter = UpdateAdapter(
            database,
            'translation_verse',
            ['chapter_number', 'verse_number', 'translation'],
            (TranslationVerse item) => <String, Object?>{
                  'text': item.text,
                  'chapter': item.chapter,
                  'chapter_number': item.chapterNumber,
                  'verse_number': item.verseNumber,
                  'translation': item.translation
                },
            changeListener),
        _translationVerseDeletionAdapter = DeletionAdapter(
            database,
            'translation_verse',
            ['chapter_number', 'verse_number', 'translation'],
            (TranslationVerse item) => <String, Object?>{
                  'text': item.text,
                  'chapter': item.chapter,
                  'chapter_number': item.chapterNumber,
                  'verse_number': item.verseNumber,
                  'translation': item.translation
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TranslationVerse> _translationVerseInsertionAdapter;

  final UpdateAdapter<TranslationVerse> _translationVerseUpdateAdapter;

  final DeletionAdapter<TranslationVerse> _translationVerseDeletionAdapter;

  @override
  Future<List<TranslationVerse>> findAllTranslationVerses(
      int translation) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translation_verse where translation = ?1',
        mapper: (Map<String, Object?> row) => TranslationVerse(
            text: row['text'] as String?,
            chapter: row['chapter'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            verseNumber: row['verse_number'] as int?,
            translation: row['translation'] as int?),
        arguments: [translation]);
  }

  @override
  Stream<TranslationVerse?> findTranslationVerseById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM translation_verse WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TranslationVerse(
            text: row['text'] as String?,
            chapter: row['chapter'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            verseNumber: row['verse_number'] as int?,
            translation: row['translation'] as int?),
        arguments: [id],
        queryableName: 'translation_verse',
        isView: false);
  }

  @override
  Future<List<TranslationVerse>> findExplanationVersesFliterChapter(
      int chapter) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translation_verse WHERE chapter_number = ?1',
        mapper: (Map<String, Object?> row) => TranslationVerse(
            text: row['text'] as String?,
            chapter: row['chapter'] as int?,
            chapterNumber: row['chapter_number'] as int?,
            verseNumber: row['verse_number'] as int?,
            translation: row['translation'] as int?),
        arguments: [chapter]);
  }

  @override
  Future<List<TranslationVerse>> getSavedChaptersByBookId(int bookId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM translation_verse WHERE translation = ?1 GROUP BY chapter',
        mapper: (Map<String, Object?> row) => TranslationVerse(text: row['text'] as String?, chapter: row['chapter'] as int?, chapterNumber: row['chapter_number'] as int?, verseNumber: row['verse_number'] as int?, translation: row['translation'] as int?),
        arguments: [bookId]);
  }

  @override
  Future<TranslationVerse?> findTranslationVerseByVerseId(
      int translationId, int verseNumber, int chapterNumber) async {
    return _queryAdapter.query(
        'SELECT * FROM translation_verse WHERE translation = ?1 AND verse_number = ?2 AND chapter_number = ?3',
        mapper: (Map<String, Object?> row) => TranslationVerse(text: row['text'] as String?, chapter: row['chapter'] as int?, chapterNumber: row['chapter_number'] as int?, verseNumber: row['verse_number'] as int?, translation: row['translation'] as int?),
        arguments: [translationId, verseNumber, chapterNumber]);
  }

  @override
  Future<void> insertTranslationVerse(TranslationVerse translation) async {
    await _translationVerseInsertionAdapter.insert(
        translation, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertTranslationVerseList(
      List<TranslationVerse> tranList) async {
    await _translationVerseInsertionAdapter.insertList(
        tranList, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateTranslationVerse(TranslationVerse translation) async {
    await _translationVerseUpdateAdapter.update(
        translation, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTranslationVerse(TranslationVerse translation) async {
    await _translationVerseDeletionAdapter.delete(translation);
  }
}
