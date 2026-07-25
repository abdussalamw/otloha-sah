import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/modules/home/presentation/widget/ads_listing.dart';
import 'package:otloha_sah_flutter/modules/profile/presentation/page/profile_bnb_page.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:upgrader/upgrader.dart';

import '../../../../../app_router.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/utils/res/icons_app.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/auth_navigator.dart';
import '../../../../../core/widgets/cached_image.dart';
import '../../../../../core/widgets/text_view.dart';
import '../../../../kahtma/presentation/pages/katama_comming_soon_page.dart';
import '../../../../profile/business_logic/profile_pic_cubit/update_profile_cubit.dart';
import '../../../../profile/business_logic/profile_pic_cubit/update_profile_state.dart';
import '../../../../quran/business_logic/cubit/quran_cubit.dart';
import '../../../../settings/business_logic/themes/theme_cubit.dart';
import '../../../../settings/presentation/pages/settings_page.dart';
import '../../../../splash/business_logic/cubit/splash_cubit.dart';
import '../../../../tajweed/presentation/pages/levels_page.dart';
import '../../../business_logic/cubit/home_cubit.dart';
import '../../widget/ads_item_view.dart';
import '../../widget/home_main_sction.dart';
import '../../widget/home_sub_main_sction.dart';
import '../../widget/progressindicator.dart';
import '../home/home_page.dart';

class HomeBNBPage extends StatefulWidget {
  const HomeBNBPage({super.key});

  @override
  State<HomeBNBPage> createState() => _HomeBNBPageState();
}

class _HomeBNBPageState extends State<HomeBNBPage> {
  int postion = 0;

  final pageIndexNotifier = ValueNotifier<int>(0);
  Narration? missedNarrationCertification;

  late HomeCubit cubit;
  var pageController = PageController();
  late bool hasMessages = false;

  @override
  void initState() {
    super.initState();
    cubit = HomeCubit.get(context);
    Future.microtask(() {
      print(SplashCubit.user);
      if (SplashCubit.user == null) {
        SplashCubit.get(context).getInitDate();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cubit.setChange();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return UpgradeAlert(
          upgrader: Upgrader(minAppVersion: '2.0.0'),
          showIgnore: false,
          showLater: false,
          child: Container(
            decoration: BoxDecoration(
              color: ThemeCubit.isDark ? Colors.grey[800] : Colors.grey[50],
              image: DecorationImage(
                image: AssetImage(
                  ThemeCubit.isDark
                      ? 'assets/images/dark_background.png'
                      : 'assets/images/home_card_background.png',
                ),
                fit: BoxFit.cover,
                // opacity: 0.5,
              ),
            ),
            child: BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return BlocBuilder<SplashCubit, SplashState>(
                        builder: (context, state) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _toolBarFun(cubit),
                              // _headerProgress(cubit),
                              _sectionMain(context),
                              _titleView(),
                              _subSections(context),
                              AdsListing(),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  SizedBox _titleView() {
    return SizedBox(
      width: double.infinity,
      child: Semantics(
        label: tr('PopularActions'),
        child: TextView(
          text: translate('PopularActions'),
          colorText: AppColor.txtColor3,
          sizeText: 16,
          weightText: FontWeight.w700,
          padding: const EdgeInsets.all(4),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }

  Widget _subSections(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .15,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cubit.subSectionData.length,
            itemBuilder: (context, index) {
              return HomeSubMainSection(
                item: cubit.subSectionData[index],
              );
            },
          ),
        );
      },
    );
  }

  Row _sectionMain(BuildContext context) {
    return Row(
      children: [
        _sections(
          context,
          translate('Tafsir'),
          'assets/images/khatma.png',
          AppColor.gradient1.withOpacity(.8),
          AppColor.gradient2.withOpacity(.3),
          AppColor.gradient2,
          actionTo: KhatmaCommingSoonPage.routeName,
          isCorrect: true,
          pageType: PageType.tafsir,
        ),
        _sections(
          context,
          (SplashCubit.user?.isTeacher ?? false)
              ? translate('CorrectedRecitations')
              : translate('CorrectMyRecitations'),
          'assets/images/recitations.png',
          AppColor.gradient1.withOpacity(.9),
          AppColor.gradient2.withOpacity(.7),
          AppColor.iconColor6,
          actionTo: (SplashCubit.user?.isTeacher ?? false)
              ? Routes.messageCorrect
              : HomePage.routeName,
          isCorrect: !(SplashCubit.user?.isTeacher ?? false),
          pageType: PageType.quran,
        ),
        _sections(
          context,
          translate('Tajweed'),
          'assets/images/tajweed.png',
          AppColor.gradient1,
          AppColor.gradient2,
          AppColor.iconColor6,
          actionTo: TajweedLevelsPage.routeName,
        ),
      ],
    );
  }

  _sections(
    //478fbd
    BuildContext context,
    String title,
    String image,
    Color gradient1,
    Color gradient2,
    Color iconColor, {
    String? actionTo,
    PageType? pageType,
    bool? isCorrect = false,
  }) {
    return HomeMainSection(
      title: title,
      image: image,
      gradient1: gradient1,
      isLogin: SplashCubit.isLogin,
      gradient2: gradient2,
      userProgressIndicator: UserProgressIndicator(
        user: SplashCubit.user,
        type: 'Juz1-3',
        value: 0.0,
      ),
      action: () async {
        if (isCorrect ?? false) {
          BlocProvider.of<HomeCubit>(context).changeIndex(1);
          if (pageType == PageType.tajwid) {
            QuranViewCubit.get(context).changePageType(page: pageType!);
          } else {
            QuranViewCubit.get(context).changePageType(page: pageType!);
          }
        } else {
          AuthNavigator.of(context)!.pushConditionally(
            context,
            actionTo!,
          );
        }
      },
      iconColor: iconColor,
    );
  }

  Row _headerProgress(HomeCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextView(
            //   text: tr('Hello'),
            //   colorText: AppColor.txtColor4,
            //   sizeText: 16,
            //   weightText: FontWeight.w600,
            //   padding: EdgeInsets.zero,
            //   textAlign: TextAlign.start,
            // ),
            // if (SplashCubit.isLogin)
            //   BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
            //     listener: (context, state) {
            //       if (state is UpdateProfileSuccess) {
            //         SplashCubit.user = state.user;
            //       }
            //     },
            //     builder: (context, state) {
            //       return UserNameView(
            //         typeUser: getUserType(SplashCubit.user),
            //         child: TextView(
            //           text: SplashCubit.user?.username ?? '',
            //           colorText: AppColor.txtColor1,
            //           sizeText: 18,
            //           weightText: FontWeight.w900,
            //           padding: const EdgeInsets.all(2),
            //           textAlign: TextAlign.start,
            //         ),
            //       );
            //     },
            //   ),
          ],
        ),
        // if (SplashCubit.isLogin)
        //   UserProgressReading(
        //     userProgressIndicator: UserProgressIndicator(
        //       user: SplashCubit.user,
        //       type: 'Juz1-3',
        //       value: 0.5,
        //       width: MediaQuery.of(context).size.width * .35,
        //       fontSize: 16,
        //     ),
        //   ),
      ],
    );
  }

  Widget _toolBarFun(HomeCubit cubit) {
    return Row(
      children: [
        if (SplashCubit.isLogin)
          BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
            listener: (context, state) {
              if (state is UpdateProfileSuccess) {
                SplashCubit.user = state.user;
              }
            },
            builder: (context, state) {
              return BlocConsumer<SplashCubit, SplashState>(
                listener: (context, state) {},
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const ProfileBNBPage(),
                      );
                      // BlocProvider.of<HomeCubit>(context).changeIndex(3);
                    },
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: Stack(
                        children: [
                          CachedImage(
                            url: SplashCubit.user?.profileImage ?? '',
                            raduis: 30,
                          ),
                          if (missedNarrationCertification != null)
                            const Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        const Expanded(child: SizedBox()),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                hasMessages = false;
                Navigator.pushNamed(context, Routes.messages);
              },
              icon: Icon(
                hasMessages
                    ? Icons.mark_unread_chat_alt_outlined
                    : Icons.message_outlined,
                color: hasMessages ? AppColor.headTextColor : Colors.grey,
                size: 35,
              ),
            ),
            if (HomeCubit.get(context).unseenMessagesCount != 0)
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  width: 15,
                  height: (HomeCubit.get(context).unseenMessagesCount < 10)
                      ? 15
                      : 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(
                      255,
                      228,
                      15,
                      0,
                    ), // Customize the color as needed
                  ),
                  child: Center(
                    child: Text(
                      HomeCubit.get(context).unseenMessagesCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(Routes.notify);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Image.asset(
                  AppIcons.natificationIcon,
                  width: 30,
                  height: 30,
                  color: ThemeCubit.isDark ? Colors.white : AppColor.iconColor,
                ),
              ),
              if (HomeCubit.get(context).unseenNotificationsCount != 0)
                Positioned(
                  right: 0,
                  top: 8,
                  child: Container(
                    width:
                        (HomeCubit.get(context).unseenNotificationsCount < 10)
                            ? 15
                            : 20,
                    height: 15,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(
                          255, 228, 15, 0), // Customize the color as needed
                    ),
                    child: Center(
                      child: Text(
                        HomeCubit.get(context)
                            .unseenNotificationsCount
                            .toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(SettingsPage.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              AppIcons.settingsIcon,
              width: 30,
              height: 30,
              color: ThemeCubit.isDark ? Colors.white : AppColor.iconColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemPageView({required String image, Function()? action}) {
    return AdsItemView(
      image: image,
      action: action,
    );
  }
}
