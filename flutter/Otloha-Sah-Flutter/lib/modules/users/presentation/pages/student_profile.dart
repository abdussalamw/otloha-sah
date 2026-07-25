import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/cached_image.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/student_to_student_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/teacher_to_student_btn.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/profile_cubit/profile_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/profile_cubit/profile_state.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({
    super.key,
    required this.student,
  });
  final Student student;

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  void initState() {
    BlocProvider.of<ProfileCubit>(context).fetchProfile(widget.student.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          }
          if (state is ProfileLoaded) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CachedImage(url: state.userProfile.image, raduis: 45),
                        statistics(state.userProfile.recitation, 'Recitations'),
                        statistics(state.userProfile.khatma, 'Khatma'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          state.userProfile.username,
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
                              color: Colors.orange,
                            ),
                            Text(
                              state.userProfile.rate,
                              style:
                                  const TextStyle(color: AppColor.txtGrayColor),
                            )
                          ],
                        ),
                      ],
                    ),
                    if (state.userProfile.bio != null)
                      const SizedBox(height: 8),
                    if (state.userProfile.bio != null)
                      Text(
                        state.userProfile.bio!,
                        style: const TextStyle(color: AppColor.txtGrayColor),
                      ),
                    if (state.userProfile.bio != null)
                      const SizedBox(height: 8),
                    Row(
                      children: [
                        if (state.userProfile.favoriteTeacher != null)
                          const Icon(
                            Icons.person,
                            color: AppColor.txtGrey,
                          ),
                        if (state.userProfile.favoriteTeacher != null)
                          Text(
                            state.userProfile.favoriteTeacher.toString(),
                            style:
                                const TextStyle(color: AppColor.txtGrayColor),
                          ),
                      ],
                    ),
                    if (state.userProfile.bio == null)
                      const SizedBox(height: 4),
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
                              translate(state.userProfile.language.toString()),
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
                              state.userProfile.level.toString(),
                              style:
                                  const TextStyle(color: AppColor.txtGrayColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.headphones,
                              color: AppColor.txtGrey,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              state.userProfile.narration.toString(),
                              style:
                                  const TextStyle(color: AppColor.txtGrayColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (UserDataServices.instance.isATeacher)
                      TeacherToStudentBtn(
                        student: widget.student.copyWith(
                          invitations: state.userProfile.invitations,
                          relationships: state.userProfile.relationships,
                        ),
                      ),
                    if (!UserDataServices.instance.isATeacher)
                      StudentToStudentBtn(
                        student: widget.student.copyWith(
                          invitations: state.userProfile.invitations,
                          relationships: state.userProfile.relationships,
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
              fontWeight: FontWeight.bold,
              color: AppColor.headTextColor,
              fontSize: 16,
            ),
          ),
          Text(
            translate(title),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.headTextColor,
              fontSize: 16,
            ),
          ),
        ],
      );
}
