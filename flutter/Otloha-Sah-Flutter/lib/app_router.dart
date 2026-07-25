import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_lesson.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/lesson_page.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/levels_page.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/reserved_exams_listing.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/time_slot_listing.dart';
import 'package:path/path.dart';
import 'modules/auth_module/presentation/pages/login_page.dart';
import 'modules/auth_module/presentation/pages/onboard_page.dart';
import 'modules/auth_module/presentation/pages/register_steps.dart';
import 'modules/auth_module/presentation/pages/terms_conditions_page.dart';
import 'modules/home/presentation/pages/home/block_page.dart';
import 'modules/kahtma/presentation/pages/katama_comming_soon_page.dart';
import 'modules/messages/presentation_v2/pages/corrected_recitations_page.dart';
import 'modules/messages/presentation_v2/pages/markable_recitations_page.dart';
import 'modules/messages/presentation_v2/pages/general_box_page.dart';
import 'modules/messages/presentation_v2/pages/chating_page.dart';
import 'modules/messages/presentation_v2/pages/evaluation_page.dart';
import 'modules/messages/presentation_v2/pages/messages_page.dart';
import 'modules/settings/presentation/pages/downloads/chapter_download_tafseer_page.dart';
import 'modules/settings/presentation/pages/downloads/chapter_download_tajweed_page.dart';
import 'modules/settings/presentation/pages/downloads/chapter_download_targama_page.dart';
import 'modules/splash/presentation/page/splash_screen.dart';
import 'modules/home/presentation/pages/coming_soon/coming_soon_page.dart';
import 'modules/home/presentation/pages/home/home_page.dart';
import 'modules/recitations/presentation/page/recitations_page.dart';
import 'modules/messages/presentation_v2/pages/notifiactions_page.dart';
import 'modules/settings/presentation/pages/downloads/chapter_download_page.dart';
import 'modules/quran/presentation/page/chapters/index_surah_page.dart';
import 'modules/quran/presentation/page/action_pages/pages_liked_page.dart';
import 'modules/settings/presentation/pages/settings/books_page.dart';
import 'modules/settings/presentation/pages/settings/languages_page.dart';
import 'modules/settings/presentation/pages/settings/narration_page.dart';
import 'modules/settings/presentation/pages/settings/quran_translation_language_page.dart';
import 'modules/settings/presentation/pages/settings/recitation_page.dart';
import 'modules/settings/presentation/pages/settings_page.dart';
import 'modules/settings/presentation/pages/settings/tafseer_page.dart';
import 'modules/settings/presentation/pages/settings/tajweed_page.dart';
import 'modules/tajweed/presentation/pages/tajweed_comming_soon_page.dart';
import 'modules/teachers/presentation/page/students_page.dart';
import 'modules/teachers/presentation/page/teacher_page.dart';

import 'data_source/local/database/database_repository.dart';
import 'modules/quran/presentation/page/action_pages/bookmark_bage.dart';
import 'modules/quran/presentation/page/action_pages/note_page.dart';

class AppRouter {
  late DatabaseRepository databaseRepository;

  AppRouter() {
    databaseRepository = DatabaseRepository();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case OnBoardPage.routeName:
        return PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          pageBuilder: (_, __, ___) => const OnBoardPage(),
          settings: settings,
        );
      case SplashScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case Routes.messageCorrect:
        return MaterialPageRoute(
          builder: (_) => const CorrectedRecitationsPage(),
          settings: settings,
        );
      case Routes.messageMarkable:
        return MaterialPageRoute(
          builder: (_) => const MarkableRecitationsPage(),
          settings: settings,
        );
      case Routes.messageTeacher:
        return MaterialPageRoute(
          builder: (_) => const MarkableRecitationsPage(isTeacherData: true),
          settings: settings,
        );
      case LoginPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case NotesVersePage.routeName:
        return MaterialPageRoute(
          builder: (_) => const NotesVersePage(),
          settings: settings,
        );
      case HomePage.routeName:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case Routes.generalBox:
        return MaterialPageRoute(
          builder: (_) => const GeneralMessagePage(),
          settings: settings,
        );
      case TeacherPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const TeacherPage(),
          settings: settings,
        );
      case StudentsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const StudentsPage(),
          settings: settings,
        );
      case IndexSurahPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const IndexSurahPage(),
          settings: settings,
        );
      case ChapterDownloadPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const ChapterDownloadPage(),
          settings: settings,
        );
      case SettingsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const SettingsPage(),
          settings: settings,
        );
      case BooksPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const BooksPage(),
          settings: settings,
        );
      case LanguagesPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const LanguagesPage(),
          settings: settings,
        );
      case NarrationPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const NarrationPage(),
          settings: settings,
        );
      case QuranTranslationLanguagePage.routeName:
        return MaterialPageRoute(
          builder: (_) => const QuranTranslationLanguagePage(),
          settings: settings,
        );
      case RecitationsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const RecitationsPage(),
          settings: settings,
        );
      case TafseerPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const TafseerPage(),
          settings: settings,
        );
      case ComingSoonPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const ComingSoonPage(),
          settings: settings,
        );

      case LikedVersesPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const LikedVersesPage(),
          settings: settings,
        );
      case PagesBookMarkPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const PagesBookMarkPage(),
          settings: settings,
        );
      case RecitationPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const RecitationPage(),
          settings: settings,
        );
      case TajweedPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const TajweedPage(),
          settings: settings,
        );

      case Routes.notify:
        return MaterialPageRoute(
          builder: (_) => const NotifiactionsPage(),
          settings: settings,
        );
      case ChapterDownloadTajweedPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const ChapterDownloadTajweedPage(),
          settings: settings,
        );
      case ChapterDownloadTafseerPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const ChapterDownloadTafseerPage(),
          settings: settings,
        );
      case ChapterDownloadTargamaPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const ChapterDownloadTargamaPage(),
          settings: settings,
        );
      case Routes.messages:
        return MaterialPageRoute(
          builder: (_) => const MessagesPage(),
          settings: settings,
        );
      case Routes.evaluation:
        return MaterialPageRoute(
          builder: (_) => const EvaluationPage(),
          settings: settings,
        );
      case Routes.chatingPage:
        return MaterialPageRoute(
          builder: (_) => const ChatingPage(),
          settings: settings,
        );

      case TajweedCommingSoonPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const TajweedCommingSoonPage(),
          settings: settings,
        );
      case KhatmaCommingSoonPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const KhatmaCommingSoonPage(),
          settings: settings,
        );
      case Routes.registerSteps:
        return MaterialPageRoute(
          builder: (_) => const RegisterStepsPage(),
          settings: settings,
        );
      case TermsAndConditions.routeName:
        return MaterialPageRoute(
          builder: (_) => TermsAndConditions(),
          settings: settings,
        );
      case BlockedPage.route:
        return MaterialPageRoute(
          builder: (_) => BlockedPage(),
          settings: settings,
        );
      case TajweedLevelsPage.routeName:
        return MaterialPageRoute(
          builder: (_) => TajweedLevelsPage(),
          settings: settings,
        );
      case LessonPage.routeName:
        return MaterialPageRoute(
          builder: (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as TajweedLesson;
            return LessonPage(lesson: args);
          },
          settings: settings,
        );
      case TimeSlotsListingPage.route:
        return MaterialPageRoute(
          builder: (_) => const TimeSlotsListingPage(),
          settings: settings,
        );
      case ReservedExamsListing.route:
        return MaterialPageRoute(
          builder: (_) => const ReservedExamsListing(),
          settings: settings,
        );
    }
    return null;
  }
}

class Routes {
  static const String messages = '/messages';
  static const String notify = '/notify';
  static const String chatingPage = '/chat';
  static const String chatingClosedPage = '/chat/closed';
  static const String generalBox = '/generalBox';
  static const String allMessage = '/allMessage';
  static const String messageMarkable = '/message/markable';
  static const String messageTeacher = '/message/teacher';
  static const String messageCorrect = '/message/correct';
  static const String evaluation = '/messages/evaluation';
  static const String registerSteps = '/auth/steps';
}
