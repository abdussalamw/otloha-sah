import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/bloc/app_bloc_observer.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/remote/tajweed_service.dart';
import 'package:otloha_sah_flutter/firebase_options.dart';
import 'package:otloha_sah_flutter/modules/audio/business_logic/playback_manager.dart';
import 'package:otloha_sah_flutter/modules/entities/cubit/entities_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/invitation_recieved_list/invitation_recieved_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/settings/business_logic/internet_connection/internet_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/lesson_cubit/lesson_cubit_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/level_card_cubit/level_card_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/entities_list_cubit/entities_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/my_friends_list_cubit/friends_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/my_students_cubit/my_students_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/profile_cubit/profile_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/search/search_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/students_list_cubit/students_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/teacher_profile_cubit/teacher_profile_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/teachers_list_cubit/teachers_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/levels_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:retry_queue_manager/retry_queue_manager.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:slack_logger/slack_logger.dart';

import 'app_router.dart';
import 'core/resources/theme_manager.dart';
import 'core/utils/services/navigator_service.dart';
import 'core/utils/themes/color.dart';
import 'core/widgets/text_view.dart';
import 'data_source/cache_helper.dart';
import 'data_source/local/database/database_repository.dart';
import 'modules/audio/business_logic/cubit/player_cubit.dart';
import 'modules/auth_module/business_logic/auth_cubit.dart';
import 'modules/home/business_logic/cubit/home_cubit.dart';
import 'modules/home/business_logic/cubit/main_channel_cubit.dart';
import 'modules/messages/business_logic/cubit/messagedetails_cubit.dart';
import 'modules/messages/business_logic/cubit/notifications_cubit.dart';
import 'modules/messages/business_logic/cubit/reply_cubit.dart';
import 'modules/messages/business_logic_v2/cubit/chat_cubit.dart';
import 'modules/messages/business_logic_v2/cubit/corrected_recitations_cubit.dart';
import 'modules/messages/business_logic_v2/cubit/genaralmessage_cubit.dart';
import 'modules/messages/business_logic_v2/cubit/markable_recitations_cubit.dart';
import 'modules/messages/business_logic_v2/cubit/message_details_cubit.dart';
import 'modules/messages/business_logic_v2/cubit/record_cubit.dart';
import 'modules/messages/business_logic_v2/cubit/rooms_cubit.dart';
import 'modules/notifications/business_logic/cubit/notification_cubit.dart';
import 'modules/profile/business_logic/profile_pic_cubit/profile_page_cubit.dart';
import 'modules/profile/business_logic/profile_pic_cubit/update_profile_cubit.dart';
import 'modules/quran/business_logic/cubit/addnote_cubit.dart';
import 'modules/quran/business_logic/cubit/ballview_cubit.dart';
import 'modules/quran/business_logic/cubit/getuserquranaction_cubit.dart';
import 'modules/quran/business_logic/cubit/progress/progress_cubit.dart';
import 'modules/quran/business_logic/cubit/quran_cubit.dart';
import 'modules/quran/business_logic/cubit/quranplayer_cubit.dart';
import 'modules/quran/business_logic/cubit/recitation_cubit.dart';
import 'modules/recitations/business_logic/cubit/popup_action_cubit.dart';
import 'modules/recitations/business_logic/cubit/teachersend_cubit.dart';
import 'modules/recitations/business_logic/cubit/userrecitation_cubit.dart';
import 'modules/settings/business_logic/book/book_cubit.dart';
import 'modules/settings/business_logic/chapter/chapter_cubit.dart';
import 'modules/settings/business_logic/downloads/downloadchapter_cubit.dart';
import 'modules/settings/business_logic/downloads/downloads_cubit.dart';
import 'modules/settings/business_logic/language/language_cubit.dart';
import 'modules/settings/business_logic/narration/changenarration_cubit.dart';
import 'modules/settings/business_logic/narration/narration_cubit.dart';
import 'modules/settings/business_logic/privacy_groups/privacy_groups_cubit.dart';
import 'modules/settings/business_logic/quraan_translation_cubit/quran_translation_cubit.dart';
import 'modules/settings/business_logic/recitations/recitations_cubit.dart';
import 'modules/settings/business_logic/settings/settings_cubit.dart';
import 'modules/settings/business_logic/tafseer_cubit/tafsir_cubit.dart';
import 'modules/settings/business_logic/tajweed/tajweed_cubit.dart';
import 'modules/settings/business_logic/themes/theme_cubit.dart';
import 'modules/splash/business_logic/cubit/splash_cubit.dart';
import 'modules/teachers/business_logic/cubit/teacherviewtype_cubit.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('DotEnv load error: $e');
  }

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  QueueManager(apiHandler: ApiBaseHelper()).init();

  if (kDebugMode) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
  }
  await initMain();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Bloc.observer = AppBlocObserver();
  QueueManager(apiHandler: ApiBaseHelper()).logSavedRequests();

  if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    _startApp();
  } else {
    try {
      await SentryFlutter.init(
        (options) {
          options.dsn = dotenv.env['SENTRY_DSN'];
          options.tracesSampleRate = 1.0;
          options.profilesSampleRate = 1.0;
        },
        appRunner: () => _startApp(),
      );
    } catch (e) {
      debugPrint('Sentry init error: $e');
      _startApp();
    }
  }
}

void _startApp() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) {
        return EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/lang',
          useOnlyLangCode: true,
          saveLocale: true,
          fallbackLocale: const Locale('en'),
          useFallbackTranslations: true,
          child: OtlohaSahApp(
            appRouter: AppRouter(),
          ),
          errorWidget: (FlutterError? message) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: TextView(
                    padding: const EdgeInsets.all(32),
                    text: message!.message.toString(),
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
  );
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

initMain() async {
  try {
    await EasyLocalization.ensureInitialized();
  } catch(e) {
    debugPrint('EasyLocalization init error: $e');
  }

  // todo: delete
  HttpOverrides.global = DevHttpOverrides();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColor.statusBarColor,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  try {
    //init DateBase
    await DatabaseRepository().initDb;
    await CacheHelper.init();
  } catch (e) {
    debugPrint('DB or Cache init error: $e');
  }
}

class OtlohaSahApp extends StatelessWidget {
  final AppRouter appRouter;

  const OtlohaSahApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var databaseRepository = DatabaseRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InternetCubit(Connectivity()),
          lazy: false,
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => ReplyCubit(),
        ),
        BlocProvider(
          create: (context) => TeacherSendCubit(),
        ),
        BlocProvider(
          create: (context) => MessagedetailsCubit(),
        ),
        BlocProvider(
          create: (context) => PopupActionsCubit(),
        ),
        BlocProvider(
          create: (context) => QuranViewCubit(),
        ),
        BlocProvider(
          create: (context) => RecitationAddCubit(),
        ),
        BlocProvider(
          create: (context) => QuranPlayerCubit(),
        ),
        BlocProvider(
          create: (context) => TeacherviewtypeCubit(),
        ),
        BlocProvider(
          create: (context) => ChapterCubit(),
        ),
        BlocProvider(
          create: (context) => SettingsCubit(),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider(
          create: (context) => NarrationCubit(),
        ),
        BlocProvider(
          create: (context) => RecitationsCubit(),
        ),
        BlocProvider(
          create: (context) => RecitationsCubit(),
        ),
        BlocProvider(
          create: (context) => GetUserQuranActionCubit(databaseRepository),
        ),
        BlocProvider(
          create: (context) => UserRecitationCubit(),
        ),
        BlocProvider(
          create: (context) => TajweedCubit(),
        ),
        BlocProvider(
          create: (context) => GenaralmessageCubit(),
        ),
        BlocProvider(
          create: (context) => BookCubit(),
        ),
        BlocProvider(
          create: (context) => ProfilePageCubit(),
        ),
        BlocProvider(
          create: (context) => QuranTranslationCubit(),
        ),
        BlocProvider(
          create: (context) => TafsirCubit(),
        ),
        BlocProvider(
          create: (context) => TajweedCubit(),
        ),
        BlocProvider(
          create: (context) => BallViewCubit(),
        ),
        BlocProvider(
          create: (context) => SplashCubit(),
        ),
        BlocProvider(
          create: (context) => AddNoteCubit(),
        ),
        BlocProvider(
          create: (context) => DownloadChapterCubit(),
        ),
        BlocProvider(
          create: (context) => DownloadCubit(),
        ),
        BlocProvider(
          create: (context) => ChangenarrationCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => MessageDetailsCubit(),
        ),
        BlocProvider(
          create: (context) => ChatCubit(),
        ),
        BlocProvider(
          create: (context) => PlaybackManagerCubit(),
        ),
        BlocProvider(
          create: (context) => RoomsCubit(),
        ),
        BlocProvider(
          create: (context) => MarkableRecitationsCubit(),
        ),
        BlocProvider(
          create: (context) => RecordCubit(),
        ),
        BlocProvider(
          create: (context) => CorrectedRecitationsCubit(),
        ),
        BlocProvider(
          create: (context) => NotificationsCubit(),
        ),
        BlocProvider(
          create: (context) => MainChannelCubit(),
        ),
        BlocProvider(
          create: (context) => ProgressCubit(),
        ),
        BlocProvider(
          create: (context) => UpdateProfileCubit(),
        ),
        BlocProvider(
          create: (context) => PrivacyGroupsCubit(),
        ),
        BlocProvider(
          create: (context) => NotificationIconCubit(),
        ),
        BlocProvider(
          create: (context) => SearchCubit(),
        ),
        BlocProvider(
          create: (context) => InvitationRecievedCubit(),
        ),
        BlocProvider(
          create: (context) => StudentsListCubit(
            pagingController: PagingController(firstPageKey: 1),
            searchCubit: SearchCubit(),
          ),
        ),
        BlocProvider(
          create: (context) => MyStudentsCubit(
              pagingController: PagingController(firstPageKey: 1)),
        ),
        BlocProvider(
          create: (context) => TeachersListCubit(
              pagingController: PagingController(firstPageKey: 1)),
        ),
        BlocProvider(
          create: (context) => FriendsListCubit(
              pagingController: PagingController(firstPageKey: 1)),
        ),
        BlocProvider(
          create: (context) => EntitiesListCubit(
              pagingController: PagingController(firstPageKey: 1)),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(),
        ),
        BlocProvider(
          create: (context) => TeacherProfileCubit(),
        ),
        BlocProvider(
          create: (context) => LevelCardCubit(),
        ),
        BlocProvider(
          create: (context) => LessonCubit(TajweedService()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return OverlaySupport(
            child: GetMaterialApp(
              localizationsDelegates: [
                FormBuilderLocalizations.delegate,
                ...context.localizationDelegates
              ],
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              debugShowCheckedModeBanner: false,
              theme: getApplicationLightTheme(),
              darkTheme: getApplicationDarkTheme(),
              themeMode: ThemeCubit.get(context).themeMode,
              onGenerateRoute: appRouter.generateRoute,
              navigatorKey: NavigationService().navigatorKey,
              // initialRoute: TajweedLevelsPage.routeName,
            ),
          );
        },
      ),
    );
  }
}
