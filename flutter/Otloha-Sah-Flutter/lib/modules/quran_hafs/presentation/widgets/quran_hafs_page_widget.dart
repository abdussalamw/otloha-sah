import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../business_logic/quran_hafs_cubit.dart';
import '../../business_logic/quran_hafs_state.dart';
import '../../data/quran_hafs_repository.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';

/// خط النسبة الافتراضي بين ارتفاع السطر وحجم الخط (line-height multiplier).
/// يُستخدم في TextStyle وفي حساب المساحة الرأسية معًا حتى يتطابق المحسوب مع المرسوم فعليًا.
const double _kLineHeightMultiplier = 1.5;

/// الحد الأدنى للمسافة بين كل سطرين مهما ضاقت الشاشة.
const double _kMinLineGap = 4.0;

/// هامش رأسي ثابت أعلى/أسفل كتلة الصفحة، بعيدًا عن الهيدر والشريط السفلي.
const double _kVerticalMargin = 12.0;

class QuranHafsPageWidget extends StatefulWidget {
  final int pageNumber;
  final Function(HafsGlyph)? onWordTap;

  const QuranHafsPageWidget({
    Key? key,
    required this.pageNumber,
    this.onWordTap,
  }) : super(key: key);

  @override
  State<QuranHafsPageWidget> createState() => _QuranHafsPageWidgetState();
}

class _QuranHafsPageWidgetState extends State<QuranHafsPageWidget> {
  late QuranHafsCubit _cubit;
  int? _selectedWordId;
  int? _selectedAyah;
  int? _selectedSura;

  @override
  void initState() {
    super.initState();
    _cubit = QuranHafsCubit();
    _cubit.loadPage(widget.pageNumber);
  }

  @override
  void didUpdateWidget(QuranHafsPageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageNumber != widget.pageNumber) {
      _cubit.loadPage(widget.pageNumber);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _onGlyphTap(HafsGlyph glyph) {
    setState(() {
      _selectedWordId = glyph.wordId;
      _selectedAyah = glyph.ayah;
      _selectedSura = glyph.sura;
    });
    if (widget.onWordTap != null) {
      widget.onWordTap!(glyph);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuranHafsCubit, QuranHafsState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is QuranHafsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is QuranHafsLoaded) {
          return _buildPage(state);
        } else if (state is QuranHafsError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// يقيس العرض الطبيعي لسطر كامل عند حجم خط مرجعي، لاستخدامه في معادلة
  /// حجم الخط المبنية على عرض الشاشة (البند 2 من المواصفة) — بدل نسبة ثابتة مخمَّنة.
  double _measureLineWidth(
    List<HafsGlyph> glyphs,
    String fontFamily,
    double referenceFontSize,
  ) {
    final text = glyphs.map((g) => g.code).join('');
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontFamily: fontFamily, fontSize: referenceFontSize),
      ),
      textDirection: TextDirection.rtl,
    )..layout();
    return painter.width;
  }

  Widget _buildPage(QuranHafsLoaded state) {
    // Group glyphs by line
    final Map<int, List<HafsGlyph>> linesMap = {};
    for (var glyph in state.glyphs as List<HafsGlyph>) {
      linesMap.putIfAbsent(glyph.line, () => []).add(glyph);
    }

    // Map alignments
    final Map<int, HafsLineAlignment> alignmentsMap = {};
    for (var align in state.alignments as List<HafsLineAlignment>) {
      alignmentsMap[align.line] = align;
    }

    final fontFamily = 'QCF4_${state.pageNumber.toString().padLeft(3, '0')}';

    // Sort line numbers 1 to 15
    final lineNumbers = linesMap.keys.toList()..sort();
    final int lineCount = lineNumbers.length;
    final bool isFullPage = lineCount >= 15;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color pageBackgroundColor = isDark ? Colors.black : Colors.white;
    final Color defaultTextColor = isDark ? Colors.white : Colors.black;

    return Container(
      color: pageBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth;
          final double availableHeight =
              constraints.maxHeight - (2 * _kVerticalMargin);

          // ── 1) حجم الخط المبني على العرض (معادلة العرض — البند 2) ──
          // نقيس أطول سطر "عادي" (باستثناء البسملة/اسم السورة، لأنها أقصر
          // طبيعيًا ومركزّة) عند حجم مرجعي، ثم نستنتج fontSize الذي يجعل
          // أعرض سطر يملأ العرض المتاح تمامًا دون خروج.
          const double referenceFontSize = 100.0;
          double maxRatio = 0.0;
          for (final lineNum in lineNumbers) {
            final glyphs = linesMap[lineNum]!;
            if (glyphs.isEmpty) continue;
            final int lineType = glyphs.first.type;
            final bool isSurahHeader = lineType == 6;
            final bool isBasmalah = lineType == 8;
            if (isSurahHeader || isBasmalah) continue; // لا تُحسب في مرجع العرض

            final width =
                _measureLineWidth(glyphs, fontFamily, referenceFontSize);
            final ratio = width / referenceFontSize;
            if (ratio > maxRatio) maxRatio = ratio;
          }
          double fontSize = maxRatio > 0
              ? availableWidth / maxRatio
              : availableWidth * 0.084; // احتياط إن كانت الصفحة كلها بسملة/عناوين

          // ── 2) دمج قيد الارتفاع دون كسر معادلة العرض (البند 4) ──
          // لا نستبدل fontSize بمعادلة ارتفاع منفصلة؛ فقط نقلّصه بأقل قدر
          // ممكن إن لزم، بحيث يبقى الحد الأدنى للتباعد (minLineGap) محفوظًا.
          if (lineCount > 0 && availableHeight > 0) {
            final double minRequiredHeight =
                (lineCount * fontSize * _kLineHeightMultiplier) +
                    ((lineCount - 1).clamp(0, lineCount) * _kMinLineGap);
            if (minRequiredHeight > availableHeight) {
              final double denom = (lineCount * _kLineHeightMultiplier);
              final double gapsTotal =
                  (lineCount - 1).clamp(0, lineCount) * _kMinLineGap;
              fontSize = ((availableHeight - gapsTotal) / denom)
                  .clamp(1.0, fontSize);
            }
          }

          final double naturalLineHeight = fontSize * _kLineHeightMultiplier;

          // ── 3) توزيع الفراغ الزائد كـ gap إضافي بين الأسطر (لا داخل TextStyle) ──
          double lineGap = _kMinLineGap;
          if (lineCount > 1) {
            final double totalNaturalHeight =
                lineCount * naturalLineHeight + (lineCount - 1) * _kMinLineGap;
            final double leftover = availableHeight - totalNaturalHeight;
            if (leftover > 0) {
              lineGap = _kMinLineGap + (leftover / (lineCount - 1));
            }
          }

          final List<Widget> lineWidgets = [];
          for (int i = 0; i < lineCount; i++) {
            final lineNum = lineNumbers[i];
            final glyphs = linesMap[lineNum]!;
            final alignment = alignmentsMap[lineNum];
            final bool isCentered = alignment?.centered == 1;

            if (glyphs.isEmpty) continue;

            final int lineType = glyphs.first.type;
            final bool isSurahHeader = lineType == 6;
            final bool isBasmalah = lineType == 8;

            Widget lineChild;

            if (isSurahHeader) {
              lineChild = Container(
                height: fontSize * 1.6,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/Name_Pattern_Final-02.svg',
                      width: double.infinity,
                      height: fontSize * 1.6,
                      fit: BoxFit.fill,
                      colorFilter: isDark
                          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : null,
                    ),
                    Text(
                      glyphs.map((g) => g.code).join(''),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'QCF4_BSML',
                        fontSize: fontSize,
                        height: 1.0,
                        color: defaultTextColor,
                      ),
                    ),
                  ],
                ),
              );
            } else if (isBasmalah) {
              lineChild = Center(
                child: Text(
                  glyphs.map((g) => g.code).join(''),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'QCF4_BSML',
                    fontSize: fontSize,
                    height: _kLineHeightMultiplier,
                    color: defaultTextColor,
                  ),
                ),
              );
            } else {
              // سطر عادي: نفس fontSize الموحّد لكل الصفحة، بلا FittedBox
              // (كان FittedBox لكل سطر يسبب تفاوت حجم فعلي بين الأسطر).
              lineChild = Row(
                textDirection: TextDirection.rtl,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: glyphs.map((glyph) {
                  final isSelected = _selectedAyah == glyph.ayah &&
                      _selectedSura == glyph.sura &&
                      glyph.ayah != 0;

                  Color glyphColor = defaultTextColor;
                  if (isSelected) {
                    glyphColor = AppColors.primary;
                  } else if (glyph.type == 2) {
                    glyphColor = AppColors.primary;
                  }

                  return GestureDetector(
                    onTap: () => _onGlyphTap(glyph),
                    child: Text(
                      glyph.code,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: fontSize,
                        height: _kLineHeightMultiplier,
                        color: glyphColor,
                      ),
                    ),
                  );
                }).toList(),
              );
              // نلف السطر بعرض كامل حتى يعمل MainAxisAlignment.start/center
              // بشكل صحيح ضمن عرض الصفحة الفعلي.
              lineChild = SizedBox(width: double.infinity, child: lineChild);
            }

            lineWidgets.add(lineChild);

            if (i < lineCount - 1) {
              lineWidgets.add(SizedBox(height: isFullPage ? lineGap : 8.0));
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: _kVerticalMargin),
            child: Column(
              mainAxisAlignment:
                  isFullPage ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: lineWidgets,
            ),
          );
        },
      ),
    );
  }
}