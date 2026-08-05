import 'package:flutter/material.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../business_logic/cubit/quranplayer_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../../business_logic/cubit/quran_cubit.dart';

import '../../../settings/presentation/pages/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/themes/color.dart';

class FloatingMenu extends StatefulWidget {
  const FloatingMenu({super.key});

  @override
  State<FloatingMenu> createState() => _FloatingMenuState();
}

class _FloatingMenuState extends State<FloatingMenu> {
  // late ProgressDialog pd;

  @override
  void initState() {
    // pd = ProgressDialog(context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// floatBackGround(cubit),
        floatBall(context),
      ],
    );
  }

  Widget floatBall(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Positioned(
        bottom: MediaQuery.of(context).size.width / -2,
        right: MediaQuery.of(context).size.width / -2,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Opacity(
            opacity: .8,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColor.lightBlue.withOpacity(.7),
                    AppColor.darkBlue.withOpacity(1),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Stack(
                children: [
                  const CircleAvatar(
                      backgroundColor: AppColor.transparent, radius: 200),
                  BlocBuilder<QuranViewCubit, QuranViewState>(
                    builder: (context, state) {
                      var cubit = QuranViewCubit.get(context);
                      return Positioned(
                        top: 40,
                        right: 200,
                        child: Container(
                          color: AppColor.transparent,
                          height: 150,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 36,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BlocConsumer<QuranPlayerCubit, QuranPlayerState>(
                                      listener: (context, state) {},
                                      buildWhen: (_, __) => false,
                                      builder: (context, state) {
                                        return _viewIcon(
                                          image: AppIcons.playIcon,
                                          onTap: () async {
                                            if (!cubit.isDisable) {
                                              var isPlay = await BlocProvider.of<QuranPlayerCubit>(context)
                                                  .initRecitationVerses(
                                                chapterId: cubit.chapterId,
                                                pageNumber: QuranCacheRepository.lastPageNumber,
                                                context: context,
                                              );
                                              if (isPlay) {
                                                cubit.changeIsPlaying();
                                                Get.back();
                                              }
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    _viewIcon(
                                      image: cubit.isLiked ? AppIcons.love2 : AppIcons.love,
                                      onTap: () async {
                                        if (!cubit.isDisable) {
                                          Get.dialog(
                                            const AlertDialogFullScreen(
                                              autoClose: false,
                                            ),
                                          );
                                          cubit.isLiked ? await cubit.deleteLike() : await cubit.saveLiked();
                                          Get.back();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 36,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _viewIcon(
                                        image: AppIcons.languageIcon,
                                        onTap: () {
                                          cubit.changePageType(page: PageType.translation);
                                          cubit.changeFalseFloating();
                                        },
                                      ),
                                      _viewIcon(
                                        image: AppSVG.quran,
                                        isSvg: true,
                                        onTap: () {
                                          cubit.changePageType(page: PageType.quran);
                                          cubit.changeFalseFloating();
                                        },
                                      ),
                                      _viewIcon(
                                        image: AppSVG.recitations,
                                        isSvg: true,
                                        onTap: () {
                                          cubit.changePageType(page: PageType.tajwid);
                                          cubit.changeFalseFloating();
                                        },
                                      ),
                                      _viewIcon(
                                        image: AppSVG.tafsir,
                                        isSvg: true,
                                        onTap: () {
                                          cubit.changePageType(page: PageType.tafsir);
                                          cubit.changeFalseFloating();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewIcon({
    String? image,
    required Function() onTap,
    bool isSvg = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: isSvg
            ? SvgPicture.asset(
                image!,
                color: AppColor.white.withOpacity(.7),
                width: 28,
                height: 28,
              )
            : Image.asset(
                image!,
                color: AppColor.white.withOpacity(.7),
                width: 28,
                height: 28,
              ),
      ),
    );
  }
}
