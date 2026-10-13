import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_shadows.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/data_source/cache_helper.dart';
import 'package:otloha_sah_flutter/data_source/remote/quranenc_service.dart';
import 'package:otloha_sah_flutter/modules/quran/presentation/widget/quranenc_download_dialog.dart';
import 'package:otloha_sah_flutter/modules/settings/presentation/widgets/search_bar_app.dart';

class QuranTranslationLanguagePage extends StatefulWidget {
  const QuranTranslationLanguagePage({super.key});

  static const routeName = '/settings/quranTranslationLanguage';

  @override
  State<QuranTranslationLanguagePage> createState() =>
      _QuranTranslationLanguagePageState();
}

class _QuranTranslationLanguagePageState
    extends State<QuranTranslationLanguagePage> {
  String _selectedKey = 'english_saheeh';
  String _searchQuery = '';
  String _selectedLanguageCode = 'all';
  Map<String, bool> _downloadedMap = {};
  bool _isLoading = true;

  static const List<Map<String, String>> _popularLanguages = [
    {'code': 'all', 'name': 'جميع اللغات'},
    {'code': 'en', 'name': 'الإنجليزية'},
    {'code': 'fr', 'name': 'الفرنسية'},
    {'code': 'es', 'name': 'الإسبانية'},
    {'code': 'tr', 'name': 'التركية'},
    {'code': 'ur', 'name': 'الأردية'},
    {'code': 'id', 'name': 'الإندونيسية'},
    {'code': 'de', 'name': 'الألمانية'},
    {'code': 'zh', 'name': 'الصينية'},
    {'code': 'fa', 'name': 'الفارسية'},
    {'code': 'ru', 'name': 'الروسية'},
    {'code': 'sw', 'name': 'السواحيلية'},
  ];

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final saved = CacheHelper.getData(key: 'selected_translation_key');
    if (saved is String && saved.isNotEmpty) {
      _selectedKey = saved;
    }

    // 1. عرض البيانات المحلية فوراً وبدون أي انتظار
    await _refreshDownloadedMap();

    if (mounted) {
      setState(() => _isLoading = false);
    }

    // 2. محاولة تحديث القائمة عن بعد في الخلفية
    try {
      await QuranEncService.instance.fetchRemoteTranslationsList();
      await _refreshDownloadedMap();
      if (mounted) setState(() {});
    } catch (_) {}
  }

  Future<void> _refreshDownloadedMap() async {
    final Map<String, bool> map = {};
    for (final edition in QuranEncService.translationEditions) {
      map[edition.key] = await QuranEncService.instance.isEditionDownloaded(edition.key);
    }
    _downloadedMap = map;
  }

  void _onSelect(QuranEncEdition edition) {
    setState(() => _selectedKey = edition.key);
    CacheHelper.saveData(key: 'selected_translation_key', value: edition.key);
    CacheHelper.saveData(key: 'quranTranslationSelectedName', value: edition.name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اعتماد "${edition.name}" كترجمة معتمدة'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _openDownloadDialog(QuranEncEdition edition) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => QuranEncDownloadDialog(edition: edition),
    );
    await _refreshDownloadedMap();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final allEditions = QuranEncService.translationEditions;
    final filteredEditions = allEditions.where((e) {
      if (_selectedLanguageCode != 'all' && e.language != _selectedLanguageCode) {
        return false;
      }
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return e.name.toLowerCase().contains(q) ||
          e.author.toLowerCase().contains(q) ||
          e.languageName.toLowerCase().contains(q) ||
          e.language.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            SearchBarApp(
              backIcon: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
              onSearch: (val) {
                setState(() => _searchQuery = val.trim());
              },
              title: 'ترجمات معاني القرآن الكريم',
            ),

            // شريط فلترة اللغات الشهيرة وإجمالي الترجمات
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${filteredEditions.length} ترجمة متاحة (${allEditions.length} في 56 لغة)',
                        style: AppTypography.caption(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      if (_selectedLanguageCode != 'all' || _searchQuery.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedLanguageCode = 'all';
                              _searchQuery = '';
                            });
                          },
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: const Text('إعادة الضبط', style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _popularLanguages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final lang = _popularLanguages[index];
                        final isSelected = _selectedLanguageCode == lang['code'];
                        return FilterChip(
                          label: Text(lang['name']!),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedLanguageCode = lang['code']!);
                          },
                          selectedColor: AppColors.primary,
                          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            side: BorderSide(
                              color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
                            ),
                          ),
                          showCheckmark: false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 8),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredEditions.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'لا توجد نتائج مطابقة للبحث',
                                style: AppTypography.bodyMedium(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: filteredEditions.length,
                          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                          itemBuilder: (context, index) {
                            final edition = filteredEditions[index];
                            final isSelected = edition.key == _selectedKey;
                            final isDownloaded = _downloadedMap[edition.key] ?? false;

                            return Container(
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                                  width: isSelected ? 1.5 : 1,
                                ),
                                boxShadow: isDark ? AppShadows.softCardDark : AppShadows.softCardLight,
                              ),
                              child: InkWell(
                                onTap: () => _onSelect(edition),
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                        value: edition.key,
                                        groupValue: _selectedKey,
                                        activeColor: AppColors.primary,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        onChanged: (_) => _onSelect(edition),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                edition.name,
                                                style: AppTypography.bodyMedium().copyWith(
                                                  color: isSelected ? AppColors.primary : null,
                                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary.withValues(alpha: 0.08),
                                                borderRadius: BorderRadius.circular(AppRadius.xs),
                                              ),
                                              child: Text(
                                                edition.languageName.isNotEmpty
                                                    ? edition.languageName
                                                    : edition.language.toUpperCase(),
                                                style: const TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            if (isSelected) ...[
                                              const SizedBox(width: 4),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.green.withValues(alpha: 0.12),
                                                  borderRadius: BorderRadius.circular(AppRadius.xs),
                                                ),
                                                child: const Text(
                                                  'المعتمد',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
                                          borderRadius: BorderRadius.circular(AppRadius.xs),
                                        ),
                                        child: Text(
                                          '${edition.estimatedSizeMb.toStringAsFixed(1)} MB',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark ? Colors.white70 : Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        onPressed: () => _openDownloadDialog(edition),
                                        icon: Icon(
                                          isDownloaded ? Icons.cloud_done_rounded : Icons.cloud_download_outlined,
                                          color: isDownloaded ? Colors.green : AppColors.primary,
                                          size: 22,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                        tooltip: isDownloaded ? 'منزل (إدارة / حذف)' : 'تنزيل أوفلاين',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
