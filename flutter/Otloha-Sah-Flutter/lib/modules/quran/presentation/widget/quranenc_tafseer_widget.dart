import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/data_source/remote/quranenc_service.dart';
import 'package:otloha_sah_flutter/modules/quran/presentation/widget/quranenc_download_dialog.dart';

class QuranEncTafseerWidget extends StatefulWidget {
  final int sura;
  final int aya;
  final String fallbackTafseer;
  final bool isTranslationMode;

  const QuranEncTafseerWidget({
    super.key,
    required this.sura,
    required this.aya,
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
    _selectedEditionKey = widget.isTranslationMode
        ? 'english_saheeh'
        : 'arabic_mokhtasar';
    _loadTafseer();
  }

  @override
  void didUpdateWidget(covariant QuranEncTafseerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sura != widget.sura || oldWidget.aya != widget.aya) {
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

  void _changeEdition(String newKey) {
    if (_selectedEditionKey == newKey) return;
    setState(() {
      _selectedEditionKey = newKey;
    });
    _loadTafseer();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredEditions = widget.isTranslationMode
        ? QuranEncService.availableEditions.where((e) => e.language != 'ar').toList()
        : QuranEncService.availableEditions.where((e) => e.language == 'ar').toList();

    final currentEdition = QuranEncService.availableEditions.firstWhere(
      (e) => e.key == _selectedEditionKey,
      orElse: () => QuranEncService.availableEditions.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Edition Selector & Download Badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filteredEditions.map((ed) {
                    final isSelected = ed.key == _selectedEditionKey;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: ChoiceChip(
                        label: Text(
                          ed.name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: isDark ? AppColors.surfaceDark : Colors.grey[100],
                        onSelected: (_) => _changeEdition(ed.key),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isDownloaded ? Icons.cloud_done_rounded : Icons.cloud_download_outlined,
                color: _isDownloaded ? Colors.green : AppColors.primary,
                size: 22,
              ),
              tooltip: _isDownloaded
                  ? 'تم تنزيل هذا التفسير محلياً'
                  : 'تنزيل هذا التفسير كاملاً بدون إنترنت (${currentEdition.estimatedSizeMb.toStringAsFixed(1)} MB)',
              onPressed: () {
                QuranEncDownloadDialog.show(
                  context,
                  currentEdition,
                  onCompleted: _loadTafseer,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),

        // Tafseer Content Text View
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                ),
        ),
      ],
    );
  }
}
