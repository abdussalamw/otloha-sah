import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../../core/utils/themes/color.dart';

import '../../../../data_source/models/message_model/addresser.dart';

class UserNameView extends StatelessWidget {
  const UserNameView(
      {Key? key,
      required this.child,
      required this.typeUser,
      this.isCertified = false})
      : super(key: key);
  final Widget child;

  final TypeUser typeUser;
  final bool isCertified;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (isCertified)
          const Icon(
            Icons.verified_user,
            color: AppColor.iconColor5,
            size: 14,
          ),
        const SizedBox(width: 8),
        child,
      ],
    );
  }
}

getUserType(User? user) {
  if (user?.isTeacher ?? false) {
    return (user?.teacherProfile?.isCertified ?? false)
        ? TypeUser.paidTeacher
        : TypeUser.approvedTeacher;
  } else {
    return TypeUser.student;
  }
}

getUserType2(Addressee? user) {
  if (user?.isATeacher ?? false) {
    return (user?.teacherType == 'paid')
        ? TypeUser.paidTeacher
        : TypeUser.approvedTeacher;
  } else {
    return TypeUser.student;
  }
}

getUserType3(User? user) {
  if (user?.isTeacher ?? false) {
    return (user?.teacherProfile?.isCertified ?? false)
        ? TypeUser.paidTeacher
        : TypeUser.approvedTeacher;
  } else {
    return TypeUser.student;
  }
}

enum TypeUser {
  student,
  approvedTeacher,
  paidTeacher,
}
