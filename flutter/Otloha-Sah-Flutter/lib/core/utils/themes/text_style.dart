import 'package:flutter/material.dart';
import '../constant/constants.dart';

import 'color.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  TextStyle get textStyle1 => GoogleFonts.cairo(
        textStyle: TextStyle(
          color: AppColor.txtColor1,
          fontFamily: Constants.fontFamily2,
          fontSize: 20,
        ),
      );

  TextStyle get textStyle2 => GoogleFonts.elMessiri(
        textStyle: const TextStyle(
          color: AppColor.white,
          fontFamily: Constants.fontFamily1,
          fontSize: 20,
        ),
      );
  TextStyle get textStyle3 => GoogleFonts.cairo(
        textStyle: TextStyle(
          color: AppColor.txtColor3,
          fontFamily: Constants.fontFamily2,
          fontSize: 20,
        ),
      );
  TextStyle get textStyle4 => GoogleFonts.cairo(
        textStyle: const TextStyle(
          color: AppColor.txtColor4,
          fontFamily: Constants.fontFamily2,
          fontSize: 20,
        ),
      );

  TextStyle get textStyle5 => GoogleFonts.cairo(
        textStyle: const TextStyle(
          color: AppColor.txtColor5,
          fontFamily: Constants.fontFamily2,
          fontSize: 20,
        ),
      );
}
