import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/data_source/local/dao/chapter_dao.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/chapter_local_data_source.dart.dart';
import 'package:quran_widget_flutter/model/chapter.dart';
import 'package:quran_widget_flutter/model/search.dart';

class VerseSearchResultWidget extends StatelessWidget {
  final VerseSearchResult verseSearchResult;
  final Function() onTap;

  const VerseSearchResultWidget({
    Key? key,
    required this.verseSearchResult,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            verseSearchResult.text,
            style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Hafs20',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder<Chapter?>(
                future: ChapterLocalDataSource()
                    .fetchChapterById(verseSearchResult.chapter),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Text(
                      snapshot.data!.name!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Hafs20',
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              Text(verseSearchResult.pageNumber.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
