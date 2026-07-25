import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/glyph.dart';

@dao
abstract class GlyphDao {
  @Query('SELECT * FROM Glyph')
  Future<List<Glyph>> findAllGlyphs();

  @Query('SELECT * FROM Glyph WHERE id = :id')
  Stream<Glyph?> findGlyphById(int id);

  @insert
  Future<void> insertGlyph(Glyph glyph);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertGlyphs(List<Glyph> glyph);

  @update
  Future<void> updateGlyph(Glyph glyph);

  @delete
  Future<void> deleteGlyph(Glyph glyph);
}
