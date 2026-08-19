import 'dart:convert';
import 'dart:io';

import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/user/teacher_profile.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constant/constants.dart';
import '../../../../data_source/cache_helper.dart';
import '../../../../data_source/data_source.dart';
import '../../../../data_source/remote/firebase_service.dart';
import '../../../../data_source/user_services_data.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/narration_local_data_source.dart';
import 'package:quran_widget_flutter/model/explanation.dart';
import 'package:quran_widget_flutter/model/tajweed_model.dart';
import 'package:quran_widget_flutter/model/translation.dart';
import 'package:quran_widget_flutter/network_helper/network_exception.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  static SplashCubit get(context) => BlocProvider.of(context);

  static bool isLogin = UserDataServices.instance.isLogin;
  static User? user;
  static User? teacher;
  static TeacherProfile? teacherProfile;
  static Narration? missedNarrationCertification;
  static bool isBlocked = false;
  String titleProgress = '';
  double progress = 0;
  String minAppVersion = '4.0.0';

  saveProfileImage(String url, int userId) async {
    var documentDirectory = await getApplicationDocumentsDirectory();

    var filePathAndName =
        '${documentDirectory.path}${Constants.profileImagePath}$userId.png';
    await ApiBaseHelper().dio.download(url, filePathAndName);
  }

  getUsersInfo({User? fetchedUserprofile}) async {
    isLogin = UserDataServices.instance.isLogin;

    try {
      if (fetchedUserprofile == null) {
        user = await AppDataSource().myProfile();
      } else {
        user = fetchedUserprofile;
      }

      if (user != null) {
        await UserDataServices.instance.insertUser(user!);
      }
      if (user!.teacherProfile != null) {
        await CacheHelper.saveData(
          key: 'teacherProfile',
          value: jsonEncode(user!.teacherProfile!.toJson()),
        );
        teacherProfile = user!.teacherProfile;
      }
      if (SplashCubit.teacherProfile != null &&
          SplashCubit.teacherProfile!.certifications != null &&
          SplashCubit.teacherProfile!.certifications!.isNotEmpty) {
        var res = SplashCubit.teacherProfile!.certifications!
            .where((element) => element.minCount > element.recitationCount && !element.isCertified);

        if (res.isNotEmpty) {
          missedNarrationCertification = await NarrationLocalDataSource()
              .fetchNarrationById(res.first.narration);
        } else {
          missedNarrationCertification = null;
        }
      }
    } catch (e) {
      user = UserDataServices.instance.getUserDataFast();
      if (CacheHelper.getData(key: 'teacherProfile') != null) {
        teacherProfile = TeacherProfile.fromJson(
            jsonDecode(CacheHelper.getData(key: 'teacherProfile')));
      }
    }

    isBlocked = user?.isBlocked ?? false;

    teacher = await UserDataServices.instance.getFavTeacherData();
  }

  getInitDate() async {
    emit(SplashInitial());
    emit(LoadingState());

    try {
      final response = await ApiBaseHelper().getHTTP('/api/v1/min-app-version/',
          dioTypes: DioTypes.noAuthRequired).timeout(const Duration(seconds: 2));

      minAppVersion = response?.data['version'] ?? '4.0.0';
    } catch (e) {
      print('Min app version fetch skipped or timed out: $e');
    }

    try {
      await DataSource.instance
          .initialApp(baseUrl: Constants.baseUrl)
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      print('Timeout or error during initialApp: $e');
    }

    try {
      await initCacheData().timeout(const Duration(seconds: 4));
    } catch (e) {
      print('Error/Timeout during splash initCacheData: $e');
    }

    try {
      await DataSource.instance.loadQuranData();
      if (isLogin) {
        await getUsersInfo().timeout(const Duration(seconds: 3));

        if (isLogin && !Platform.isIOS) {
          FirebaseService.instance.initNotifications();
        }
      }
    } catch (e) {
      print('Error during splash userInfo/loadQuranData: $e');
    } finally {
      emit(
        SplashFinish(
          isBlocked: isBlocked,
          isProfileCompelete: (user?.username != null &&
              user?.birthdate != null &&
              user?.gender != null &&
              user!.phone != null),
          isPhoneVerified: user?.phoneVerifiedAt != null,
        ),
      );
    }
  }

  Future<void> initCacheData() async {
    List<Narration>? narrations;
    narrations = await DataSource.instance.fetchNarrationsList(
          onDownloadProgress: (val, total) {
            titleProgress = 'DownloadingNarrations';
            progress = (val / total);
            emit(DownloadingState(progress: progress));
          },
        ) ??
        [];
    int firstNarration = QuranCacheRepository.narrationSelectedId ?? (narrations.isNotEmpty ? narrations.first.id : 1);

    if (true) {
      List<Book> books = await DataSource.instance.fetchBooksList(
            narrationId: firstNarration,
            onDownloadProgress: (val, total) {
              titleProgress = 'DownloadingBook';
              progress = (val / total);
              emit(DownloadingState(progress: progress));
            },
          ) ??
          [];
      int firstBook = books.isNotEmpty ? books.first.id! : 0;

      List<Chapter> chapters = await DataSource.instance.fetchChaptersList(
            narrationId: firstNarration,
            bookId: firstBook,
            onDownloadProgress: (val, total) {
              titleProgress = 'DownloadingChapters';
              progress = (val / total);
              emit(DownloadingState(progress: progress));
            },
          ) ??
          [];
      int firstChapter = chapters.isNotEmpty ? chapters.first.id! : 0;

      await DataSource.instance.fetchRecitersList() ?? [];

      List<Recitation> recitations =
          await DataSource.instance.fetchRecitationsList(
                narrationId: firstNarration,
                onDownloadProgress: (val, total) {
                  titleProgress = 'DownloadingRecitations';
                  progress = (val / total);
                  emit(DownloadingState(progress: progress));
                },
              ) ??
              [];
      List<TajweedBook> tajweedBooks =
          await DataSource.instance.fetchTajweedBooksList() ?? [];
      List<Explanation> explanations =
          await DataSource.instance.fetchTafseerList() ?? [];
      List<Translation> taragama =
          await DataSource.instance.fetchTranslationList() ?? [];

      if (tajweedBooks.isNotEmpty) {
        QuranCacheRepository.setSelectedTajweedId(tajweedBooks.first.id ?? 1);
        QuranCacheRepository.setSelectedTajweedName(
            json.encode(tajweedBooks.first.name));
      } else if (QuranCacheRepository.selectedTajweedId == null) {
        QuranCacheRepository.setSelectedTajweedId(1);
      }

      if (taragama.isNotEmpty) {
        QuranCacheRepository.setQuranTranslationSelectedId(
            taragama.first.id ?? 1);
        QuranCacheRepository.setQuranTranslationSelectedName(
            json.encode(taragama.first.name));
      } else if (QuranCacheRepository.quranTranslationSelectedId == null) {
        QuranCacheRepository.setQuranTranslationSelectedId(1);
      }

      if (explanations.isNotEmpty) {
        QuranCacheRepository.setTafsirSelectedId(explanations.first.id ?? 1);
        QuranCacheRepository.setTafsirSelectedName(
            json.encode(explanations.first.name));
      } else if (QuranCacheRepository.tafsirSelectedId == null) {
        QuranCacheRepository.setTafsirSelectedId(1);
      }
      int firstRecitation = recitations.isNotEmpty ? recitations.first.id! : 1;

      await QuranCacheRepository.setNarrationSelectedId(
          QuranCacheRepository.narrationSelectedId ?? (firstNarration != 0 ? firstNarration : 1));
      if (narrations.isNotEmpty) {
        await QuranCacheRepository.setNarrationSelectedName(
            json.encode(narrations.first.name));
      }
      await QuranCacheRepository.setBookSelectedId(
          QuranCacheRepository.bookSelectedId ?? (firstBook != 0 ? firstBook : 1));
      if (books.isNotEmpty) {
        await QuranCacheRepository.setBookSelectedName(
            json.encode(books.first.name));
      }
      await QuranCacheRepository.setSelectedChapterId(
          QuranCacheRepository.selectedChapterId ?? (firstChapter != 0 ? firstChapter : 1));
      if (chapters.isNotEmpty) {
        await QuranCacheRepository.setSelectedChapterName(
            json.encode(chapters.first.name));
      }
      await QuranCacheRepository.setSelectedRecitationId(
          QuranCacheRepository.selectedRecitationId ?? firstRecitation);
      if (recitations.isNotEmpty) {
        await QuranCacheRepository.setSelectedRecitationName(
            json.encode(recitations.first.name));
      }
      await QuranCacheRepository.setSelectedReciterId(
          firstRecitation == 0 || recitations.isEmpty ? 1 : (recitations.first.reciter?.id ?? 1));

      await DataSource.instance.fetchPartsList(
        onDownloadProgress: (val, total) {
          titleProgress = 'LoadingParts';
          progress = (val / total);
          emit(DownloadingState(progress: progress));
        },
      );

      await DataSource.instance.fetchVersesList(
        onDownloadProgress: (val, total) {
          titleProgress = 'DownloadingQuran';
          progress = (val / total);
          emit(DownloadingState(progress: progress));
        },
      );
    }
  }

  static void signOut() {
    isLogin = false;
    user = null;
    teacher = null;
  }
}
