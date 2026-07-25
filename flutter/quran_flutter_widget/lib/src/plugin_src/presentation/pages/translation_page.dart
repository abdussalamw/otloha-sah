import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/src/plugin_src/business/targama_cubit.dart';

import '../../../../quran_widget_flutter.dart';

class TranslationPage extends StatelessWidget {
  const TranslationPage({
    Key? key,
    this.onTap,
    this.onLongTap,
    required this.cubit,
    required this.onChapterChange,
    required this.isDark,
  }) : super(key: key);

  final offset1 = const Offset(50, 200);
  final offset2 = const Offset(50, 300);

  final Function(String data, bool isVerseSelected)? onTap;
  final Function(String data, bool isVerseSelected)? onLongTap;
  final QuranCubit cubit;
  final Function(Chapter chapter) onChapterChange;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    var cubit = QuranCubit.get(context);
    return BlocProvider(
      create: (context) => TargamaCubit()..fetchVerseTargama(),
      child: BlocBuilder<TargamaCubit, TargamaState>(
        builder: (context, translationState) {
          return BlocBuilder<QuranCubit, QuranState>(
            builder: (context, state) {
              return Padding(
                  padding: const EdgeInsets.all(20),
                  child: PageView.builder(
                    itemCount: cubit.getAllVerses.length,
                    controller: cubit.translationPageController ??
                        PageController(initialPage: 0),
                    onPageChanged: (index) => onPageChanged(index, context),
                    itemBuilder: (context, index) {
                      return ListView(
                        shrinkWrap: true,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Material(
                              elevation: 0.5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                // height: 100,
                                padding: const EdgeInsets.all(8),
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white10,
                                ),
                                child: Center(
                                  child: Text(
                                    cubit.getAllVerses[index].text!,
                                    style: const TextStyle(
                                      //  color: Colors.black,
                                      fontSize: 25,
                                      fontFamily: 'Hafs20',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (translationState is TargamaVerseLoading)
                            const Center(child: CircularProgressIndicator()),
                          if (translationState is TargamaVerseErrorState)
                            Center(
                                child: Text(
                              'تحقق من الاتصال بالانترنت',
                              style: TextStyle(
                                color: isDark
                                    ? const Color.fromARGB(255, 143, 188, 255)
                                    : const Color(0xFF08226C),
                                fontSize: 16,
                              ),
                            )),
                          if (TargamaCubit.get(context).selectedTargamaVerse ==
                                  null &&
                              translationState is TargamaVerseFetchedState)
                            Center(
                              child: Text(
                                ' الترجمه غير متاحه حاليا',
                                style: TextStyle(
                                  color: isDark
                                      ? const Color.fromARGB(255, 143, 188, 255)
                                      : const Color(0xFF08226C),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          if (TargamaCubit.get(context).selectedTargamaVerse !=
                                  null &&
                              translationState is TargamaVerseFetchedState)
                            Material(
                              // elevation: .5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                // height: 100,
                                padding: const EdgeInsets.all(12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: AutoSizeText(
                                  TargamaCubit.get(context)
                                          .selectedTargamaVerse
                                          ?.text ??
                                      '',
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color.fromARGB(
                                            255, 143, 188, 255)
                                        : const Color(0xFF08226C),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ));
            },
          );
        },
      ),
    );
  }

  void onPageChanged(int pageIdx, BuildContext context) {
    cubit.selectCurrentVerse(cubit.getAllVerses[pageIdx]);
    onChapterChange(cubit.currentChapter!);
    TargamaCubit.get(context).fetchVerseTargama();
  }
}
