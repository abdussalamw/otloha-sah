import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/model/search.dart';

class ChapterSearchResultWidget extends StatelessWidget {
  const ChapterSearchResultWidget({
    Key? key,
    required this.chapterSearchResult,
    required this.onTap,
  }) : super(key: key);
  final ChapterSearchResult chapterSearchResult;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          '${chapterSearchResult.chapterNumber} ${chapterSearchResult.name}',
          style: const TextStyle(
            fontSize: 22,
            fontFamily: 'Hafs20',
          )),
      onTap: onTap,
    );
  }
}
