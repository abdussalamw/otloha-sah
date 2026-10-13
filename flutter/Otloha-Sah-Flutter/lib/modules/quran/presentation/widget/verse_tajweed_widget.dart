import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_shadows.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/modules/quran_hafs/data/quran_hafs_metadata.dart';
import 'package:otloha_sah_flutter/modules/quran_hafs/data/quran_hafs_repository.dart';
import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import 'package:quran_widget_flutter/data_source/data_source.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/tajweed_local_data_source.dart';
import 'package:quran_widget_flutter/data_source/repository/tajweed_repository.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:quran_widget_flutter/model/word_tajweed.dart';

class VerseTajweedWidget extends StatefulWidget {
  final int sura;
  final int aya;

  const VerseTajweedWidget({
    Key? key,
    required this.sura,
    required this.aya,
  }) : super(key: key);

  @override
  State<VerseTajweedWidget> createState() => _VerseTajweedWidgetState();
}

class _VerseTajweedWidgetState extends State<VerseTajweedWidget> {
  bool _isLoading = true;
  String _verseText = '';
  List<TajweedCharacters> _tajweedRules = [];
  String? _selectedWord;

  @override
  void initState() {
    super.initState();
    _loadTajweedData();
  }

  @override
  void didUpdateWidget(covariant VerseTajweedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sura != widget.sura || oldWidget.aya != widget.aya) {
      _selectedWord = null;
      _loadTajweedData();
    }
  }

  Future<void> _loadTajweedData() async {
    setState(() => _isLoading = true);

    try {
      // 1. Fetch verse text (from Hafs repository or general DataSource)
      final hafsTafseer = await QuranHafsRepository.getTafseer(widget.sura, widget.aya);
      if (hafsTafseer != null && hafsTafseer.ayaText.isNotEmpty) {
        _verseText = hafsTafseer.ayaText;
      }

      // 2. Fetch tajweed rules from local DB or repository
      final bookId = QuranCacheRepository.selectedTajweedId ?? 1;
      final localSource = TajweedLocalDataSource();
      List<TajweedCharacters>? rules = await localSource.findAllTajweedCharacters(
        bookId,
        chapterNumber: widget.sura,
        verseNumber: widget.aya,
      );

      if (rules == null || rules.isEmpty) {
        // Try fallback via Verse lookup
        try {
          final verses = await DataSource.instance.fetchVersesList(chapterNumber: widget.sura);
          final verse = verses.firstWhere(
            (v) => v.verseNumber == widget.aya,
            orElse: () => Verse(),
          );

          if (_verseText.isEmpty && verse.text != null) {
            _verseText = verse.uthmanicText ?? verse.text ?? '';
          }

          if (verse.id != null) {
            final repo = TajweedRepository();
            rules = await repo.fetchTajweedCharactersByVerseList(verseId: verse.id!);
          }
        } catch (_) {}
      }

      if (mounted) {
        setState(() {
          _tajweedRules = rules ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _tajweedRules = [];
          _isLoading = false;
        });
      }
    }
  }

  Color _getRuleBadgeColor(String rule) {
    final r = rule.trim().toLowerCase();
    if (r.contains('إدغام') || r.contains('ادغام') || r.contains('idgham')) {
      return const Color(0xFF2E7D32); // Deep emerald green
    } else if (r.contains('إخفاء') || r.contains('اخفاء') || r.contains('ikhfa')) {
      return const Color(0xFFD84315); // Deep orange / amber
    } else if (r.contains('إقلاب') || r.contains('اقلاب') || r.contains('iqlab')) {
      return const Color(0xFFF57F17); // Golden yellow
    } else if (r.contains('مد') || r.contains('madd')) {
      return const Color(0xFF6A1B9A); // Deep purple
    } else if (r.contains('قلقلة') || r.contains('qalqala')) {
      return const Color(0xFF1565C0); // Royal blue
    } else if (r.contains('إظهار') || r.contains('اظهار') || r.contains('ithhar')) {
      return const Color(0xFF00695C); // Teal
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // 1. Ayah Card Header
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.school_rounded, color: AppColors.primary, size: 22),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'أحكام التجويد للآية',
                        style: AppTypography.h3Medium(color: AppColors.primary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      'سورة ${QuranHafsMetadata.getSuraName(widget.sura)} - آية ${widget.aya}',
                      style: AppTypography.caption(color: AppColors.primary).copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Verse Arabic Text
              if (_verseText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : const Color(0xFFFBF8F2),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFEADBCE),
                    ),
                  ),
                  child: Text(
                    _verseText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Hafs',
                      fontSize: 22,
                      height: 2.0,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // 2. Rules Count & Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _tajweedRules.isEmpty ? 'الأحكام التطبيقية' : 'الأحكام المسجلة (${_tajweedRules.length})',
              style: AppTypography.bodyLarge(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            if (_tajweedRules.isNotEmpty)
              Text(
                'انقر على الحكم لإبرازه',
                style: AppTypography.caption(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // 3. Tajweed Rules List or Empty State
        if (_tajweedRules.isEmpty)
          AppCard(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
              child: Column(
                children: [
                  Icon(
                    Icons.auto_stories_rounded,
                    size: 48,
                    color: isDark ? Colors.white38 : Colors.grey.shade400,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'أحكام التجويد في هذه الآية جارية بالأصل الطبيعي',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'تُقرأ الآية الكريمة بأحكام التلاوة القياسية ومخارج الحروف المعتادة، أو يمكنك مراجعة كتاب التجويد من الإعدادات.',
                    textAlign: TextAlign.center,
                    style: AppTypography.caption(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ..._tajweedRules.map((rule) {
            final ruleName = (rule.ruleText?.isNotEmpty == true) ? rule.ruleText! : (rule.rule ?? 'حكم تجويدي');
            final wordName = (rule.wordText?.isNotEmpty == true) ? rule.wordText! : (rule.characterText ?? '');
            final badgeColor = _getRuleBadgeColor(ruleName);
            final isSelected = _selectedWord == wordName;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedWord = isSelected ? null : wordName;
                  });
                },
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? badgeColor.withOpacity(0.12)
                        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                      color: isSelected ? badgeColor : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: AppShadows.softCardLight,
                  ),
                  child: Row(
                    children: [
                      // Rule Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          ruleName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),

                      // Word / Target Char
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (wordName.isNotEmpty)
                              Text(
                                'الكلمة: $wordName',
                                style: AppTypography.bodyMedium(
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                            if (rule.characterText != null && rule.characterText!.isNotEmpty)
                              Text(
                                'الحرف: ${rule.characterText}',
                                style: AppTypography.caption(
                                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                ),
                              ),
                          ],
                        ),
                      ),

                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.chevron_left_rounded,
                        color: isSelected ? badgeColor : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
