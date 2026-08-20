import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/design_system/components/cards/app_card.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_lesson.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/lesson_cubit/lesson_cubit_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/tajweed_lesson_card.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.lesson});
  static const String routeName = 'lesson_page';
  final TajweedLesson lesson;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  void initState() {
    context.read<LessonCubit>().fetchLesson(widget.lesson.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              ToolBarApp(
                backIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: widget.lesson.title.translate() ?? 'درس التجويد',
              ),
              Expanded(
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: BlocBuilder<LessonCubit, LessonCubitState>(
                          builder: (context, state) {
                            if (state is LessonCubitLoading) {
                              return const Padding(
                                padding: EdgeInsets.all(AppSpacing.xl),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            } else if (state is LessonCubitError) {
                              return Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Center(
                                  child: Text(
                                    'خطأ: ${state.error}',
                                    style: AppTypography.bodyMedium(color: AppColors.error),
                                  ),
                                ),
                              );
                            } else if (state is LessonCubitSuccess) {
                              final lesson = state.lesson;
                              return SingleChildScrollView(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionHeader(
                                      icon: Icons.menu_book_rounded,
                                      title: lesson.title.translate() ?? '',
                                      isDark: isDark,
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    AppCard(
                                      padding: const EdgeInsets.all(AppSpacing.md),
                                      child: Html(
                                        data: lesson.content.translate() ?? '',
                                        style: {
                                          "body": Style(
                                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                            fontSize: FontSize(16.0),
                                            lineHeight: const LineHeight(1.6),
                                          ),
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: AppSpacing.md),

                                    if (lesson.videoUrls.isNotEmpty) ...[
                                      _buildSectionHeader(
                                        icon: Icons.play_circle_fill_rounded,
                                        title: tr('فيديو شارح'),
                                        isDark: isDark,
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      ...lesson.videoUrls.map((video) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                          child: AppCard(
                                            padding: const EdgeInsets.all(AppSpacing.xs),
                                            child: ClipRRect(
                                              borderRadius: AppRadius.radiusMd,
                                              child: YouTubePlayerWidget(url: video['url'] ?? ''),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],

                                    if (lesson.lessonExamples.isNotEmpty) ...[
                                      _buildSectionHeader(
                                        icon: Icons.auto_awesome_rounded,
                                        title: tr('أمثلة وشواهد'),
                                        isDark: isDark,
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      ...lesson.lessonExamples.map((example) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                          child: AppCard(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  example.title.translate() ?? '',
                                                  style: AppTypography.h3Bold(
                                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                                  ),
                                                ),
                                                const SizedBox(height: AppSpacing.xs),
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                                  decoration: BoxDecoration(
                                                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                                                    borderRadius: AppRadius.radiusSm,
                                                    border: Border.all(
                                                      color: AppColors.quranGold.withOpacity(0.3),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      example.verseText,
                                                      textAlign: TextAlign.center,
                                                      style: AppTypography.h2Bold(
                                                        color: AppColors.quranGold,
                                                      ).copyWith(fontFamily: 'Hafs20'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ],
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ];
                  },
                  body: PaginationData<TajweedLesson>(
                    initData: const [],
                    getData: (next) {
                      return ApiBaseHelper().getHTTP(
                        '/api/v1/tajweed/lessons/${widget.lesson.id}/sub-lessons/',
                        dioTypes: DioTypes.noAuthRequired,
                      );
                    },
                    drowItem: (lesson, idx) => TajweedLessonCard(
                      tajweedLesson: lesson,
                    ),
                    pagingController: PagingController<int, TajweedLesson>(firstPageKey: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: AppRadius.radiusMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Text(
            title,
            style: AppTypography.bodyMedium(color: Colors.white).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class YouTubePlayerWidget extends StatefulWidget {
  final String url;

  const YouTubePlayerWidget({super.key, required this.url});

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.url) ?? '',
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: false,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }
}
