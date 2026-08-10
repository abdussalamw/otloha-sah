import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../data_source/cache_helper.dart';
import '../../../home/presentation/pages/home/home_page.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';

void _unzipIsolate(List<String> args) {
  final zipBytes = File(args[0]).readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(zipBytes);
  final targetDir = Directory(args[1]);
  if (!targetDir.existsSync()) {
    targetDir.createSync(recursive: true);
  }

  for (final file in archive) {
    if (file.isFile) {
      final flatName = file.name.split('/').last;
      if (flatName.isNotEmpty && (flatName.endsWith('.woff') || flatName.endsWith('.ttf'))) {
        File('${targetDir.path}/$flatName')
          ..createSync(recursive: true)
          ..writeAsBytesSync(file.content as List<int>);
      }
    }
  }
}

class SetupQuranPage extends StatefulWidget {
  static const routeName = '/setup_quran';

  const SetupQuranPage({Key? key}) : super(key: key);

  @override
  State<SetupQuranPage> createState() => _SetupQuranPageState();
}

class _SetupQuranPageState extends State<SetupQuranPage> {
  String _selectedLanguage = 'ar'; // 'ar' or 'en'
  bool _isDarkMode = false; // false = Light, true = Dark
  int _selectedNarration = 1; // 1 = Hafs, 2 = Warsh, 3 = Qaloon

  bool _isDownloading = false;
  double _progress = 0.0;
  String _statusText = 'جاري التهيئة...';

  final List<Map<String, dynamic>> _languages = [
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
  ];

  final List<Map<String, dynamic>> _narrations = [
    {
      'id': 1,
      'name': 'رواية حفص عن عاصم',
      'subtitle': '(ينصح به - يتطلب تنزيل ملفات الصفحات والخطوط)',
      'icon': Icons.menu_book_rounded,
    },
    {
      'id': 2,
      'name': 'رواية ورش عن نافع',
      'subtitle': '(نص عادي)',
      'icon': Icons.auto_stories_rounded,
    },
    {
      'id': 3,
      'name': 'رواية قالون عن نافع',
      'subtitle': '(نص عادي)',
      'icon': Icons.auto_stories_rounded,
    },
  ];

  Future<void> _startSetup() async {
    // 1. Apply Language
    try {
      await context.setLocale(Locale(_selectedLanguage));
    } catch (e) {
      debugPrint('Error setting locale: $e');
    }

    // 2. Apply Theme if changed
    try {
      if (ThemeCubit.isDark != _isDarkMode) {
        ThemeCubit.get(context).changeTheme();
      }
    } catch (e) {
      debugPrint('Error setting theme: $e');
    }

    // 3. Apply Narration
    if (_selectedNarration == 1) {
      await _downloadHafsResources();
    } else {
      await _finishSetup();
    }
  }

  Future<void> _downloadHafsResources() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
      _statusText = 'جاري تنزيل ملفات المصحف...';
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final fontsZipPath = '${dir.path}/quran_fonts_qfc4.zip';
      final dbPath = '${dir.path}/quran_hafs_data.db';
      final fontsDir = '${dir.path}/quran_fonts_qfc4';

      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 5),
      ));

      // 1. Download DB
      setState(() => _statusText = 'جاري تنزيل بيانات المصحف والتفسير...');
      await dio.download(
        'https://github.com/abdussalamw/otloha-sah/releases/download/v4.0-otloha-sah/quran_hafs_data.db',
        dbPath,
        onReceiveProgress: (count, total) {
          if (total > 0) {
            setState(() {
              _progress = (count / total) * 0.3; // 30% of total progress
            });
          }
        },
      );

      // 2. Download Fonts Zip
      setState(() =>
          _statusText = 'جاري تنزيل خطوط المصحف (قد يستغرق بعض الوقت)...');
      await dio.download(
        'https://github.com/abdussalamw/otloha-sah/releases/download/v4.0-otloha-sah/quran_fonts_qfc4.zip',
        fontsZipPath,
        onReceiveProgress: (count, total) {
          if (total > 0) {
            setState(() {
              _progress =
                  0.3 + ((count / total) * 0.5); // 50% of total progress
            });
          }
        },
      );

      // 3. Extract Fonts
      setState(() {
        _statusText = 'جاري فك ضغط وتثبيت الخطوط...';
        _progress = 0.85;
      });

      // Run extraction in background isolate
      await compute(_unzipIsolate, [fontsZipPath, fontsDir]);

      // Cleanup zip
      final zipFile = File(fontsZipPath);
      if (await zipFile.exists()) {
        await zipFile.delete();
      }

      setState(() => _progress = 1.0);
      await _finishSetup();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء التنزيل: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
      setState(() {
        _isDownloading = false;
        _statusText = 'حدث خطأ: ${e.toString()}';
      });
      debugPrint('Download error: $e');
    }
  }

  Future<void> _finishSetup() async {
    await CacheHelper.saveData(key: 'is_setup_completed', value: true);
    await CacheHelper.saveData(
        key: 'selected_narration_id', value: _selectedNarration);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('إعداد التطبيق والمصحف'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.primary,
        ),
        body: _isDownloading ? _buildDownloadingView() : _buildSelectionView(),
      ),
    );
  }

  Widget _buildSelectionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'مرحباً بك في اتلوها صح',
            style: AppTypography.h2Medium(color: AppColors.primaryDark),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'قم بضبط تفضيلاتك الأساسية لتبدأ رحلتك مع القرآن الكريم.',
            style:
                AppTypography.bodyMedium(color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: AppSpacing.lg),

          // SECTION 1: Language
          _buildSectionTitle(
              '1. اختر اللغة (Language)', Icons.language_rounded),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: _languages.map((lang) {
              final isSelected = _selectedLanguage == lang['code'];
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLanguage = lang['code'];
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.12)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(lang['flag'],
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 8),
                          Text(
                            lang['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // SECTION 2: Theme
          _buildSectionTitle('2. اختر المظهر (Theme)', Icons.palette_rounded),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _buildThemeCard(
                  title: 'مظهر فاتح',
                  icon: Icons.light_mode_rounded,
                  isSelected: !_isDarkMode,
                  onTap: () => setState(() => _isDarkMode = false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeCard(
                  title: 'مظهر داكن',
                  icon: Icons.dark_mode_rounded,
                  isSelected: _isDarkMode,
                  onTap: () => setState(() => _isDarkMode = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // SECTION 3: Narration
          _buildSectionTitle(
              '3. اختر الرواية (Narration)', Icons.menu_book_rounded),
          const SizedBox(height: AppSpacing.sm),
          ..._narrations.map((narration) {
            final isSelected = _selectedNarration == narration['id'];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedNarration = narration['id'];
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.white,
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              narration['name'],
                              style: AppTypography.bodyLarge(
                                      color: AppColors.textPrimaryLight)
                                  .copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              narration['subtitle'],
                              style: AppTypography.caption(
                                  color: AppColors.textSecondaryLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: AppSpacing.xl),

          // SUBMIT BUTTON
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _startSetup,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'البدء والمتابعة',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTypography.bodyLarge(color: AppColors.primaryDark).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primary.withOpacity(0.12) : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primary : Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadingView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSpacing.xl),
            Text(
              _statusText,
              style: AppTypography.bodyLarge(color: AppColors.textPrimaryLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${(_progress * 100).toInt()}%',
              style:
                  AppTypography.bodyMedium(color: AppColors.textSecondaryLight),
            ),
          ],
        ),
      ),
    );
  }
}
