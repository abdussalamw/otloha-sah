import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:quran_widget_flutter/src/plugin_src/presentation/widgets/word_widget.dart';

/// حجم خط المصحف الثابت لجميع الصفحات — يمكن تعديله من مكان واحد
/// تم اختيار 18.5 لتحقيق مطابقة جيدة للمصحف على معظم أحجام الشاشات
const double kQuranFontSize = 18.5;

class PageWidget extends StatefulWidget {
  final List<Verse> verses;
  final Function(Verse verse) onLongPressed;
  final Function(Verse verse) onTap;
  final Function(Verse verse) onDoubleTap; // ─ مرحلة 3
  final Verse? playingVerse;

  const PageWidget({
    Key? key,
    required this.verses,
    required this.onLongPressed,
    required this.onTap,
    required this.onDoubleTap,
    this.playingVerse,
  }) : super(key: key);

  @override
  State<PageWidget> createState() => _PageWidgetState();
}

class _PageWidgetState extends State<PageWidget> {
  late QuranCubit cubit;

  ArabicNumbers arabicNumber = ArabicNumbers();

  @override
  void initState() {
    super.initState();
    cubit = QuranCubit.get(context);
    cubit.onTapCallback = widget.onTap;
    cubit.onLongTapCallback = widget.onLongPressed;
    // حساب ويجتات الكلمات مرة واحدة عند البناء الأول
    cubit.versesWidgets(widget.verses, context);
  }

  @override
  void didUpdateWidget(covariant PageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // نعيد الحساب فقط عند تغيير قائمة الآيات أو الآية المشغلة
    if (oldWidget.verses != widget.verses ||
        oldWidget.playingVerse != widget.playingVerse) {
      cubit.versesWidgets(widget.verses, context);
    }
    cubit.onTapCallback = widget.onTap;
    cubit.onLongTapCallback = widget.onLongPressed;
  }

  List<Verse> get verses => widget.verses;

  @override
  Widget build(BuildContext context) {
    cubit.playingVerse = widget.playingVerse;
    // ❗ versesWidgets لا تُستدعى هنا — تم نقلها إلى initState/didUpdateWidget

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
                              child: GestureDetector(
                                // ─── مرحلة 3: ضغطة مزدوجة لورش/قالون عبر السطر ───
                                onDoubleTap: () {
                                  // نحاول إيجاد آية في هذا السطر
                                  final firstWord = line
                                      .whereType<WordWidget>()
                                      .firstOrNull;
                                  // إذا وجدت WordWidget → نستخرج الآية منه
                                  if (firstWord?.word != null) {
                                    final verse = cubit.pages.values
                                        .expand((v) => v)
                                        .firstWhere(
                                          (v) => v.id == firstWord!.word!.verse,
                                          orElse: () => widget.verses.first,
                                        );
                                    widget.onDoubleTap(verse);
                                  } else if (widget.verses.isNotEmpty) {
                                    widget.onDoubleTap(widget.verses.first);
                                  }
                                },
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
