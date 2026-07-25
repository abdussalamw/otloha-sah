import 'package:quran_widget_flutter/model/chapter.dart';
import 'package:quran_widget_flutter/model/narration.dart';
import 'package:quran_widget_flutter/model/verse.dart';

class RecitationQuranMetaData {
  final Chapter? chapter;
  final List<Verse>? verses;
  final Narration? narration;

  RecitationQuranMetaData(this.chapter, this.verses, this.narration);
}
