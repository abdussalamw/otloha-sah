import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/chapter.dart';

@dao
abstract class ChapterDao {
  @Query('SELECT * FROM Chapter')
  Future<List<Chapter>> findAllChapters();

  @Query('SELECT * FROM Chapter WHERE id = :id')
  Future<Chapter?> findChapterById(int id);

  @Query('SELECT * FROM Chapter WHERE name like :qurey')
  Future<List<Chapter>> searchInChapter(String qurey);

  @Query("""SELECT  *,  COUNT(*) as number_of_verses 
FROM Chapter
LEFT JOIN Verse  ON Verse.chapter = Chapter.id 
LEFT JOIN Page ON Verse.page = Page.id AND Page.chapter = Chapter.id
WHERE narration = 1 
ORDER BY  Chapter.chapter_number  ASC,  'verses.page_number' ASC,      'verses.verse_number'  ASC;
""")
  Future<List<Chapter>> getChapters();

  @Query(
      'SELECT * FROM Chapter WHERE from_page <= :pageNumber AND to_page >= :pageNumber LIMIT 1')
  Future<Chapter?> getChapterByPageNumber(int pageNumber);
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertChapter(Chapter chapter);

  @update
  Future<void> updateChapter(Chapter chapter);

  @delete
  Future<void> deleteChapter(Chapter chapter);
}
