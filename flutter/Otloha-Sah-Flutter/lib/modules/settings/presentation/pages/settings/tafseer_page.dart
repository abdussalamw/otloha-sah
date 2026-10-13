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

class TafseerPage extends StatefulWidget {
  const TafseerPage({super.key});

  static const routeName = '/settings/tafseer';

  @override
  State<TafseerPage> createState() => _TafseerPageState();
}

class _TafseerPageState extends State<TafseerPage> {
  String _selectedKey = 'arabic_mokhtasar';
  String _searchQuery = '';
  Map<String, bool> _downloadedMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final saved = CacheHelper.getData(key: 'selected_tafseer_key');
    if (saved is String && saved.isNotEmpty) {
      _selectedKey = saved;
    }

    final Map<String, bool> map = {};
    for (final edition in QuranEncService.tafseerEditions) {
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
    CacheHelper.saveData(key: 'selected_tafseer_key', value: edition.key);
    CacheHelper.saveData(key: 'tafsirSelectedName', value: edition.name);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اعتماد "${edition.name}" كتفسير افتراضي'),
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

    final filteredEditions = QuranEncService.tafseerEditions.where((e) {
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
              title: 'التفاسير المعتمدة',
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
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
                                            edition.languageName.isNotEmpty ? edition.languageName : 'العربية',
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
