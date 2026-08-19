import 'package:quran_widget_flutter/network_helper/apis.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static const String fontFamily1 = 'Beiruti';
  static const String fontFamily2 = 'ElMessiri';
  static const String fontFamily3 = 'Hafs20';

  static const String userDemo =
      'https://www.kindpng.com/picc/m/557-5575215_2020-profile-circle-hd-png-download.png';

  static const String protocol = 'https';
  static const String socketProtocol = 'wss';

  // static String baseUrl =
  //     isTesting ? '$protocol://o.itqadem.com' : '$protocol://app.otlohasah.org';
  static get socketUrl => isTesting
      ? dotenv.env['TESTING_SOCKET_URL']
      : dotenv.env['PRODUCTION_SOCKET_URL'];

  static get baseUrl => isTesting
      ? dotenv.env['TESTING_BASE_URL']
      : dotenv.env['PRODUCTION_BASE_URL'];

  static String appIconUrl = '$baseUrl/static/images/app_icon.png';

  static String get prefix => Apis.baseUrl;

  static const String accept = 'accept';
  static const String reject = 'reject';
  static const String report = 'report';
  static const String finish = 'finish';
  static const String toggleShowInGeneral = 'toggle_show_in_general';
  static const String markAsRemarkableAction = 'toggle_show_in_remarkable';

  static const String userIdKey = 'UserIdLogin';
  static const String tokenKey = 'TokenLogin';
  static const String tokenRefrechKey = 'TokenRefrechKey';
  static const String userDataKey = 'UserDataLogin';
  static const String teacherProfile = 'teacherProfile';
  static const String firstTimeFlag = 'firstTimeFlag';

  static int? favTeacherId;

  static bool isEn = false;

  static const String languagesSelectedName = 'LanguagesSelectedName';
  static const String languagesSelectedId = 'LanguagesSelectedId';

  static const bool kReleaseMode = true;

  static const String profileImagePath = '/profile/image/user/';

  static const bool hasOTP = false;

  static bool isTesting = false;

  static const languages = {'ar'};
}
