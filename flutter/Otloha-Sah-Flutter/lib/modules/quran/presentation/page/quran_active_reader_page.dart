import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../data_source/cache_helper.dart';
import '../../../settings/business_logic/narration/changenarration_cubit.dart';
import '../../../quran_hafs/presentation/pages/quran_hafs_page.dart';
import '../../../splash/presentation/page/setup_quran_page.dart';
import 'quran_bnb_page.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';

/// ودجت التبويب النشط للمصحف الشريف:
/// يوجّه المستخدم ديناميكياً وفورياً إلى:
/// 1. مصحف حفص عن عاصم (QuranHafsPage) بخطوط مجمع الملك فهد QCF4 عند اختيار رواية حفص (id == 1).
/// 2. مصحف ورش / قالون (QuranBNBPage) عند اختيار رواية ورش (id == 2) أو قالون (id == 3).
class QuranActiveReaderPage extends StatefulWidget {
  const QuranActiveReaderPage({super.key});

  @override
  State<QuranActiveReaderPage> createState() => _QuranActiveReaderPageState();
}

class _QuranActiveReaderPageState extends State<QuranActiveReaderPage> {
  bool _isCheckingFiles = true;
  bool _hafsFilesExist = false;

  @override
  void initState() {
    super.initState();
    _checkHafsFiles();
  }

  Future<void> _checkHafsFiles() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final dbFile = File('${dir.path}/quran_hafs_data.db');
      final fontsDir = Directory('${dir.path}/quran_fonts_qfc4');
      final exists = await dbFile.exists() && await fontsDir.exists();
      if (mounted) {
        setState(() {
          _hafsFilesExist = exists;
          _isCheckingFiles = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hafsFilesExist = false;
          _isCheckingFiles = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangenarrationCubit, ChangenarrationState>(
      listener: (context, state) {
        _checkHafsFiles();
      },
      builder: (context, state) {
        final narrationId = CacheHelper.getData(key: 'selected_narration_id') ?? 1;

        // رواية حفص عن عاصم (مصحف المدينة الملكي برسم مجمع الملك فهد QCF4)
        if (narrationId == 1) {
          if (_isCheckingFiles) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          if (!_hafsFilesExist) {
            return _buildDownloadHafsPrompt(context);
          }

          return const QuranHafsPage();
        }

        // رواية ورش عن نافع (id == 2) أو قالون عن نافع (id == 3)
        return const QuranBNBPage();
      },
    );
  }

  Widget _buildDownloadHafsPrompt(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 64,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'مصحف المدينة النبوية (رواية حفص)',
                  style: AppTypography.h3Bold(color: AppColors.textPrimaryLight),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'للقراءة برواية حفص بالرسم العثماني لمجمع الملك فهد، يلزم تنزيل بيانات المصحف والخطوط الملكية لتعمل بدون إنترنت.',
                  style: AppTypography.bodyMedium(color: AppColors.textSecondaryLight),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).pushNamed(SetupQuranPage.routeName);
                    _checkHafsFiles();
                  },
                  icon: const Icon(Icons.cloud_download_rounded, color: Colors.white),
                  label: const Text(
                    'تنزيل ملفات مصحف حفص الآن',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () {
                    CacheHelper.saveData(key: 'selected_narration_id', value: 2);
                    ChangenarrationCubit.get(context).notifyNarrationChanged();
                  },
                  child: Text(
                    'المتابعة برواية ورش مؤقتاً',
                    style: AppTypography.bodyMedium(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
