import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/cached_image.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/student_to_teacher_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/teacher_to_teacher_btn.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/teacher_profile_cubit/teacher_profile_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/teacher_profile_cubit/teacher_profile_state.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({
    super.key,
    required this.teacher,
  });
  final Teacher teacher;

  @override
  State<TeacherProfilePage> createState() => TeachereState();
}

class TeachereState extends State<TeacherProfilePage> {
  @override
  void initState() {
    BlocProvider.of<TeacherProfileCubit>(context)
        .fetchProfile(widget.teacher.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TeacherProfileCubit, TeacherProfileState>(
        builder: (context, state) {
          if (state is TeacherProfileLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          }
          if (state is TeacherProfileLoaded) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedImage(url: state.teacher.image, raduis: 45),
                        if (state.teacher.recitation != null)
                          statistics(state.teacher.recitation!, 'Recitations'),
                        statistics(state.teacher.khatma, 'Khatma'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          state.teacher.username,
                          style: TextStyle(
                            color: AppColor.headTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Text(
                              state.teacher.rate,
                              style:
                                  const TextStyle(color: AppColor.txtGrayColor),
                            )
                          ],
                        ),
                      ],
                    ),
                    if (state.teacher.bio != null) const SizedBox(height: 8),
                    if (state.teacher.bio != null)
                      Text(
                        state.teacher.bio!,
                        style: const TextStyle(color: AppColor.txtGrayColor),
                      ),
                    if (state.teacher.bio != null) const SizedBox(height: 8),
                    if (state.teacher.favoriteTeacher != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: AppColor.txtGrey,
                          ),
                          Text(
                            state.teacher.favoriteTeacher.toString(),
                            style:
                                const TextStyle(color: AppColor.txtGrayColor),
                          ),
                        ],
                      ),
                    if (state.teacher.bio == null) const SizedBox(height: 4),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.language,
                              color: AppColor.txtGrey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              state.teacher.language.toString(),
                              style:
                                  const TextStyle(color: AppColor.txtGrayColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.leaderboard,
                              color: AppColor.txtGrey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              state.teacher.level.toString(),
                              style:
                                  const TextStyle(color: AppColor.txtGrayColor),
                            ),
                          ],
                        ),
                        // if (state.teacher.narration != null)
                        //   Row(
                        //     children: [
                        //       const Icon(
                        //         Icons.headphones,
                        //         color: AppColor.txtGrey,
                        //       ),
                        //       const SizedBox(width: 5),
                        //       Text(
                        //         state.teacher.narration!,
                        //         style: const TextStyle(
                        //             color: AppColor.txtGrayColor),
                        //       ),
                        //     ],
                        //   ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (!UserDataServices.instance.isATeacher)
                      StudentToTeacherBtn(
                        teacher: widget.teacher.copyWith(
                          invitations: state.teacher.invitations,
                          relationships: state.teacher.relationships,
                        ),
                      ),
                    if (UserDataServices.instance.isATeacher)
                      TeacherToTeacherBtn(
                        teacher: widget.teacher.copyWith(
                          invitations: state.teacher.invitations,
                          relationships: state.teacher.relationships,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  statistics(int amount, String title) => Column(
        children: [
          Text(
            amount.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.headTextColor),
          ),
          Text(
            translate(title),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.headTextColor),
          ),
        ],
      );
}
