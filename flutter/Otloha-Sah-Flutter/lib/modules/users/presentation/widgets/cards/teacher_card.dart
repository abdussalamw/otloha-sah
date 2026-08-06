import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/cached_image.dart';
import 'package:otloha_sah_flutter/core/widgets/user_avatar_widget.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_teacher_btn/student_to_teacher_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_teacher_btn/teacher_to_student_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/student_to_teacher_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/teacher_to_teacher_btn.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/pages/teacher_profile.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({
    super.key,
    required this.teacher,
  });
  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    if (!UserDataServices.instance.isATeacher) {
      return BlocProvider(
        create: (context) => StudentToTeacherBtnCubit(teacher: teacher),
        child: TeacherCardWidget(teacher: teacher),
      );
    }
    return BlocProvider(
      create: (context) => TeacherToTeacherCubit(teacher: teacher),
      child: TeacherCardWidget(teacher: teacher),
    );
  }
}

class TeacherCardWidget extends StatelessWidget {
  const TeacherCardWidget({
    super.key,
    required this.teacher,
  });

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!UserDataServices.instance.isATeacher) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (pageContext) => BlocProvider.value(
                value: BlocProvider.of<StudentToTeacherBtnCubit>(context),
                child: TeacherProfilePage(teacher: teacher),
              ),
            ),
          );
        } else if (UserDataServices.instance.isATeacher) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (pageContext) => BlocProvider.value(
                value: BlocProvider.of<TeacherToTeacherCubit>(context),
                child: TeacherProfilePage(teacher: teacher),
              ),
            ),
          );
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              UserAvatarWidget(
                isTeacher: true,
                imageUrl: teacher.image,
                radius: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            teacher.username,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xffFF9D2B),
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          teacher.rate,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                    RichText(
                      textAlign: TextAlign.start,
                      softWrap: true,
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        // : Colors.lightBlue[50],

                        children: [
                          TextSpan(
                            text: tr('Hafs'),
                            style: TextStyle(
                              color: (teacher.narrations?.contains(
                                        TeacherNarrartion(
                                            isCertified: true, narration: 1),
                                      ) ??
                                      false)
                                  ? AppColor.lightBlue
                                  : AppColor.txtGrey,
                            ),
                          ),
                          const TextSpan(text: ', '),
                          TextSpan(
                            text: tr('Warsh'),
                            style: TextStyle(
                              color: (teacher.narrations?.contains(
                                        TeacherNarrartion(
                                            isCertified: true, narration: 2),
                                      ) ??
                                      false)
                                  ? AppColor.lightBlue
                                  : AppColor.txtGrey,
                            ),
                          ),
                          const TextSpan(text: ', '),
                          TextSpan(
                            text: tr('Qaloon'),
                            style: TextStyle(
                              color: (teacher.narrations?.contains(
                                        TeacherNarrartion(
                                            isCertified: true, narration: 3),
                                      ) ??
                                      false)
                                  ? AppColor.lightBlue
                                  : AppColor.txtGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Row(
                    //   children: [
                    //     // Text(
                    //     //   'hafs,warsh,qaloon',
                    //     //   style:
                    //     //       TextStyle(color: Colors.grey[600], fontSize: 13),
                    //     // ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              // const Spacer(),
              if (!UserDataServices.instance.isATeacher)
                SizedBox(
                  width: 100,
                  height: 30,
                  child: StudentToTeacherBtn(teacher: teacher),
                ),
              if (UserDataServices.instance.isATeacher)
                SizedBox(
                  width: 100,
                  height: 30,
                  child: TeacherToTeacherBtn(teacher: teacher),
                ),
            ],
          ),
          Divider(
            color: Colors.grey[200]!,
            indent: 80,
          ),
        ],
      ),
    );
  }
}
