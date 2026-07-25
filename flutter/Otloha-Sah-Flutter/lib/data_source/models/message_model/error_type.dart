import 'package:flutter/widgets.dart';
import '../../../core/utils/res/icons_app.dart';
import '../../../core/utils/themes/color.dart';

class ErrorType {
  static List<ErrorType> errors = [
    ErrorType(
        key: 'pronunciation',
        value: 'النطق',
        color: AppColor.conColorO,
        icon: AppIcons.voiceIcon),
    ErrorType(
        key: 'word',
        value: 'الكلمة',
        color: AppColor.lightYellow,
        icon: AppIcons.wordIcon),
    ErrorType(
        key: 'tajweed',
        value: 'التجويد',
        color: AppColor.txtColor5,
        icon: AppIcons.tajweedIcon),
  ];

  String key;
  String? value;
  String icon;
  Color color;
  ErrorType({
    required this.key,
    required this.value,
    required this.color,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
      'color': color.value,
    };
  }
}
