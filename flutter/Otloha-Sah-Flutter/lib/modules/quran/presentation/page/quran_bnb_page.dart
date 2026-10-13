import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../data_source/cache_helper.dart';
import 'package:otloha_sah_flutter/modules/quran_hafs/data/quran_hafs_metadata.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';
import '../../business_logic/cubit/ballview_cubit.dart';
import '../../business_logic/cubit/progress/progress_cubit.dart';
import '../../business_logic/cubit/progress/progress_state.dart';
import '../../business_logic/cubit/quran_cubit.dart';
import '../../business_logic/cubit/quranplayer_cubit.dart';
import '../../business_logic/cubit/recitation_cubit.dart';
import '../widget/floatin_button_widget.dart';
import '../widget/play_botton.dart';
import '../widget/play_puse_tools.dart';
import '../widget/recorded_file_setting.dart';
import '../widget/tool_botton.dart';
import 'action_pages/bookmark_bage.dart';
import 'chapters/index_surah_page.dart';
import '../../../home/presentation/pages/bnb_pags/search_bnb_page.dart';

class QuranBNBPage extends StatefulWidget {
  final PageType initialPageType;
  const QuranBNBPage({super.key, this.initialPageType = PageType.quran});

  @override
  State<QuranBNBPage> createState() => _QuranBNBPageState();
}

class _QuranBNBPageState extends State<QuranBNBPage> {
  QuranViewCubit? cubit;
  RecitationAddCubit? addCubit;

  @override
  void dispose() {
    super.dispose();
    addCubit?.stop(() {});
    cubit?.dispose();
  }

  @override
  void initState() {
    super.initState();
    ProgressCubit.get(context)
        .getProgress(QuranCacheRepository.selectedChapterId);
    QuranController quranController = QuranController(
      playerController: PlayerController(
        onPlay: () {},
        onPause: () {},
        onSetRepeatMode: (mode) {},
        onNext: () {},
        onPrev: () {},
        onStop: () {},
      ),
    );
    QuranViewCubit.get(context).setQuranController(quranController);
    QuranPlayerCubit.get(context).setQuranController(quranController);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        QuranViewCubit.get(context).changePageType(page: widget.initialPageType);
      }
    });
  }

  @override
  void didUpdateWidget(covariant QuranBNBPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPageType != widget.initialPageType) {
      QuranViewCubit.get(context).changePageType(page: widget.initialPageType);
    }
  }

  @override
  Widget build(BuildContext context) {
    cubit = QuranViewCubit.get(context);
    addCubit = RecitationAddCubit.get(context);
    cubit?.getIsMarkorlike();

    return BlocConsumer<QuranViewCubit, QuranViewState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = QuranViewCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          body: Column(
            children: [
              // Top Audio Downloading Bar Indicator
              BlocBuilder<QuranPlayerCubit, QuranPlayerState>(
                builder: (context, state) {
                  if (state is DownloadingChapterState) {
                    return const LinearProgressIndicator(
                      backgroundColor: AppColors.primaryLight,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    );
                  }
                  return const SizedBox();
                },
              ),

              // Fixed Modern Top App Bar with Surah (Right), Juz (Center), Bookmark & Search (Left)
              _buildTopAppBar(context, cubit),

              // Full Quran Mushaf Screen Container
              Expanded(
                child: Stack(
                  children: [
                    _viewPageReading(context),
                    _viewLikeMarked(cubit),
                    if (cubit.isRecorded) RecordTool(),
                    if (cubit.checkVersesValue &&
                        cubit.selectedVerses.isNotEmpty &&
                        cubit.isPlaying == false &&
                        cubit.isRecorded == false &&
                        cubit.isRecordedFile == false)
                      const ToolBotton(),
                    if (cubit.isRecordedFile) const RecordedFileTool(),
                    if (cubit.isPlaying) const PlayPauseTools(),
                    const FloatingButton(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fixed Royal Blue Top App Bar: Surah (Right), Juz (Center), Bookmark & Search (Left)
  Widget _buildTopAppBar(BuildContext context, QuranViewCubit cubit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String rawName = cubit.chapterName;
    final String surahText = rawName.isEmpty
        ? 'سورة الفاتحة'
        : (rawName.startsWith('سورة') ? rawName : 'سورة $rawName');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        boxShadow: isDark ? AppShadows.softCardDark : AppShadows.softCardLight,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Right: Surah Name (e.g. سورة البقرة)
            InkWell(
              onTap: () async {
                final result = await Navigator.of(context).pushNamed(IndexSurahPage.routeName);
                if (result is int && context.mounted) {
                  try {
                    QuranViewCubit.get(context).controller.changeInitPage(result);
                  } catch (_) {}
                }
              },
              borderRadius: AppRadius.radiusMd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      surahText,
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

            // Center: Juz Name — ديناميكي من QuranCubit مع fallback تلقائي
            Builder(
              builder: (ctx) {
                String partName = '';
                try {
                  final innerCubit = QuranCubit.get(ctx);
                  partName = innerCubit.currentPart?.name ?? '';
                } catch (_) {}
                if (partName.isEmpty) {
                  int currentPage = CacheHelper.getData(key: 'hafs_current_page') ?? 1;
                  int juz = QuranHafsMetadata.getJuzForPage(currentPage);
                  partName = 'الجزء $juz';
                }
                return Text(
                  partName,
                  style: AppTypography.bodyMedium(color: Colors.white).copyWith(
                    fontFamily: 'Hafs20',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                );
              },
            ),

            const Spacer(),

            // Left: Bookmark & Search Icons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Bookmark Icon (إشارة مرجعية: ضغطة لإضافة/إلغاء، ضغطة مطولة لفتح الإشارات)
                Tooltip(
                  message: 'ضغطة لإضافة/حذف - ضغطة مطولة لفتح الإشارات المرجعية',
                  child: InkWell(
                    borderRadius: AppRadius.radiusFull,
                    onTap: () {
                      if (cubit.isBookmarked) {
                        cubit.deleteBookMark();
                        Fluttertoast.showToast(msg: 'تمت إزالة العلامة المرجعية');
                      } else {
                        cubit.addBookMark();
                        Fluttertoast.showToast(msg: 'تمت إضافة العلامة المرجعية');
                      }
                    },
                    onLongPress: () async {
                      final result = await Navigator.of(context).pushNamed(
                        PagesBookMarkPage.routeName,
                        arguments: 2,
                      );
                      if (result is int && context.mounted) {
                        try {
                          QuranViewCubit.get(context).controller.changeInitPage(result);
                        } catch (_) {}
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        cubit.isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                        color: cubit.isBookmarked ? Colors.amber : Colors.white,
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
  }

  Widget _viewLikeMarked(QuranViewCubit cubit) {
    return Positioned(
      top: 10,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (cubit.isLiked && cubit.pageType == PageType.quran)
                Image.asset(
                  AppIcons.love2,
                  color: Colors.amber,
                  width: 28,
                  height: 28,
                ),
              if (cubit.isBookmarked && cubit.pageType == PageType.quran)
                Image.asset(
                  AppIcons.bookMark2Icon,
                  color: Colors.amber,
                  width: 28,
                  height: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewPageReading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ─── مرحلة 5: إلغاء التحديد عند الضغط خارج الآيات ───
        final viewCubit = QuranViewCubit.get(context);
        if (viewCubit.selectedVerses.isNotEmpty) {
          viewCubit.hideToolBar();
        }
        BlocProvider.of<BallViewCubit>(context).setHaveOpcity();
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.surfaceDark
                : AppColors.surfaceLight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: BlocBuilder<QuranPlayerCubit, QuranPlayerState>(
                    builder: (context, state) {
                      return BlocConsumer<ProgressCubit, ProgressState>(
                        listener: (context, progressState) {},
                        buildWhen: (previous, current) => current is ProgressLoaded,
                        builder: (context, progressState) {
                          return QuranWidget(
                            page: cubit!.pageType,
                            playingVerse: QuranPlayerCubit.get(context).playingVerse,
                            isDark: ThemeCubit.isDark,
                            chapterId: cubit!.chapterId,
                            bookId: cubit!.bookId,
                            narrationId: cubit!.narrationId,
                            onTap: (isVerSelected, selectedVerses) {
                              cubit!.setSelectedVerses(selectedVerses ?? []);
                              cubit!.isVerSelected(isVerSelected);
                              cubit!.changeIsSelectedVerse();
                              if (selectedVerses?.isNotEmpty == true) {
                                cubit!.changeIsOnTruePressed();
                                final verse = selectedVerses!.first;
                                final sura = verse.chapterId ?? verse.chapterNumber ?? cubit!.chapterId;
                                final aya = verse.verseNumber ?? 1;
                                CacheHelper.saveData(key: 'hafs_current_sura', value: sura);
                                CacheHelper.saveData(key: 'hafs_current_aya', value: aya);
                              }
                              addCubit!.setSelectedVerses(selectedVerses ?? []);
                            },
                            onPageTypeChage: (pageType) {
                              cubit!.changePageType(page: pageType);
                            },
                            onLongTap: (isVerSelected, selectedVerses) {
                              cubit!.setSelectedVerses(selectedVerses ?? []);
                              cubit!.isVerSelected(isVerSelected);
                              cubit!.changeIsSelectedVerse();
                              if (selectedVerses?.isNotEmpty == true) {
                                cubit!.changeIsOnTruePressed();
                                final verse = selectedVerses!.first;
                                final sura = verse.chapterId ?? verse.chapterNumber ?? cubit!.chapterId;
                                final aya = verse.verseNumber ?? 1;
                                CacheHelper.saveData(key: 'hafs_current_sura', value: sura);
                                CacheHelper.saveData(key: 'hafs_current_aya', value: aya);
                              }
                              addCubit!.setSelectedVerses(selectedVerses ?? []);
                            },
                            onPageChange: (int pageNumber) async {
                              QuranPlayerCubit.get(context).setPageChange();
                              cubit?.getIsMarkorlike();
                              CacheHelper.saveData(key: 'hafs_current_page', value: pageNumber);
                              final sura = QuranHafsMetadata.getSuraForPage(pageNumber);
                              CacheHelper.saveData(key: 'hafs_current_sura', value: sura);
                              CacheHelper.saveData(key: 'hafs_current_aya', value: 1);
                            },
                            controller: QuranViewCubit.get(context).controller,
                            onChapterChange: (chapter) async {
                              await cubit!.updateChapterHeaderInfo(chapter!);
                              if (context.mounted) {
                                await ProgressCubit.get(context).getProgress(chapter.id!);
                              }
                            },
                            locale: Get.locale!,
                            verseStyles: progressState is ProgressLoaded
                                ? [
                                    VerseStyle(
                                      textStyle: const TextStyle(color: AppColors.textMutedLight),
                                      verseIds: progressState.progress.pending.values
                                          .expand((item) => item)
                                          .toList(),
                                    ),
                                    VerseStyle(
                                      textStyle: const TextStyle(color: AppColors.success),
                                      verseIds: progressState.progress.accepted.values
                                          .expand((item) => item)
                                          .toList(),
                                    ),
                                    VerseStyle(
                                      textStyle: const TextStyle(color: AppColors.error),
                                      verseIds: progressState.progress.rejected.values
                                          .expand((item) => item)
                                          .toList(),
                                    ),
                                  ]
                                : [],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
