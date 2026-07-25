import 'package:flutter/material.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../data_source/enums/roles.dart';
import 'role.dart';

class PickedRole extends StatelessWidget {
  final RoleTypes roleType;
  final Color circleColor;
  const PickedRole(this.roleType, this.circleColor);
  @override
  Widget build(BuildContext context) {
    return Role(
      backColor: AppColor.headTextColor,
      avatarColor: AppColor.white,
      circleAvatarColor: circleColor,
      roleType: roleType == RoleTypes.student
          ? translate('Student')
          : translate('Teacher'),
      textColor: AppColor.lightYellow,
    );
  }
}
