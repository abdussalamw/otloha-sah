import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constant/constants.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());

  Future<void> changeLan(bool isEnC, BuildContext context) async {
    final locale = Locale(isEnC ? 'en' : 'ar');
    await context.setLocale(locale);

    Constants.isEn = isEnC;
    LanguageCode.locale = locale.languageCode;
    await Get.updateLocale(locale);
    emit(LanguageChange());
  }
}

class LanguageCode {
  getLang(context) {
    locale = Get.locale!.languageCode;
  }

  static String locale = 'en';
}
