import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/action_button.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/alert_popup.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_student_btn/student_to_student_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_student_btn/student_to_student_btn_state.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/base_dialog.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/block_dialog.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/response_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/unblock_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/unfriend_dialog.dart';

class StudentToStudentBtn extends StatefulWidget {
  const StudentToStudentBtn({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  State<StudentToStudentBtn> createState() => _StudentToStudentBtnState();
}

class _StudentToStudentBtnState extends State<StudentToStudentBtn>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StudentToStudentBtnWidget(student: widget.student);
  }

  @override
  bool get wantKeepAlive => true;
}

class StudentToStudentBtnWidget extends StatelessWidget {
  const StudentToStudentBtnWidget({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentToStudentCubit, StudentToStudentBtnState>(
      builder: (context, state) {
        if (state is StudentToStudentBtnLoadingState) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              width: 20,
              height: 20,
              child: LoadingWidget(),
            ),
          );
        }

        if (state is StudentToStudentWithRequestedInvitation) {
          return ResponseBtn(
            username: student.username,
            inFriend: student.invitations.inFriendRequest != null,
            inSupervision: false,
            onAcceptFriendRequest: () {
              BlocProvider.of<StudentToStudentCubit>(context)
                  .acceptFriendRequest();
            },
            onAcceptSupervisionRequest: () {},
            onRejectFriendRequest: () {
              BlocProvider.of<StudentToStudentCubit>(context)
                  .rejectFriendRequest();
            },
            onRejectSupervisionRequest: () {},
          );
        }

        if (state is StudentToStudentPendingInvitationState) {
          return PendingBtn(
            student: student,
            onCancelRequest: () {
              BlocProvider.of<StudentToStudentCubit>(context)
                  .cancelFriendRequest();
            },
            onBlock: () {
              BlocProvider.of<StudentToStudentCubit>(context)
                  .blockStudent(userId: student.id);
            },
          );
        }
        if (state is StudentToStudentFriendsState) {
          return FriendsBtn(
            student: student,
            onBlock: () {
              BlocProvider.of<StudentToStudentCubit>(context)
                  .blockStudent(userId: student.id);
            },
          );
        }

        if (state is StudentToStudentBlockState) {
          return UnblockBtn(
            onUnblock: () {
              BlocProvider.of<StudentToStudentCubit>(context).unblockStudent();
            },
          );
        }

        return ActionButton(
          title: translate('Add friend'),
          radius: 8,
          onPress: () {
            BlocProvider.of<StudentToStudentCubit>(context)
                .sendFriendRequest(userId: student.id);
          },
        );
      },
    );
  }
}

class FriendsBtn extends StatelessWidget {
  const FriendsBtn({
    super.key,
    required this.student,
    required this.onBlock,
  });

  final Student student;
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
                            BlocProvider.of<StudentToStudentCubit>(context)
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
                          userId: student.id,
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
    required this.student,
    required this.onCancelRequest,
    required this.onBlock,
  });

  final Student student;
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
                  student.username,
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
                          userId: student.id,
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
