import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../data_source/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

const themeKey = 'THEMEKEY';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial()) {
    // themeMode = (CacheHelper.getData(key: themeKey) ?? false)
    //     ? ThemeMode.dark
    //     : ThemeMode.light;
  }

  static bool isDark = false;

  static ThemeCubit get(BuildContext context) => BlocProvider.of(context);

  ThemeMode themeMode = isDark ? ThemeMode.dark : ThemeMode.light;


  changeTheme() {
    themeMode =
        (themeMode == ThemeMode.dark) ? ThemeMode.light : ThemeMode.dark;

    isDark = themeMode == ThemeMode.dark;

    CacheHelper.saveData(key: themeKey, value: themeMode == ThemeMode.dark);

    AppColor.txtColor1 = isDark ? Colors.white : Colors.black;

    AppColor.txtColor3 =
        isDark ? const Color(0xff01cffd) : const Color(0xff223c8c);

    AppColor.background = isDark
        ? const Color.fromARGB(255, 40, 40, 40)
        : const Color.fromARGB(255, 255, 255, 255);

    AppColor.gradient4 = isDark
        ? const Color.fromARGB(255, 60, 60, 60)
        : const Color(0xFFe9fbff);

    emit(ThemeChange(themeMode));
  }
}
