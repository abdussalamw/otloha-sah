import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../business_logic/cubit/ballview_cubit.dart';
import '../../business_logic/cubit/progress/progress_cubit.dart';
import '../../business_logic/cubit/progress/progress_state.dart';
import '../../business_logic/cubit/quranplayer_cubit.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../business_logic/cubit/quran_cubit.dart';
import '../../business_logic/cubit/recitation_cubit.dart';
import 'chapters/index_surah_page.dart';
import '../widget/floatin_button_widget.dart';
import '../widget/play_botton.dart';
import '../widget/play_puse_tools.dart';
import '../widget/recorded_file_setting.dart';
import '../widget/tool_botton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class QuranBNBPage extends StatefulWidget {
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
  initState() {
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
  }

  @override
  Widget build(BuildContext context) {
    cubit = QuranViewCubit.get(context);
    addCubit = RecitationAddCubit.get(context);
    cubit?.getIsMarkorlike();

    // Future.microtask(() => QuranViewCubit.controller
    //     .changePageType(cubit?.pageType ?? PageType.quran));

    return BlocConsumer<QuranViewCubit, QuranViewState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = QuranViewCubit.get(context);
        return Scaffold(
          body: Column(
            children: [
              BlocBuilder<QuranPlayerCubit, QuranPlayerState>(
                builder: (context, state) {
                  if (state is DownloadingChapterState) {
                    return const LinearProgressIndicator();
                  }
                  return const SizedBox();
                },
              ),
              Expanded(
                child: Stack(
                  children: [
                    _viewTop(context),
                    _viewPageReading(context),

                    //_tempView(context, cubit),
                    _viewLikeMarked(cubit),
                    if (cubit.isRecorded) const RecordTool(),
                    if (cubit.checkVersesValue &&
                        cubit.selectedVerses.isNotEmpty &&
                        cubit.isPlaying == false &&
                        cubit.isRecorded == false &&
                        cubit.isRecordedFile == false)
                      const ToolBotton(),
                    // if (cubit.checkVersesValue && cubit.isPlaying == false)
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

  Widget _viewLikeMarked(QuranViewCubit cubit) {
    return Positioned(
      top: cubit.checkOpened ? 0 : 40,
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
                  width: 30,
                  height: 30,
                ),
              if (cubit.isBookmarked && cubit.pageType == PageType.quran)
                Image.asset(
                  AppIcons.bookMark2Icon,
                  color: Colors.amber,
                  width: 30,
                  height: 30,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewPageReading(context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<BallViewCubit>(context).setHaveOpcity();
      },
      child: Padding(
        padding: EdgeInsets.only(
            top: cubit!.checkOpened ? 0 : 40,
            bottom: cubit!.checkOpened ? 52 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: AppColor.background,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: BlocBuilder<QuranPlayerCubit, QuranPlayerState>(
                      builder: (context, state) {
                        QuranViewCubit.get(context).init();
                        return BlocConsumer<ProgressCubit, ProgressState>(
                          listener: (context, progressState) {},
                          buildWhen: (previous, current) =>
                              current is ProgressLoaded,
                          builder: (context, progressState) {
                            return QuranWidget(
                              page: cubit!.pageType,
                              playingVerse:
                                  QuranPlayerCubit.get(context).playingVerse,
                              isDark: ThemeCubit.isDark,
                              chapterId: cubit!.chapterId,
                              bookId: cubit!.bookId,
                              narrationId: cubit!.narrationId,
                              onTap: (isVerSelected, selectedVerses) {
                                cubit!.isVerSelected(isVerSelected);
                                cubit!.changeIsSelectedVerse();
                                cubit!.changeIsOnTruePressed();
                                addCubit!.setSelectedVerses(selectedVerses!);
                                cubit!.setSelectedVerses(selectedVerses);
                              },
                              onPageTypeChage: (pageType) {
                                cubit!.changePageType(page: pageType);
                              },
                              onLongTap: (isVerSelected, selectedVerses) {
                                cubit!.isVerSelected(isVerSelected);
                                cubit!.changeIsSelectedVerse();
                                cubit!.changeIsOnTruePressed();
                                addCubit!.setSelectedVerses(selectedVerses!);
                                cubit!.setSelectedVerses(selectedVerses);
                              },
                              onPageChange: (int pageNumber) async {
                                QuranPlayerCubit.get(context).setPageChange();
                                cubit?.getIsMarkorlike();
                              },
                              controller:
                                  QuranViewCubit.get(context).controller,
                              onChapterChange: (chapter) async {
                                await cubit!.updateChapterHeaderInfo(chapter!);
                                await ProgressCubit.get(context)
                                    .getProgress(chapter.id!);
                              },
                              locale: Get.locale!,
                              verseStyles: progressState is ProgressLoaded
                                  ? [
                                      VerseStyle(
                                        textStyle: const TextStyle(
                                            color: AppColor.grey),
                                        verseIds: progressState
                                            .progress.pending.values
                                            .expand((item) => item)
                                            .toList(),
                                      ),
                                      VerseStyle(
                                        textStyle: const TextStyle(
                                            color: Colors.green),
                                        verseIds: progressState
                                            .progress.accepted.values
                                            .expand((item) => item)
                                            .toList(),
                                      ),
                                      VerseStyle(
                                        textStyle:
                                            const TextStyle(color: Colors.red),
                                        verseIds: progressState
                                            .progress.rejected.values
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _viewTop(BuildContext context) {
    return Hero(
      tag: 'ToChooseSurah',
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(IndexSurahPage.routeName)
            .then((value) {}),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.only(bottom: 48, top: 8),
          //margin:  EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF08226C),
                Color(0xFF2566B0),
                Color(0xFF3A7BD5),
                Color(0xFF00D2FF),
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            image: DecorationImage(
              image: Svg(
                AppSVG.back2,
                // color: AppColor.white,
              ),
              fit: BoxFit.cover,
              opacity: .08,
              repeat: ImageRepeat.noRepeat,
              scale: 2,
            ),
            color: AppColor.darkBlue,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextView(
                text: cubit?.chapterName ?? '',
                textAlign: TextAlign.center,
                padding: const EdgeInsets.only(bottom: 20),
                colorText: AppColor.txtColor2,
                sizeText: 18,
                fontFamily: 'Hafs20',
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0),
                child: Icon(
                  Icons.expand_more,
                  color: AppColor.txtColor2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
