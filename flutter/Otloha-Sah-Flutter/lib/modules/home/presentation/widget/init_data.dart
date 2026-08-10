import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'package:otloha_sah_flutter/modules/kahtma/presentation/pages/katama_comming_soon_page.dart';
import 'package:otloha_sah_flutter/modules/messages/presentation_v2/pages/corrected_recitations_page.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/levels_page.dart';
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
import '../../../../data_source/cache_helper.dart';
import '../../../quran_hafs/presentation/pages/quran_hafs_page.dart';
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
        Navigator.of(context)
            .pushNamed(PagesBookMarkPage.routeName, arguments: 2);
      },
    ),
  ];
}

class HomeMenuItems {
  // Quran page is positioned as the exact CENTER (middle) item in the bottom bar (Index 2)
  List<BottomBarData> homeMenuItems = [
    BottomBarData(
      title: translate('Home'),
      iconData: AppIcons.homeIcon,
      activeIconData: AppIcons.homeIcon,
      badgeColor: AppColor.bottomHome,
      page: const HomeBNBPage(),
    ),
    BottomBarData(
      title: translate('CorrectedRecitations'),
      iconData: AppSVG.recitations,
      activeIconData: AppSVG.recitations,
      isSVG: true,
      badgeColor: AppColor.bottomMenu,
      page: const CorrectedRecitationsPage(),
    ),
    BottomBarData(
      title: translate('Quran'),
      iconData: AppSVG.quranBNB,
      activeIconData: AppSVG.quranSelect,
      badgeColor: AppColor.bottomSaved,
      isSVG: true,
      page: (CacheHelper.getData(key: 'selected_narration_id') == 1)
          ? const QuranHafsPage()
          : const QuranBNBPage(),
    ),
    BottomBarData(
      title: translate('Tafsir'),
      iconData: AppSVG.chapter,
      activeIconData: AppSVG.chapter,
      isSVG: true,
      badgeColor: AppColor.bottomMenu,
      page: const QuranBNBPage(initialPageType: PageType.tafsir),
    ),
    BottomBarData(
      title: translate('Tajweed'),
      iconData: AppSVG.special,
      activeIconData: AppSVG.special,
      isSVG: true,
      badgeColor: AppColor.bottomMenu,
      page: TajweedLevelsPage(),
    ),
  ];
}

String? _user() {
  String? teacherName = UserDataServices.instance.teacherName;
  return teacherName;
}
