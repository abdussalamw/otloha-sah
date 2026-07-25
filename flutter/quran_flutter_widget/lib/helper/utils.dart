import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/helper/q.dart';

class Utils {
  static double devicePixelRatio() => const MediaQueryData().devicePixelRatio;

  static double deviceWidthInPixel(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double deviceHeightInPixel(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  static bool isArabic() {
    return Q.selectedLocale.languageCode == Q.languageSettingArabicValue;
  }
  

  /*static Future<String> downloadFile(String url,String fileName) async{
    final request = await HttpClient().getUrl(Uri.parse(url));

    final response = await request.close();
    Directory tempDir = await getTemporaryDirectory();
    String path = "${tempDir.path}/$fileName";
    await response.pipe(File(path).openWrite());
    return path;
  }*/

  static void printLongLine(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  /*static Future<bool> checkPermission(Permission permission) async {
    */ /*  if (_checkPlatform(permission)) {
      return Future.value(true);
    }*/ /*
    var permissionStatus = await permission.request();
    if (permissionStatus.isGranted) {
      return Future.value(true);
    } else {
      return Future.value(false);
    }
  }

  static bool _checkPlatform(Permission permission) {
    if (Platform.isIOS) {
      return (permission == Permission.unknown ||
          permission == Permission.phone ||
          permission == Permission.sms ||
          permission == Permission.storage);
    } else {
      return (permission == Permission.unknown ||
          permission == Permission.mediaLibrary ||
          permission == Permission.photos ||
          permission == Permission.reminders ||
          permission == Permission.storage);
    }
  }*/

  static bool containsIgnoreCase(String string1, String string2) {
    return string1.toLowerCase().contains(string2.toLowerCase());
  }

  static Map<String, String> getParametersFromUrl(String url) {
    var uri = Uri.parse(url);
    uri.queryParameters.forEach((k, v) {
      print('key: $k - value: $v');
    });
    return uri.queryParameters;
  }

  /*static String getStringDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }*/

  /*static bool validatePhoneEgyptREGX(String value) {
    String number = NumberText.replaceAllNumberIntoEnglish(value);
    String pattern = r'^01[0-2]\d{8}$';
    RegExp regExp = new RegExp(pattern);
    bool result = regExp.hasMatch(number);
    return result;
  }

  static bool validatePhoneKsaREGX(String value) {
    String number = NumberText.replaceAllNumberIntoEnglish(value);
    String pattern =
        r'^(009665|9665|\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$';
    RegExp regExp = new RegExp(pattern);
    bool result = regExp.hasMatch(number);
    return result;
  }*/

  static bool validateEmailREGX(String value) {
    String pattern =
        r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    bool result = regExp.hasMatch(value);
    return result;
  }

  static bool validatePasswordREGX(String value) {
    String pattern = r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$';
    RegExp regExp = RegExp(pattern);
    bool result = regExp.hasMatch(value);
    return result;
  }

  static bool validateUsernameREGX(String value) {
    String pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regExp = RegExp(pattern);
    bool result = regExp.hasMatch(value);
    return result;
  }

  static bool validateNameREGX(String value) {
    String pattern =
        r'[!@#$%^&*(),.?":/\[/\]/\\/{}|<>;’_+=~٠١٢٣٤٥٦٧٨٩؟0123456789-]';
    RegExp regExp = RegExp(pattern);
    RegExp regExp2 = RegExp(r"[']");
    bool result = !regExp.hasMatch(value) && !regExp2.hasMatch(value);
    return result;
  }

  /*static String convertStringDate(String date) {
    return DateFormat('yyyy-MM-ddThh:mm:ss')
        .format(DateFormat('yyyy-MM-dd hh:mm:ss').parse(date));
  }

  static String convertStringDateToTime(String date) {
    return DateFormat('hh:mm a')
        .format(DateFormat('yyyy-MM-ddThh:mm:ss').parse(date));
  }*/

  static bool isToday(String elementDate) {
    DateTime nowDateTime = DateTime.now();
    DateTime elementTime = DateTime.parse(elementDate);
    DateTime elementDay =
        DateTime(elementTime.year, elementTime.month, elementTime.day);
    DateTime currentDay =
        DateTime(nowDateTime.year, nowDateTime.month, nowDateTime.day);

    if (currentDay == elementDay) {
      return true;
    } else {
      return false;
    }
  }

  static showDeleteDialog(BuildContext context, Widget child) {
    showGeneralDialog(
      barrierLabel: 'Barrier',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.center,
          child: child,
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim),
          child: child,
        );
      },
    );
  }

  static Widget reversWidget(Widget child) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(pi),
      child: child,
    );
  }
  /*static String convertNumbersIntoAr(dynamic number){
   return ArabicNumbers().convert(number);
  }*/
}
