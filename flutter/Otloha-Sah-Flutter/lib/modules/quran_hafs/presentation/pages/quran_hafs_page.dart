import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../quran/presentation/page/action_pages/bookmark_bage.dart';
import '../../../home/presentation/pages/bnb_pags/search_bnb_page.dart';
import '../../../quran/presentation/page/chapters/index_surah_page.dart';
import '../../../../../data_source/cache_helper.dart';
import '../../business_logic/quran_hafs_cubit.dart';
import '../../business_logic/quran_hafs_state.dart';
import '../../data/quran_hafs_repository.dart';
import '../../data/quran_hafs_metadata.dart';
import '../widgets/quran_hafs_page_widget.dart';
import '../../../quran/presentation/widget/quranenc_tafseer_widget.dart';

class QuranHafsPage extends StatefulWidget {
  static const routeName = '/quran_hafs';

  const QuranHafsPage({super.key});

  @override
  State<QuranHafsPage> createState() => _QuranHafsPageState();
}

class _QuranHafsPageState extends State<QuranHafsPage> {
  late PageController _pageController;
  late QuranHafsCubit _cubit;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    int initPage = CacheHelper.getData(key: 'hafs_initial_page') ?? 1;
    _currentPage = initPage;
    _pageController = PageController(initialPage: initPage - 1); 
    CacheHelper.saveData(key: 'hafs_current_page', value: initPage);
    CacheHelper.saveData(key: 'hafs_current_sura', value: QuranHafsMetadata.getSuraForPage(initPage));
    _cubit = QuranHafsCubit();
    _cubit.loadPage(initPage);
  }

  @override
  void dispose() {
    _cubit.close();
    _pageController.dispose();
    super.dispose();
  }

  void _onWordTap(HafsGlyph glyph) async {
    if (glyph.ayah == 0) return; 

    // Update active reading position
    CacheHelper.saveData(key: 'hafs_current_page', value: _currentPage);
    CacheHelper.saveData(key: 'hafs_current_sura', value: glyph.sura);
    CacheHelper.saveData(key: 'hafs_current_aya', value: glyph.ayah);
    
    final tafseer = await QuranHafsCubit.get(context).getTafseer(glyph.sura, glyph.ayah);
    if (tafseer != null) {
      _showTafseerBottomSheet(tafseer, glyph.sura, glyph.ayah, glyph.code);
    }
  }

  void _showTafseerBottomSheet(HafsTafseer tafseer, int sura, int ayah, String textFristVerse) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DefaultTabController(
          length: 3,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header & Action Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'سورة ${QuranHafsMetadata.getSuraName(sura)} - آية $ayah',
                      style: AppTypography.h3Medium(color: AppColors.primary),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border, color: Colors.red),
                          onPressed: () {
                            QuranHafsCubit.get(this.context).addFavoriteVerse(
                              _currentPage, sura, ayah, textFristVerse
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(content: Text('تم إضافة الآية للمفضلة')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Ayah Text
                Text(
                  tafseer.ayaText,
                  style: AppTypography.bodyLarge(color: AppColors.textPrimaryLight).copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'QCF4_${_currentPage.toString().padLeft(3, '0')}'
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 16),
                
                // Tabs
                TabBar(
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  tabs: const [
                    Tab(text: 'التفسير'),
                    Tab(text: 'الترجمة'),
                    Tab(text: 'التجويد'),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Tab Views
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tafseer
                      QuranEncTafseerWidget(
                        sura: sura,
                        aya: ayah,
                        fallbackTafseer: tafseer.ayaTafseer,
                        isTranslationMode: false,
                      ),
                      // Translation
                      QuranEncTafseerWidget(
                        sura: sura,
                        aya: ayah,
                        fallbackTafseer: '',
                        isTranslationMode: true,
                      ),
                      // Tajweed
                      SingleChildScrollView(
                        child: Center(
                          child: Text(
                            'أحكام التجويد للآية جاري ربطها قريباً...',
                            style: AppTypography.bodyMedium(color: AppColors.textSecondaryLight),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildCustomAppBar(),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 604,
                  reverse: false,
                  onPageChanged: (index) {
                    final page = index + 1;
                    setState(() {
                      _currentPage = page;
                    });
                    _cubit.loadPage(page);
                    CacheHelper.saveData(key: 'hafs_initial_page', value: page);
                    CacheHelper.saveData(key: 'hafs_current_page', value: page);
                    final sura = QuranHafsMetadata.getSuraForPage(page);
                    CacheHelper.saveData(key: 'hafs_current_sura', value: sura);
                    CacheHelper.saveData(key: 'hafs_current_aya', value: 1);
                  },
                  itemBuilder: (context, index) {
                    return QuranHafsPageWidget(
                      pageNumber: index + 1,
                      onWordTap: _onWordTap,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return BlocBuilder<QuranHafsCubit, QuranHafsState>(
      builder: (context, state) {
        bool isBookmarked = false;
        if (state is QuranHafsLoaded) {
          isBookmarked = state.isBookmarked;
        } else {
          isBookmarked = _cubit.isBookmarked;
        }

        final int surahNumber = QuranHafsMetadata.getSuraForPage(_currentPage);
        final String surahName = QuranHafsMetadata.getSuraName(surahNumber);
        final int juz = QuranHafsMetadata.getJuzForPage(_currentPage);

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            gradient: AppColors.headerGradient,
            boxShadow: AppShadows.softCardLight,
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Right: Surah Name (e.g. سورة البقرة)
                InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context).pushNamed(IndexSurahPage.routeName);
                    if (result != null && result is int) {
                      _pageController.jumpToPage(result - 1);
                    }
                  },
                  borderRadius: AppRadius.radiusMd,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'سورة $surahName',
                          style: AppTypography.h3Bold(color: Colors.white).copyWith(
                            fontFamily: 'Hafs20',
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down_rounded, color: Colors.white70, size: 20),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Center: Juz Name
                Text(
                  'الجزء $juz',
                  style: AppTypography.bodyMedium(color: Colors.white).copyWith(
                    fontFamily: 'Hafs20',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const Spacer(),

                // Left: Bookmark & Search Icons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bookmark Icon (إشارة مرجعية: ضغطة لإضافة/حذف، ضغطة مطولة لفتح الإشارات)
                    Tooltip(
                      message: 'ضغطة لإضافة/حذف - ضغطة مطولة لفتح الإشارات المرجعية',
                      child: InkWell(
                        borderRadius: AppRadius.radiusFull,
                        onTap: () {
                          _cubit.toggleBookmark(_currentPage);
                          Fluttertoast.showToast(
                            msg: isBookmarked ? 'تمت إزالة العلامة المرجعية' : 'تمت إضافة العلامة المرجعية',
                          );
                        },
                        onLongPress: () async {
                          final result = await Navigator.of(context).pushNamed(
                            PagesBookMarkPage.routeName,
                            arguments: 2,
                          );
                          if (result != null && result is int) {
                            _pageController.jumpToPage(result - 1);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                            color: isBookmarked ? Colors.amber : Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),

                    // Search Icon (البحث في النص القرآني)
                    IconButton(
                      icon: const Icon(Icons.search_rounded, color: Colors.white, size: 22),
                      onPressed: () => Get.to(() => const SearchBNBPage()),
                      tooltip: 'البحث في النص القرآني',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
