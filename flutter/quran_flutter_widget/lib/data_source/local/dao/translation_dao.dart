import 'package:floor/floor.dart';
import 'package:quran_widget_flutter/model/translation.dart';

@dao
abstract class TranslationDao {
  @Query('SELECT * FROM translation ')
  Future<List<Translation>> findAllTranslation();

  @Query('SELECT * FROM translation WHERE id = :id')
  Stream<Translation?> findTranslationById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertTranslation(Translation translation);

  @update
  Future<void> updateTranslation(Translation translation);

  @delete
  Future<void> deleteTranslation(Translation translation);
}
