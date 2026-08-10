abstract class QuranHafsState {}

class QuranHafsInitial extends QuranHafsState {}

class QuranHafsLoading extends QuranHafsState {
  final int pageNumber;
  QuranHafsLoading(this.pageNumber);
}

class QuranHafsLoaded extends QuranHafsState {
  final int pageNumber;
  final List<dynamic> glyphs; // List<HafsGlyph>
  final List<dynamic> alignments; // List<HafsLineAlignment>
  final bool isBookmarked;

  QuranHafsLoaded({
    required this.pageNumber,
    required this.glyphs,
    required this.alignments,
    this.isBookmarked = false,
  });
}

class QuranHafsError extends QuranHafsState {
  final String message;
  QuranHafsError(this.message);
}
