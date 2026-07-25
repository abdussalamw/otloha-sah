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
  String titleProgress = 'Dawnloading...';
  double progress = 0;
  String minAppVersion = '1.0.0';

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
        // await UserDataServices.instance.updateUserData(user!);
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
          dioTypes: DioTypes.noAuthRequired);

      minAppVersion = response?.data['version'] ?? '1.0.0';
      print('min aaaaaaaaaaaaaaap verssssssssssion $minAppVersion');
    } catch (e) {
      print(e);
    }

    try {
      await DataSource.instance.initialApp(
        clientId: Constants.clientId,
        clientSecret: Constants.clientSecret,
      );
    } on NetworkConnectionExceptionOnTocken catch (e) {
      ExceptionHandling.hanleToastFromException(e, fromPackage: true);
    }

    await initCacheData();
    DataSource.instance.loadQuranData();
    if (isLogin) {
      await getUsersInfo();

      if (isLogin && !Platform.isIOS) {
        await FirebaseService.instance.initNotifications();
      }
    }
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

  Future<void> initCacheData() async {
    List<Narration>? narrations;
    int? firstNarration;
    if (QuranCacheRepository.narrationSelectedId == null) {
      narrations = await DataSource.instance.fetchNarrationsList(
            onDownloadProgress: (val, total) {
              titleProgress = 'DownloadingNarrations';
              progress = (val / total);
              emit(DownloadingState(progress: progress));
            },
          ) ??
          [];
      firstNarration = narrations.isNotEmpty ? narrations.first.id : 0;
    }

    if (firstNarration != null) {
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
            json.encode(tajweedBooks.first.name?.toJson()));
      }

      if (taragama.isNotEmpty) {
        QuranCacheRepository.setQuranTranslationSelectedId(
            taragama.first.id ?? 1);
        QuranCacheRepository.setQuranTranslationSelectedName(
            json.encode(taragama.first.name?.toJson()));
      }

      if (explanations.isNotEmpty) {
        QuranCacheRepository.setTafsirSelectedId(explanations.first.id ?? 1);
        QuranCacheRepository.setTafsirSelectedName(
            json.encode(explanations.first.name?.toJson()));
      }
      int firstRecitation = recitations.isNotEmpty ? recitations.first.id! : 0;

      await QuranCacheRepository.setNarrationSelectedId(firstNarration);
      await QuranCacheRepository.setNarrationSelectedName(firstNarration == 0
          ? ''
          : json.encode(narrations!.first.name.toJson()));
      await QuranCacheRepository.setBookSelectedId(firstBook);
      await QuranCacheRepository.setBookSelectedName(
          firstBook != 0 ? json.encode(books.first.name!.toJson()) : '');
      await QuranCacheRepository.setSelectedChapterId(firstChapter);
      await QuranCacheRepository.setSelectedChapterName(
          firstChapter != 0 ? json.encode(chapters.first.name!.toJson()) : '');
      await QuranCacheRepository.setSelectedRecitationId(firstRecitation);
      await QuranCacheRepository.setSelectedRecitationName(firstRecitation == 0
          ? ''
          : json.encode(recitations.first.name!.toJson()));
      await QuranCacheRepository.setSelectedReciterId(
          firstRecitation == 0 ? 0 : recitations.first.reciter!.id!);

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
    // UserDataServices.instance.signOut();
  }
}
