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
  const QuranTranslationLanguagePage({Key? key}) : super(key: key);

  static const routeName = '/settings/quranTranslationLanguage';

  @override
  _QuranTranslationLanguagePageState createState() =>
      _QuranTranslationLanguagePageState();
}

class _QuranTranslationLanguagePageState
    extends State<QuranTranslationLanguagePage> {
  String _selectedKey = 'english_saheeh';
  String _searchQuery = '';
  Map<String, bool> _downloadedMap = {};
  bool _isLoading = true;

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

    final Map<String, bool> map = {};
    for (final edition in QuranEncService.translationEditions) {
      map[edition.key] = await QuranEncService.instance.isEditionDownloaded(edition.key);
    }

    if (mounted) {
      setState(() {
        _downloadedMap = map;
        _isLoading = false;
      });
    }
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
    _loadState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredEditions = QuranEncService.translationEditions.where((e) {
      if (_searchQuery.isEmpty) return true;
      return e.name.contains(_searchQuery) || e.author.contains(_searchQuery);
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
              title: 'ترجمات معاني القرآن',
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: filteredEditions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
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
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isDark ? AppShadows.softCardDark : AppShadows.softCardLight,
                          ),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: edition.key,
                                    groupValue: _selectedKey,
                                    activeColor: AppColors.primary,
                                    onChanged: (_) => _onSelect(edition),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          edition.name,
                                          style: AppTypography.h3Medium().copyWith(
                                            color: isSelected ? AppColors.primary : null,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          edition.author,
                                          style: AppTypography.bodySmall(
                                            color: isDark ? Colors.white60 : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(AppRadius.sm),
                                      ),
                                      child: const Text(
                                        'المعتمد',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        isDownloaded ? Icons.cloud_done_rounded : Icons.cloud_download_outlined,
                                        size: 18,
                                        color: isDownloaded ? Colors.green : Colors.grey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isDownloaded
                                            ? 'منزل بالكامل أوفلاين'
                                            : 'متاح للتنزيل (~${edition.estimatedSizeMb.toStringAsFixed(1)} MB)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDownloaded ? Colors.green : Colors.grey.shade600,
                                          fontWeight: isDownloaded ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () => _openDownloadDialog(edition),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isDownloaded
                                          ? (isDark ? Colors.grey.shade800 : Colors.grey.shade200)
                                          : AppColors.primary,
                                      foregroundColor: isDownloaded
                                          ? (isDark ? Colors.white70 : Colors.black87)
                                          : Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppRadius.sm),
                                      ),
                                      elevation: 0,
                                    ),
                                    icon: Icon(
                                      isDownloaded ? Icons.delete_outline_rounded : Icons.download_rounded,
                                      size: 16,
                                    ),
                                    label: Text(
                                      isDownloaded ? 'إدارة التنزيل' : 'تنزيل أوفلاين',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
