import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../quran/presentation/page/chapters/index_surah_page.dart';
import '../../../quran/presentation/page/action_pages/bookmark_bage.dart';
import '../../../../../data_source/cache_helper.dart';
import '../../business_logic/quran_hafs_cubit.dart';
import '../../business_logic/quran_hafs_state.dart';
import '../../data/quran_hafs_repository.dart';
import '../../data/quran_hafs_metadata.dart';
import '../widgets/quran_hafs_page_widget.dart';

class QuranHafsPage extends StatefulWidget {
  static const routeName = '/quran_hafs';

  const QuranHafsPage({Key? key}) : super(key: key);

  @override
  State<QuranHafsPage> createState() => _QuranHafsPageState();
}

class _QuranHafsPageState extends State<QuranHafsPage> {
  late PageController _pageController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    int initPage = CacheHelper.getData(key: 'hafs_initial_page') ?? 1;
    _currentPage = initPage;
    _pageController = PageController(initialPage: initPage - 1); 
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onWordTap(HafsGlyph glyph) async {
    if (glyph.ayah == 0) return; 
    
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
                      SingleChildScrollView(
                        child: Text(
                          tafseer.ayaTafseer,
                          style: AppTypography.bodyMedium(color: AppColors.textSecondaryLight).copyWith(
                            height: 1.6,
                            fontSize: 16,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      // Translation
                      SingleChildScrollView(
                        child: Center(
                          child: Text(
                            'الترجمة جاري ربطها قريباً...',
                            style: AppTypography.bodyMedium(color: AppColors.textSecondaryLight),
                          ),
                        ),
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
    return BlocProvider(
      create: (context) => QuranHafsCubit(),
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
                    setState(() {
                      _currentPage = index + 1;
                    });
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
        }
        
        // Find Sura name using a simple DB query or fallback to metadata
        int juz = QuranHafsMetadata.getJuzForPage(_currentPage);
        
        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            bottom: 8,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            gradient: AppColors.headerGradient,
            boxShadow: AppShadows.softCardLight,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side: Juz Index (Text only)
              Row(
                children: [
                  const Icon(Icons.menu_book, color: Colors.white, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    'الجزء $juz',
                    style: AppTypography.bodyMedium(color: Colors.white),
                  ),
                ],
              ),

              // Center: Bookmark Action
              Tooltip(
                message: 'ضغطة للإضافة - ضغطة مطولة لفتح الإشارات المرجعية',
                child: InkWell(
                  onLongPress: () async {
                    final result = await Navigator.of(context).pushNamed(
                      PagesBookMarkPage.routeName,
                      arguments: 2,
                    );
                    if (result != null && result is int) {
                      _pageController.jumpToPage(result - 1);
                    }
                  },
                  onTap: () {
                    QuranHafsCubit.get(context).toggleBookmark(_currentPage);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Colors.amber : Colors.white,
                    ),
                  ),
                ),
              ),

              // Right side: Surah Index
              InkWell(
                onTap: () async {
                  final result = await Navigator.of(context).pushNamed(IndexSurahPage.routeName);
                  if (result != null && result is int) {
                    _pageController.jumpToPage(result - 1);
                  }
                },
                child: Row(
                  children: [
                    Text(
                      'سورة ${QuranHafsMetadata.getSuraName(QuranHafsMetadata.getSuraForPage(_currentPage))}',
                      style: AppTypography.bodyMedium(color: Colors.white).copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.list, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
