import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/pages/users_listing.dart';
import '../../../../app_router.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../data_source/user_services_data.dart';
import 'bottom_bar_item.dart';
import '../pages/bnb_pags/home_bnb_page.dart';
import '../../../profile/presentation/page/profile_bnb_page.dart';
import '../../../quran/presentation/page/quran_bnb_page.dart';
import '../pages/bnb_pags/search_bnb_page.dart';
import 'sub_section_item.dart';
import '../../../quran/presentation/page/action_pages/pages_liked_page.dart';
import '../../../recitations/presentation/page/recitations_page.dart';
import '../../../teachers/presentation/page/students_page.dart';
import '../../../teachers/presentation/page/teacher_page.dart';

import '../../../quran/presentation/page/action_pages/bookmark_bage.dart';
import '../../../quran/presentation/page/action_pages/note_page.dart';

class SubSectionDataTeacher {
  List<SubSectionItem> subSectionDataTeacher = [
    SubSectionItem(
      title: translate('General'),
      image: AppSVG.messages,
      action: Routes.generalBox,
    ),
    SubSectionItem(
      title: translate('my_records'),
      image: AppSVG.recitations,
      action: RecitationsPage.routeName,
    ),
    SubSectionItem(
      title: translate('Conversations'),
      image: AppSVG.chat,
      action: Routes.messages,
    ),
    SubSectionItem(
      title: translate('MarkableRecitations'),
      image: AppSVG.special,
      action: Routes.messageMarkable,
    ),
    SubSectionItem(
      title: translate('TeachersRecitation'),
      image: AppSVG.teacherRecitations,
      action: Routes.messageTeacher,
    ),
    // SubSectionItem(
    //   title: translate('Teachers'),
    //   image: AppSVG.teachers,
    //   subTitle: _user(),
    //   action: TeacherPage.routeName,
    // ),
    // SubSectionItem(
    //   title: translate('Students'),
    //   image: AppSVG.students,
    //   action: StudentsPage.routeName,
    // ),
    // SubSectionItem(
    //   title: translate('Translation'),
    //   image: AppIcons.languageIcon,
    //   isPng: true,
    //   subTitle: QuranCacheRepository.quranTranslationSelectedName ?? '',
    //   action2: (context) {
    //     BlocProvider.of<QuranViewCubit>(context)
    //         .changePluginPageType(page: PageType.translation)
    //         .then((value) => BlocProvider.of<HomeCubit>(context).changeIndex(1));
    //   },
    // ),
    // SubSectionItem(
    //   title: translate('Tafsir'),
    //   image: AppSVG.tafsir,
    //   subTitle: QuranCacheRepository.tafsirSelectedName ?? '',
    //   action2: (context) {
    //     BlocProvider.of<QuranViewCubit>(context)
    //         .changePluginPageType(page: PageType.tafsir)
    //         .then((value) => BlocProvider.of<HomeCubit>(context).changeIndex(1));
    //   },
    // ),
    // SubSectionItem(
    //   title: translate('Tajweed'),
    //   image: AppSVG.tajweed,
    //   subTitle: QuranCacheRepository.selectedTajweedName ?? '',
    //   action2: (context) {
    //     BlocProvider.of<QuranViewCubit>(context)
    //         .changePluginPageType(page: PageType.tajwid)
    //         .then((value) => BlocProvider.of<HomeCubit>(context).changeIndex(1));
    //   },
    // ),
    SubSectionItem(
      title: translate('Note'),
      image: AppSVG.note,
      action2: (context) {
        Navigator.of(context).pushNamed(NotesVersePage.routeName, arguments: 1);
      },
    ),
    SubSectionItem(
      title: translate('Likes'),
      image: AppSVG.favourite,
      action2: (context) {
        Navigator.of(context).pushNamed(LikedVersesPage.routeName);
      },
    ),
    SubSectionItem(
      title: translate('BookMarks'),
      image: AppSVG.bookmark,
      action2: (context) {
        //Get.to(const PagesBookMarkPage());
        Navigator.of(context)
            .pushNamed(PagesBookMarkPage.routeName, arguments: 2);
      },
    ),
  ];
}

class SubSectionDataStudents {
  List<SubSectionItem> subSectionDataStudents = [
    SubSectionItem(
      title: translate('my_records'),
      image: AppSVG.recitations,
      action: RecitationsPage.routeName,
    ),
    SubSectionItem(
      title: translate('Conversations'),
      image: AppSVG.chat,
      action: Routes.messages,
    ),
    SubSectionItem(
      title: translate('TeachersRecitation'),
      image: AppSVG.teacherRecitations,
      action: Routes.messageTeacher,
    ),
    SubSectionItem(
      title: translate('MarkableRecitations'),
      image: AppSVG.special,
      action: Routes.messageMarkable,
    ),
    // SubSectionItem(
    //   title: translate('Teachers'),
    //   image: AppSVG.teachers,
    //   subTitle: _user(),
    //   action: TeacherPage.routeName,
    // ),
    // SubSectionItem(
    //   title: translate('Translation'),
    //   image: AppIcons.languageIcon,
    //   isPng: true,
    //   subTitle: QuranCacheRepository.quranTranslationSelectedName ?? '',
    //   action2: (context) {
    //     BlocProvider.of<QuranViewCubit>(context)
    //         .changePluginPageType(page: PageType.translation)
    //         .then((value) => BlocProvider.of<HomeCubit>(context).changeIndex(1));
    //   },
    // ),
    // SubSectionItem(
    //   title: translate('Tafsir'),
    //   image: AppSVG.tafsir,
    //   subTitle: QuranCacheRepository.tafsirSelectedName ?? '',
    //   action2: (context) {
    //     BlocProvider.of<QuranViewCubit>(context)
    //         .changePluginPageType(page: PageType.tafsir)
    //         .then((value) => BlocProvider.of<HomeCubit>(context).changeIndex(1));
    //   },
    // ),
    // SubSectionItem(
    //   title: translate('Tajweed'),
    //   image: AppSVG.tajweed,
    //   subTitle: QuranCacheRepository.selectedTajweedName ?? '',
    //   action2: (context) {
    //     BlocProvider.of<QuranViewCubit>(context)
    //         .changePluginPageType(page: PageType.tajwid)
    //         .then((value) => BlocProvider.of<HomeCubit>(context).changeIndex(1));
    //   },
    // ),
    SubSectionItem(
      title: translate('Note'),
      image: AppSVG.note,
      action2: (context) {
        Navigator.of(context).pushNamed(NotesVersePage.routeName, arguments: 1);
      },
    ),
    SubSectionItem(
      title: translate('Likes'),
      image: AppSVG.favourite,
      action2: (context) {
        Navigator.of(context).pushNamed(LikedVersesPage.routeName);
      },
    ),
    SubSectionItem(
      title: translate('BookMarks'),
      image: AppSVG.bookmark,
      action2: (context) {
        //Get.to(const PagesBookMarkPage());
        Navigator.of(context)
            .pushNamed(PagesBookMarkPage.routeName, arguments: 2);
      },
    ),
  ];
}

class HomeMenuItems {
  List<BottomBarData> homeMenuItems = [
    BottomBarData(
      title: translate('Home'),
      iconData: AppIcons.homeIcon,
      activeIconData: AppIcons.homeIcon,
      badgeColor: AppColor.bottomHome,
      page: const HomeBNBPage(),
    ),
    BottomBarData(
      title: translate('Quran'),
      iconData: AppSVG.quranBNB,
      activeIconData: AppSVG.quranSelect,
      badgeColor: AppColor.bottomSaved,
      isSVG: true,
      page: QuranBNBPage(),
    ),
    BottomBarData(
      title: translate('Search'),
      iconData: AppSVG.search,
      activeIconData: AppSVG.search,
      isSVG: true,
      badgeColor: AppColor.bottomMenu,
      page: const SearchBNBPage(),
    ),
    BottomBarData(
      title: translate('Users'),
      iconData: AppSVG.users,
      activeIconData: AppSVG.users,
      isSVG: true,
      badgeColor: AppColor.bottomMenu,
      page: const UsersListing(),
    ),
  ];
}

String? _user() {
  String? teacherName = UserDataServices.instance.teacherName;

  return teacherName;
}
