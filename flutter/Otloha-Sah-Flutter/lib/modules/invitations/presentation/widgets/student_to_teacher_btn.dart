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
import 'package:otloha_sah_flutter/data_source/remote/invetations_service.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_teacher_btn/student_to_teacher_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_teacher_btn/student_to_teacher_state.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/base_dialog.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/block_dialog.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/bottom_sheet_title.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/response_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/unblock_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/unfriend_dialog.dart';

class StudentToTeacherBtn extends StatefulWidget {
  const StudentToTeacherBtn({
    super.key,
    required this.teacher,
  });

  final Teacher teacher;

  @override
  State<StudentToTeacherBtn> createState() => _StudentToTeacherBtnState();
}

class _StudentToTeacherBtnState extends State<StudentToTeacherBtn>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    BlocProvider.of<StudentToTeacherBtnCubit>(context).teacher =
        BlocProvider.of<StudentToTeacherBtnCubit>(context).teacher.copyWith(
              invitations: widget.teacher.invitations,
              relationships: widget.teacher.relationships,
            );
    BlocProvider.of<StudentToTeacherBtnCubit>(context).emitBtnState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<StudentToTeacherBtnCubit, StudentToTeacherBtnState>(
      builder: (context, state) {
        if (state is StudentToTeacherBtnLoadingState) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              width: 20,
              height: 20,
              child: LoadingWidget(),
            ),
          );
        }
        if (state is StudentToTeacherBtnWithRequestedInvitation) {
          return ResponseBtn(
            username: widget.teacher.username,
            inFriend: state.isFriendPending,
            inSupervision: state.isSupervisionPending,
            onAcceptFriendRequest: () {
              BlocProvider.of<StudentToTeacherBtnCubit>(context)
                  .respondOnRequest(
                invitationId: widget.teacher.invitations.inFriendRequest!,
                invitationType: InvitationType.friendRequest,
                status: 'accepted',
              );
            },
            onAcceptSupervisionRequest: () {
              BlocProvider.of<StudentToTeacherBtnCubit>(context)
                  .respondOnRequest(
                invitationId: widget.teacher.invitations.inSupervisionRequest!,
                invitationType: InvitationType.supervisionRequest,
                status: 'accepted',
              );
            },
            onRejectFriendRequest: () {
              BlocProvider.of<StudentToTeacherBtnCubit>(context)
                  .respondOnRequest(
                invitationId: widget.teacher.invitations.inFriendRequest!,
                invitationType: InvitationType.friendRequest,
                status: 'rejected',
              );
            },
            onRejectSupervisionRequest: () {
              BlocProvider.of<StudentToTeacherBtnCubit>(context)
                  .respondOnRequest(
                invitationId: widget.teacher.invitations.inSupervisionRequest!,
                invitationType: InvitationType.supervisionRequest,
                status: 'rejected',
              );
            },
          );
        }

        if (state is StudentToTeacherBtnHasRelation) {
          return HasRelationBtn(
            state: state,
            onBlock: () {
              BlocProvider.of<StudentToTeacherBtnCubit>(context).block();
            },
            teacher: widget.teacher,
          );
        }
        if (state is StudentToTeacherBtnPendingRequeststate) {
          return PendingBtn(
            teacher: widget.teacher,
            state: state,
            onBlock: () {
              BlocProvider.of<StudentToTeacherBtnCubit>(context).block();
            },
          );
        }
        if (state is StudentToTeacherBlockState) {
          return UnblockBtn(onUnblock: () {
            BlocProvider.of<StudentToTeacherBtnCubit>(context).unblock();
          });
        }
        return InitialBtn(teacher: widget.teacher);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class InitialBtn extends StatelessWidget {
  const InitialBtn({
    super.key,
    required this.teacher,
  });

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      title: translate('Teacher'),
      radius: 8,
      onPress: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            height: 155,
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
                StudentToTeacherBtnOption(
                  onTap: () {
                    BlocProvider.of<StudentToTeacherBtnCubit>(context)
                        .requestFriendRequest();
                  },
                  optTitle: tr('Send friend request'),
                ),
                StudentToTeacherBtnOption(
                  onTap: () {
                    BlocProvider.of<StudentToTeacherBtnCubit>(context)
                        .requestSupervisionRequest();
                  },
                  optTitle: tr('Ask to be favorite teacher'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HasRelationBtn extends StatelessWidget {
  const HasRelationBtn({
    super.key,
    required this.state,
    required this.teacher,
    required this.onBlock,
  });

  final StudentToTeacherBtnHasRelation state;
  final Teacher teacher;
  final Function() onBlock;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            height: 200,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                BottomSheetTitle(title: teacher.username),
                if (state.relationships.supervision)
                  StudentToTeacherBtnOption(
                    optTitle: tr('Remove supervision'),
                    dialog: BaseDialog(
                      alertType: AlertType.warning,
                      onSubmit: () {
                        BlocProvider.of<StudentToTeacherBtnCubit>(context)
                            .removeAsFavoriteTeacher();
                      },
                      msg:
                          tr('Are you sure you want to cancel the supervision'),
                    ),
                  ),
                if (state.relationships.friend)
                  StudentToTeacherBtnOption(
                    optTitle: tr('Unfriend'),
                    dialog: BaseDialog(
                      alertType: AlertType.warning,
                      onSubmit: () {
                        BlocProvider.of<StudentToTeacherBtnCubit>(context)
                            .unfriend();
                      },
                      msg: tr('Are you sure you want to unfriend this user'),
                    ),
                  ),
                if (!state.relationships.friend)
                  StudentToTeacherBtnOption(
                    optTitle: tr('Send friend request'),
                    onTap: () {
                      BlocProvider.of<StudentToTeacherBtnCubit>(context)
                          .requestFriendRequest();
                    },
                  ),
                if (!state.relationships.supervision)
                  StudentToTeacherBtnOption(
                    optTitle: tr('Ask to be favorite teacher'),
                    onTap: () {
                      BlocProvider.of<StudentToTeacherBtnCubit>(context)
                          .requestSupervisionRequest();
                    },
                  ),
                StudentToTeacherBlockBtn(teacher: teacher, onBlock: onBlock),
              ],
            ),
          ),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColor.lightGrey),
        elevation: MaterialStateProperty.all(0),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      child: Text(
        state.relationships.supervision ? tr('My Teacher') : tr('Friend'),
        style: TextStyle(
          color: AppColor.txtColor3,
        ),
      ),
    );
  }
}

class PendingBtn extends StatelessWidget {
  const PendingBtn({
    super.key,
    required this.teacher,
    required this.state,
    required this.onBlock,
  });

  final Teacher teacher;
  final StudentToTeacherBtnPendingRequeststate state;
  final Function() onBlock;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            height: 200,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                BottomSheetTitle(title: teacher.username),
                if (state.isSupervisionPending)
                  StudentToTeacherBtnOption(
                    onTap: () {
                      BlocProvider.of<StudentToTeacherBtnCubit>(context)
                          .cancelSupervisionRequest();
                    },
                    optTitle: tr('Cancel ask to be favorite teacher'),
                  ),
                if (state.isFriendPending)
                  StudentToTeacherBtnOption(
                    onTap: () {
                      BlocProvider.of<StudentToTeacherBtnCubit>(context)
                          .cancelFriendRequest();
                    },
                    optTitle: tr('Cancel friend request'),
                  ),
                if (state.isFriend)
                  StudentToTeacherBtnOption(
                    dialog: UnfriendDialog(
                      onSubmit: () {
                        BlocProvider.of<StudentToTeacherBtnCubit>(context)
                            .unfriend();
                      },
                    ),
                    optTitle: tr('Unfriend'),
                  ),
                if (!state.isFriend && !state.isFriendPending)
                  StudentToTeacherBtnOption(
                    onTap: () {
                      BlocProvider.of<StudentToTeacherBtnCubit>(context)
                          .requestFriendRequest();
                    },
                    optTitle: tr('Send friend request'),
                  ),
                if (!state.isFavoriteTeacher && !state.isSupervisionPending)
                  StudentToTeacherBtnOption(
                    onTap: () {
                      BlocProvider.of<StudentToTeacherBtnCubit>(context)
                          .requestSupervisionRequest();
                    },
                    optTitle: tr('Ask to be favorite teacher'),
                  ),
                StudentToTeacherBlockBtn(teacher: teacher, onBlock: onBlock),
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

class StudentToTeacherBlockBtn extends StatelessWidget {
  const StudentToTeacherBlockBtn({
    super.key,
    required this.teacher,
    required this.onBlock,
  });

  final Teacher teacher;
  final Function() onBlock;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

class StudentToTeacherBtnOption extends StatelessWidget {
  const StudentToTeacherBtnOption({
    super.key,
    this.dialog,
    this.onTap,
    required this.optTitle,
  }) : assert(dialog != null || onTap != null);

  final Widget? dialog;
  final Function()? onTap;
  final String optTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Row(
              children: [
                Text(
                  optTitle,
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
            if (dialog == null && onTap != null) {
              onTap!();
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return dialog!;
                },
              );
            }
          },
        ),
        const Divider(color: AppColor.lightGrey),
      ],
    );
  }
}

class FriendRequestDialog extends StatelessWidget {
  const FriendRequestDialog({super.key, required this.onSubmit});
  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      msg: tr('Are you sure you want to send friend request to this teacher?'),
      alertType: AlertType.warning,
      onSubmit: onSubmit,
    );
  }
}

class SupervisionRequestDialog extends StatelessWidget {
  const SupervisionRequestDialog({super.key, required this.onSubmit});
  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      msg: tr(
          'Are you sure you want to mark this teacher as your favorite teacher?'),
      alertType: AlertType.seccess,
      onSubmit: onSubmit,
    );
  }
}
