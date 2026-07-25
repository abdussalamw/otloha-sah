import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_html/flutter_html.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/src/plugin_src/business/tafasir_cubit.dart';

class TafsirPage extends StatelessWidget {
  const TafsirPage({
    Key? key,
    this.onTap,
    this.onLongTap,
    required this.cubit,
    required this.onChapterChange,
    required this.isDark,
  }) : super(key: key);
  final Function(String data, bool isVerseSelected)? onTap;
  final Function(String data, bool isVerseSelected)? onLongTap;
  final QuranCubit cubit;
  final Function(Chapter chapter) onChapterChange;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    var cubit = QuranCubit.get(context);
    return BlocConsumer<QuranCubit, QuranState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is PagesFetchErrorState) {
          return Center(child: Text(state.error));
        }
        if (state is PagesFetchLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        return BlocProvider(
          create: (context) => TafasirCubit()..fetchVerseTafseer(),
          child: BlocBuilder<TafasirCubit, TafasirState>(
            builder: (context, tafsirState) =>
                BlocBuilder<QuranCubit, QuranState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: PageView.builder(
                    itemCount: cubit.getAllVerses.length,
                    controller: cubit.tafsirPageController ??
                        PageController(initialPage: 0),
                    onPageChanged: (index) =>
                        onPageChanged(index, context, cubit),
                    itemBuilder: (context, index) {
                      return ListView(
                        shrinkWrap: true,
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
                                      //color: Colors.black,
                                      fontSize: 25,
                                      fontFamily: 'Hafs20',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (tafsirState is TafasirVerseLoading)
                            const Center(child: CircularProgressIndicator()),
                          if (TafasirCubit.get(context).selectedTafasirVerse ==
                                  null &&
                              tafsirState is TafasirVerseFetchedState)
                            Center(
                              child: Text(
                                ' التفسير غير متاح حاليا',
                                style: TextStyle(
                                    color: isDark
                                        ? const Color.fromARGB(
                                            255, 143, 188, 255)
                                        : const Color(0xFF08226C),
                                    fontSize: 20),
                              ),
                            ),
                          if (tafsirState is TafasirVerseErrorState)
                            Center(
                                child: Text('تحقق من الاتصال بالانترنت',
                                    style: TextStyle(
                                      color: isDark
                                          ? const Color.fromARGB(
                                              255, 143, 188, 255)
                                          : const Color(0xFF08226C),
                                      fontSize: 16,
                                    ))),
                          if (TafasirCubit.get(context).selectedTafasirVerse !=
                                  null &&
                              tafsirState is TafasirVerseFetchedState)
                            Material(
                              //elevation: .5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Html(
                                  data: TafasirCubit.get(context)
                                          .selectedTafasirVerse
                                          ?.text ??
                                      '',
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  onPageChanged(int pageIdx, BuildContext context, QuranCubit cubit) {
    cubit.selectCurrentVerse(cubit.getAllVerses[pageIdx]);
    onChapterChange(cubit.currentChapter!);
    TafasirCubit.get(context).fetchVerseTafseer();
  }
}
