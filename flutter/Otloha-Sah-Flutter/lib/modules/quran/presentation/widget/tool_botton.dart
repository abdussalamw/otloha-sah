import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../../../data_source/user_services_data.dart';
import '../../business_logic/cubit/quran_cubit.dart';
import '../../business_logic/cubit/quranplayer_cubit.dart';
import '../../business_logic/cubit/recitation_cubit.dart';
import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import 'quranenc_tafseer_widget.dart';
import 'add_note.dart';

class ToolBotton extends StatefulWidget {
  const ToolBotton({Key? key}) : super(key: key);

  @override
  State<ToolBotton> createState() => _ToolBottonState();
}

class _ToolBottonState extends State<ToolBotton> {
  final sizeIcon = 24.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: BlocConsumer<QuranViewCubit, QuranViewState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = QuranViewCubit.get(context);
          var cubitRecitation = RecitationAddCubit.get(context);
          return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              width: MediaQuery.of(context).size.width / 1.09,
              alignment: Alignment.center,
              height: 45,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 5.0,
                  )
                ],
                gradient: toolBarGradient,
                color: Colors.deepPurple.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BlocConsumer<QuranPlayerCubit, QuranPlayerState>(
                    listener: (context, state) {
                      // if (state is DownloadingChapterErrorState) {
                      //   pd.close();
                      // }
                      // if (state is DownloadingChapterState) {
                      //   if (state.progress == 0) {
                      //     pd.show(
                      //       max: 100,
                      //       msg: tr('downloading_chapter'),
                      //       progressType: ProgressType.valuable,
                      //     );
                      //   } else {
                      //     pd.update(value: (state.progress * 100).ceil());
                      //   }
                      // }
                    },
                    buildWhen: (_, __) => false,
                    builder: (context, state) {
                      return GestureDetector(
                          onTap: () async {
                            var isPlay =
                                await BlocProvider.of<QuranPlayerCubit>(context)
                                    .initRecitationVerses(
                              chapterId: cubit.chapterId,
                              selectedVerses: cubit.selectedVerses,
                              context: context,
                            );
                            //    cubit.playVerses();
                            if (isPlay) {
                              cubit.changeIsPlaying();
                            }
                          },
                          child: SvgPicture.asset(
                            AppSVG.play,
                            color: AppColor.white,
                            width: sizeIcon,
                            height: sizeIcon,
                          ));
                    },
                  ),
                  if (!cubit.isSelectedVerse)
                    GestureDetector(
                        onTap: () async {
                          await cubitRecitation.init(
                              context, cubit.changeIsRecordedFile);
                          cubit.changeIsRecorded();
                        },
                        child: SvgPicture.asset(
                          AppSVG.mic,
                          color: Colors.red,
                          width: sizeIcon,
                          height: sizeIcon,
                        )),
                  if (cubit.isSelectedVerse)
                    GestureDetector(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppSVG.replay,
                        color: AppColor.white,
                        width: sizeIcon,
                        height: sizeIcon,
                      ),
                    ),
                  // if (cubit.isSelectedVerse)
                  GestureDetector(
                    onTap: () async {
                      var uid = (UserDataServices.instance.getUserId());
                      // VerseNote verseNote = VerseNote(
                      //   textFristVerse: cubit.getFirstWords(
                      //       cubit.selectedVerses.first.text ?? '', 5),
                      //   idFromVerse: cubit.selectedVerses.first.id!,
                      //   idToVerse: cubit.selectedVerses.first.id!,
                      //   pageNumber: QuranCacheRepository.lastPageNumber,
                      //   userId: uid!,
                      // );
                      Scaffold.of(context).showBottomSheet(
                        (context) {
                          return AddNoteWidget(
                            // verseNote: verseNote,
                            isEdit: false,
                          );
                        },
                        backgroundColor: AppColor.transparent,
                      );
                    },
                    child: SvgPicture.asset(
                      AppSVG.note,
                      color: AppColor.white,
                      width: sizeIcon,
                      height: sizeIcon,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      String verses = '';
                      for (Verse verse in cubit.selectedVerses) {
                        verses += ' ${verse.text}';
                      }
                      Clipboard.setData(ClipboardData(text: verses));
                      Get.dialog(
                        const AlertDialogFullScreen(),
                        barrierColor: AppColor.backdone,
                      );
                    },
                    child: SvgPicture.asset(
                      AppSVG.copy,
                      color: Colors.white,
                      width: sizeIcon,
                      height: sizeIcon,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (!cubit.isDisable) {
                        Get.dialog(const AlertDialogFullScreen(
                          autoClose: false,
                        ));
                        cubit.isLiked
                            ? await cubit.deleteLike()
                            : await cubit.saveLiked();
                        Get.back();
                      }
                    },
                    child: Icon(
                      cubit.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: AppColor.white,
                      size: sizeIcon,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showTafseerModal(context, cubit);
                    },
                    child: SvgPicture.asset(
                      AppSVG.tafsir,
                      color: AppColor.white,
                      width: sizeIcon,
                      height: sizeIcon,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTafseerModal(BuildContext context, QuranViewCubit cubit) {
    if (cubit.selectedVerses.isEmpty) return;
    final selectedVerse = cubit.selectedVerses.first;
    final int sura = selectedVerse.chapterId ?? selectedVerse.chapterNumber ?? cubit.chapterId ?? 1;
    final int aya = selectedVerse.verseNumber ?? 1;
    final String ayaText = selectedVerse.text ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => DefaultTabController(
        length: 2,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'سورة ${cubit.chapterName ?? ''} - آية $aya',
                    style: AppTypography.h3Medium(color: AppColors.primary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(bottomSheetContext),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (ayaText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    ayaText,
                    style: AppTypography.bodyLarge().copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              const SizedBox(height: 8),
              TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'التفسير'),
                  Tab(text: 'الترجمة'),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  children: [
                    QuranEncTafseerWidget(
                      sura: sura,
                      aya: aya,
                      fallbackTafseer: '',
                      isTranslationMode: false,
                    ),
                    QuranEncTafseerWidget(
                      sura: sura,
                      aya: aya,
                      fallbackTafseer: '',
                      isTranslationMode: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
