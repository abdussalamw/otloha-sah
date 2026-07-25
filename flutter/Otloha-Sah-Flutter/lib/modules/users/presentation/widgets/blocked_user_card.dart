import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/widgets/cached_image.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/unblock_btn_cubit/unblock_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/unblock_btn.dart';

class BlockCard extends StatelessWidget {
  const BlockCard({super.key, required this.blockedUser});
  final BlockedUser blockedUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnblockCubit(),
      child: UnblockWidget(blockedUser: blockedUser),
    );
  }
}

class UnblockWidget extends StatelessWidget {
  const UnblockWidget({
    super.key,
    required this.blockedUser,
  });

  final BlockedUser blockedUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CachedImage(url: blockedUser.user.image ?? '', raduis: 35),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          blockedUser.user.username,
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
                        blockedUser.user.rate,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        blockedUser.user.narration ?? '',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),

            BlocBuilder<UnblockCubit, UnblockState>(
              builder: (context, state) {
                if (state == UnblockState.loading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: LoadingWidget(),
                    ),
                  );
                } else if (state == UnblockState.unblocked) {
                  return const SizedBox();
                }
                return SizedBox(
                  height: 30,
                  width: 100,
                  child: UnblockBtn(onUnblock: () {
                    context.read<UnblockCubit>().unblock(blockedUser.id);
                  }),
                );
              },
            ),
            // if (!UserDataServices.instance.isATeacher)
            //   SizedBox(
            //     width: 100,
            //     height: 30,
            //     child: StudentToStudentBtn(student: student),
            //   ),
            // if (UserDataServices.instance.isATeacher)
            //   SizedBox(
            //     width: 100,
            //     height: 30,
            //     child: TeacherToStudentBtn(student: student),
            //   ),
          ],
        ),
        Divider(
          color: Colors.grey[200]!,
          indent: 80,
        ),
      ],
    );
  }
}
