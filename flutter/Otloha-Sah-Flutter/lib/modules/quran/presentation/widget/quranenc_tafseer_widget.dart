import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/data_source/cache_helper.dart';
import 'package:otloha_sah_flutter/data_source/remote/quranenc_service.dart';
import 'package:otloha_sah_flutter/modules/quran/presentation/widget/quranenc_download_dialog.dart';
import 'package:otloha_sah_flutter/modules/settings/presentation/pages/settings/quran_translation_language_page.dart';
import 'package:otloha_sah_flutter/modules/settings/presentation/pages/settings/tafseer_page.dart';

class QuranEncTafseerWidget extends StatefulWidget {
  final int sura;
  final int aya;
  final String? verseText;
  final String fallbackTafseer;
  final bool isTranslationMode;

  const QuranEncTafseerWidget({
    super.key,
    required this.sura,
    required this.aya,
    this.verseText,
    required this.fallbackTafseer,
    this.isTranslationMode = false,
  });

  @override
  State<QuranEncTafseerWidget> createState() => _QuranEncTafseerWidgetState();
}

class _QuranEncTafseerWidgetState extends State<QuranEncTafseerWidget> {
  late String _selectedEditionKey;
  String? _tafseerText;
  bool _isLoading = true;
  bool _isDownloaded = false;

  @override
  void initState() {
    super.initState();
    _initEditionKey();
    _loadTafseer();
  }

  void _initEditionKey() {
    if (widget.isTranslationMode) {
      final saved = CacheHelper.getData(key: 'selected_translation_key');
      _selectedEditionKey = (saved is String && saved.isNotEmpty) ? saved : 'english_saheeh';
    } else {
      final saved = CacheHelper.getData(key: 'selected_tafseer_key');
      _selectedEditionKey = (saved is String && saved.isNotEmpty) ? saved : 'arabic_mokhtasar';
    }
  }

  @override
  void didUpdateWidget(covariant QuranEncTafseerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sura != widget.sura || oldWidget.aya != widget.aya || oldWidget.isTranslationMode != widget.isTranslationMode) {
      _initEditionKey();
      _loadTafseer();
    }
  }

  void _loadTafseer() async {
    setState(() => _isLoading = true);

    final downloaded = await QuranEncService.instance.isEditionDownloaded(_selectedEditionKey);
    final text = await QuranEncService.instance.getAyaTafseer(
      editionKey: _selectedEditionKey,
      sura: widget.sura,
      aya: widget.aya,
    );

    if (mounted) {
      setState(() {
        _isDownloaded = downloaded;
        _tafseerText = text ?? (widget.isTranslationMode ? 'الترجمة غير متوفرة حالياً بدون إنترنت' : widget.fallbackTafseer);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentEdition = QuranEncService.availableEditions.firstWhere(
      (e) => e.key == _selectedEditionKey,
      orElse: () => widget.isTranslationMode
          ? QuranEncService.translationEditions.first
          : QuranEncService.tafseerEditions.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // شريط معلومات مدمج وخفيف جداً مع زر التنزيل والإعدادات
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Row(
            children: [
              Icon(
                widget.isTranslationMode ? Icons.translate_rounded : Icons.menu_book_rounded,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${currentEdition.name} (${currentEdition.author})',
                  style: AppTypography.caption(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ).copyWith(fontWeight: FontWeight.bold, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // أيقونة التنزيل وحالة الأوفلاين
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: Icon(
                  _isDownloaded ? Icons.cloud_done_rounded : Icons.cloud_download_outlined,
                  color: _isDownloaded ? Colors.green : AppColors.primary,
                  size: 20,
                ),
                tooltip: _isDownloaded
                    ? 'منزل أوفلاين'
                    : 'تنزيل أوفلاين (${currentEdition.estimatedSizeMb.toStringAsFixed(1)} MB)',
                onPressed: () {
                  QuranEncDownloadDialog.show(
                    context,
                    currentEdition,
                    onCompleted: _loadTafseer,
                  );
                },
              ),
              const SizedBox(width: 4),
              // زر سريع لفتح الإعدادات واختيار إصدار آخر
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                icon: const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                tooltip: 'تغيير الإصدار الافتراضي من الإعدادات',
                onPressed: () async {
                  final route = widget.isTranslationMode
                      ? QuranTranslationLanguagePage.routeName
                      : TafseerPage.routeName;
                  await Navigator.of(context).pushNamed(route);
                  if (mounted) {
                    _initEditionKey();
                    _loadTafseer();
                  }
                },
              ),
            ],
          ),
        ),

        // عرض نص الآية أولاً ثم التفسير أو الترجمة
        Expanded(
          child: _isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // نص الآية الكريمة نصاً في الأعلى
                      if (widget.verseText != null && widget.verseText!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Text(
                            '﴿ ${widget.verseText!} ﴾',
                            style: const TextStyle(
                              fontFamily: 'Hafs20',
                              fontSize: 18,
                              height: 1.8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                          ),
                        ),

                      // نص التفسير أو الترجمة
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          _tafseerText ?? widget.fallbackTafseer,
                          style: AppTypography.bodyMedium(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ).copyWith(
                            height: 1.8,
                            fontSize: 15,
                            fontFamily: widget.isTranslationMode ? null : 'Cairo',
                          ),
                          textDirection: widget.isTranslationMode ? TextDirection.ltr : TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
