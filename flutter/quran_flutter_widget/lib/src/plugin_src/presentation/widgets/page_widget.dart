import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class PageWidget extends StatefulWidget {
  final List<Verse> verses;
  final Function(Verse verse) onLongPressed;
  final Function(Verse verse) onTap;
  final Verse? playingVerse;

  const PageWidget({
    Key? key,
    required this.verses,
    required this.onLongPressed,
    required this.onTap,
    this.playingVerse,
  }) : super(key: key);

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  late QuranCubit cubit;

  ArabicNumbers arabicNumber = ArabicNumbers();

  @override
  initState() {
    cubit = QuranCubit.get(context);
    cubit.onTapCallback = widget.onTap;
    cubit.onLongTapCallback = widget.onLongPressed;
    super.initState();
  }

  List<Verse> get verses => widget.verses;

  @override
  Widget build(BuildContext context) {
    cubit.playingVerse = widget.playingVerse;
    cubit.versesWidgets(widget.verses, context);

    return SizedBox(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      (MediaQuery.of(context).size.width > 500 ? 0.9 : 0.75),
                  child: Column(
                    mainAxisAlignment: cubit.currentPageNumber == 1 ||
                            cubit.currentPageNumber == 2
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: cubit.lines
                        .map(
                          (line) => Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: line.length > 1 ? 12 : 0),
                              child: Row(
                                mainAxisAlignment: line.length == 1 ||
                                        cubit.currentPageNumber == 1 ||
                                        cubit.currentPageNumber == 2 ||
                                        cubit.currentPageNumber >= 602
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceBetween,
                                children: line.map((word) => word).toList(),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 30,
                  child: Center(
                    child: AutoSizeText(
                      arabicNumber
                          .convert(QuranCubit.get(context).currentPageNumber),
                      // minFontSize: 28,
                      style: const TextStyle(
                        color: Color(0xFF3fc6f1),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//  QuranCubit.get(context).currentPageNumber
