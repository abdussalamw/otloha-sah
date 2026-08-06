import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/widgets/cached_image.dart';
import 'package:otloha_sah_flutter/core/widgets/user_avatar_widget.dart';
import 'package:otloha_sah_flutter/data_source/data_source.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_student_btn/student_to_student_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_teacher_btn/student_to_teacher_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_student_btn/teacher_to_student_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/student_to_student_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/teacher_to_student_btn.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/pages/student_profile.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    if (UserDataServices.instance.isATeacher) {
      return BlocProvider(
        create: (context) => TeacherToStudentBtnCubit(student: student),
        child: StudentCardWidget(student: student),
      );
    }
    return BlocProvider(
      create: (context) => StudentToStudentCubit(student: student),
      child: StudentCardWidget(student: student),
    );
  }
}

class StudentCardWidget extends StatelessWidget {
  const StudentCardWidget({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!UserDataServices.instance.isATeacher) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (pageContext) => BlocProvider.value(
                value: BlocProvider.of<StudentToStudentCubit>(context),
                child: StudentProfile(student: student),
              ),
            ),
          );
        } else if (UserDataServices.instance.isATeacher) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (pageContext) => BlocProvider.value(
                value: BlocProvider.of<TeacherToStudentBtnCubit>(context),
                child: StudentProfile(student: student),
              ),
            ),
          );
        }
        // Get.to(UserProfile(student: student));
      },
      child: Column(
        children: [
          Row(
            children: [
              UserAvatarWidget(
                isTeacher: false,
                imageUrl: student.image,
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
                            student.username,
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
                          student.rate,
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        FutureBuilder<String>(
                          future: AppDataSource()
                              .getNarrationNameById(student.narration ?? '0'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Text(
                                snapshot.data!,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 13),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (!UserDataServices.instance.isATeacher)
                SizedBox(
                  width: 100,
                  height: 30,
                  child: StudentToStudentBtn(student: student),
                ),
              if (UserDataServices.instance.isATeacher)
                SizedBox(
                  width: 100,
                  height: 30,
                  child: TeacherToStudentBtn(student: student),
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
