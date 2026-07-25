import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/action_button.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/alert_popup.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_teacher_btn/teacher_to_student_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_teacher_btn/teacher_to_student_btn_state.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/base_dialog.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/block_dialog.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/response_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/unblock_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/unfriend_dialog.dart';

class TeacherToTeacherBtn extends StatefulWidget {
  const TeacherToTeacherBtn({
    super.key,
    required this.teacher,
  });

  final Teacher teacher;

  @override
  State<TeacherToTeacherBtn> createState() => _TeacherToTeacherBtnState();
}

class _TeacherToTeacherBtnState extends State<TeacherToTeacherBtn>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TeacherToTeacherBtnWidget(teacher: widget.teacher);
  }

  @override
  bool get wantKeepAlive => true;
}

class TeacherToTeacherBtnWidget extends StatelessWidget {
  const TeacherToTeacherBtnWidget({
    super.key,
    required this.teacher,
  });

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherToTeacherCubit, TeacherToTeacherBtnState>(
      builder: (context, state) {
        if (state is TeacherToTeacherBtnLoadingState) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              width: 20,
              height: 20,
              child: LoadingWidget(),
            ),
          );
        }

        if (state is TeacherToTeacherWithRequestedInvitation) {
          return ResponseBtn(
            username: teacher.username,
            inFriend: teacher.invitations.inFriendRequest != null,
            inSupervision: false,
            onAcceptFriendRequest: () {
              BlocProvider.of<TeacherToTeacherCubit>(context)
                  .acceptFriendRequest();
            },
            onAcceptSupervisionRequest: () {},
            onRejectFriendRequest: () {
              BlocProvider.of<TeacherToTeacherCubit>(context)
                  .rejectFriendRequest();
            },
            onRejectSupervisionRequest: () {},
          );
        }

        if (state is TeacherToTeacherPendingInvitationState) {
          return PendingBtn(
            teacher: teacher,
            onCancelRequest: () {
              BlocProvider.of<TeacherToTeacherCubit>(context)
                  .cancelFriendRequest();
            },
            onBlock: () {
              BlocProvider.of<TeacherToTeacherCubit>(context)
                  .blockTeacher(userId: teacher.id);
            },
          );
        }
        if (state is TeacherToTeacherFriendsState) {
          return FriendsBtn(
            teacher: teacher,
            onBlock: () {
              BlocProvider.of<TeacherToTeacherCubit>(context)
                  .blockTeacher(userId: teacher.id);
            },
          );
        }

        if (state is TeacherToTeacherBlockState) {
          return UnblockBtn(
            onUnblock: () {
              BlocProvider.of<TeacherToTeacherCubit>(context).unblockTeacher();
            },
          );
        }

        return ActionButton(
          title: translate('Add friend'),
          radius: 8,
          onPress: () {
            BlocProvider.of<TeacherToTeacherCubit>(context)
                .sendFriendRequest(userId: teacher.id);
          },
        );
      },
    );
  }
}

class FriendsBtn extends StatelessWidget {
  const FriendsBtn({
    super.key,
    required this.teacher,
    required this.onBlock,
  });

  final Teacher teacher;
  final Function() onBlock;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: 150,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cancel_rounded),
                  title: Text(tr('Unfriend')),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (cxt) {
                        return UnfriendDialog(
                          onSubmit: () {
                            BlocProvider.of<TeacherToTeacherCubit>(context)
                                .unfriend();
                          },
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.block,
                    color: Colors.red,
                  ),
                  title: Text(
                    tr('Block'),
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BlockDialog(
                          userId: teacher.id,
                          onBlock: onBlock,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColor.lightGrey),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Text(
        tr('Friend'),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class PendingBtn extends StatelessWidget {
  const PendingBtn({
    super.key,
    required this.teacher,
    required this.onCancelRequest,
    required this.onBlock,
  });

  final Teacher teacher;
  final Function() onCancelRequest;
  final Function() onBlock;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            height: 152,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Text(
                  teacher.username,
                  style: TextStyle(
                    color: AppColor.txtColor3,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: AppColor.lightGrey),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: Row(
                      children: [
                        Text(
                          tr('Cancel request'),
                          style: const TextStyle(
                            color: AppColor.txtGrayColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return FriendRequestCancelDialoug(
                          onSubmit: onCancelRequest,
                        );
                      },
                    );
                  },
                ),
                const Divider(color: AppColor.lightGrey),
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
                    child: Row(
                      children: [
                        Text(
                          tr('Block'),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(color: AppColor.lightGrey),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BlockDialog(
                          userId: teacher.id,
                          onBlock: onBlock,
                        );
                      },
                    );
                  },
                ),
                const Divider(color: AppColor.lightGrey),
              ],
            ),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColor.lightGrey),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Text(
        tr('Pending'),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class FriendRequestCancelDialoug extends StatelessWidget {
  const FriendRequestCancelDialoug({
    super.key,
    required this.onSubmit,
  });
  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      msg: tr('Are you sure you want to cancel the friend request?'),
      alertType: AlertType.danger,
      onSubmit: onSubmit,
    );
  }
}
