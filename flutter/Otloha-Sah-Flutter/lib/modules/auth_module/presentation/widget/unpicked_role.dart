import 'package:flutter/material.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../data_source/enums/roles.dart';
import 'role.dart';

class UnpickedRole extends StatelessWidget {
  final RoleTypes roleType;
  final Color circleColor;
  final Color avatarColor;
  const UnpickedRole(this.roleType, this.circleColor, this.avatarColor);
  @override
  Widget build(BuildContext context) {
    return Role(
        backColor: AppColor.white,
        avatarColor: avatarColor,
        circleAvatarColor: circleColor,
        roleType: roleType == RoleTypes.student
            ? translate('Student')
            : translate('Teacher'),
        textColor: AppColor.conColor5);
  }
}
