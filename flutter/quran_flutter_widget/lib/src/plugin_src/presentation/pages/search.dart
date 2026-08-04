import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/chapter_local_data_source.dart.dart';
import 'package:quran_widget_flutter/helper/debouncer.dart';
import 'package:quran_widget_flutter/model/search.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/src/plugin_src/business/search_cubit.dart';
import 'package:quran_widget_flutter/src/plugin_src/business/search_state.dart';
import 'package:quran_widget_flutter/src/plugin_src/presentation/widgets/chapter_search_result.dart';
import 'package:quran_widget_flutter/src/plugin_src/presentation/widgets/verse_search_result.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SearchQuran extends StatelessWidget {
  const SearchQuran({
    Key? key,
    required this.onTapVerse,
    required this.onTapChapter,
    this.locale,
  }) : super(key: key);
  final Function() onTapVerse;
  final Function() onTapChapter;
  final String? locale;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SearchCubit(),
        child: Search(
          onTapChapter: onTapChapter,
          onTapVerse: onTapVerse,
        ));
  }
}

class Search extends StatefulWidget {
  const Search({
    Key? key,
    required this.onTapVerse,
    required this.onTapChapter,
  }) : super(key: key);
  final Function() onTapVerse;
  final Function() onTapChapter;
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final SpeechToText _speechToText = SpeechToText();
  final TextEditingController _textEditingController = TextEditingController();
  double soundLevel = 1.0;
  String _lastWords = '';

  /// This has to happen only once per app
  void _initSpeech() async {
    await _speechToText.initialize(
      onError: (error) => print('error: $error'),
      onStatus: (status) => print('status: $status'),
    );
    var systemLocale = await _speechToText.systemLocale();
    _currentLocaleId = systemLocale?.localeId ?? '';
    localeNames = await _speechToText.locales();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      localeId: _currentLocaleId,
      onResult: _onSpeechResult,
      onSoundLevelChange: (soundLevel) {
        setState(() {
          this.soundLevel = soundLevel;
        });
      },
    );
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _textEditingController.text = _lastWords;
      debouncer.run(() {
        SearchCubit.get(context).search(_lastWords);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0.8, end: 1).animate(_controller);
  }

  void _switchLang(selectedVal) {
    _currentLocaleId = selectedVal;
    Navigator.pop(context);
    print(selectedVal);
  }

  String _currentLocaleId = '';
  List<LocaleName> localeNames = [];

  Debouncer debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (searchContext, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _textEditingController,
                  onChanged: (value) {
                    debouncer.run(() {
                      SearchCubit.get(searchContext).search(value);
                    });
                  },
                  onSubmitted: (value) {
                    debouncer.run(() {
                      SearchCubit.get(searchContext).search(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      splashColor: Colors.transparent,
                      onPressed: () {
                        _textEditingController.clear();
                      },
                    ),
                    suffixIcon: InkWell(
                      splashColor: Colors.transparent,
                      onLongPress: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ListView.builder(
                            itemCount: localeNames.length,
                            itemBuilder: (context, idx) => ListTile(
                              title: Text(localeNames[idx].name),
                              onTap: () =>
                                  _switchLang(localeNames[idx].localeId),
                              tileColor:
                                  _currentLocaleId == localeNames[idx].localeId
                                      ? Colors.blueAccent.withOpacity(0.2)
                                      : null,
                            ),
                          ),
                        );
                      },
                      onTap: () async {
                        setState(() {
                          if (_speechToText.isListening) {
                            _stopListening();
                            _controller.reverse();
                          } else {
                            _startListening();
                          }
                        });
                      },
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) => Transform.scale(
                          scale: _animation.value,
                          child: Icon(
                            Icons.mic,
                            size: ((soundLevel < 8 ? 8 : soundLevel) / 10) * 40,
                            color: _speechToText.isListening
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchStateLoading) {
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is SearchStateError) {
                      return const Center(
                        child: Text('try again later'),
                      );
                    } else if (state is SearchStateSuccess) {
                      return Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: state.searchResults.length,
                          itemBuilder: (context, index) {
                            if (state.searchResults[index].type ==
                                SearchType.chapter) {
                              return ChapterSearchResultWidget(
                                chapterSearchResult:
                                    state.searchResults[index].result,
                                onTap: () async {
                                  QuranCacheRepository.setLastPageNumber((state
                                          .searchResults[index]
                                          .result as ChapterSearchResult)
                                      .chapterMetaData[QuranCacheRepository
                                          .narrationSelectedId
                                          .toString()]!
                                      .fromPage);

                                  ChapterLocalDataSource()
                                      .fetchChapterByPageNumber((state
                                              .searchResults[index]
                                              .result as ChapterSearchResult)
                                          .chapterMetaData[QuranCacheRepository
                                              .narrationSelectedId
                                              .toString()]!
                                          .fromPage)
                                      .then((value) {
                                    QuranCacheRepository.setSelectedChapterId(
                                        value!.id!);
                                    QuranCacheRepository.setSelectedChapterName(
                                        value.name!);
                                    QuranCubit.get(context)
                                        .updateChapter(value);
                                  });
                                  widget.onTapChapter();
                                },
                              );
                            }
                            return VerseSearchResultWidget(
                              verseSearchResult:
                                  state.searchResults[index].result,
                              onTap: () async {
                                QuranCacheRepository.setLastPageNumber((state
                                        .searchResults[index]
                                        .result as VerseSearchResult)
                                    .pageNumber);
                                ChapterLocalDataSource()
                                    .fetchChapterById((state
                                            .searchResults[index]
                                            .result as VerseSearchResult)
                                        .chapter)
                                    .then((value) {
                                  QuranCacheRepository.setSelectedChapterId(
                                      value!.id!);
                                  QuranCacheRepository.setSelectedChapterName(
                                      value.name!);
                                  QuranCubit.get(context).updateChapter(value);
                                });
                                widget.onTapVerse();
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
