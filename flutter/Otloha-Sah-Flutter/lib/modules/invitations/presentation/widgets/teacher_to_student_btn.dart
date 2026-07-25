import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/action_button.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/alert_popup.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/remote/invetations_service.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_student_btn/teacher_to_student_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_student_btn/teacher_to_student_btn_state.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/base_dialog.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/block_dialog.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/bottom_sheet_option.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/bottom_sheet_title.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/response_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/unblock_btn.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/unfriend_dialog.dart';

class TeacherToStudentBtn extends StatefulWidget {
  const TeacherToStudentBtn({
    super.key,
    required this.student,
  });
  final Student student;

  @override
  State<TeacherToStudentBtn> createState() => _TeacherToStudentBtnState();
}

class _TeacherToStudentBtnState extends State<TeacherToStudentBtn>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TeacherToStudentBtnCubit, TeacherToStudentBtnState>(
      builder: (context, state) {
        if (state is TeacherToStudentBtnLoadingState) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              width: 20,
              height: 20,
              child: LoadingWidget(),
            ),
          );
        }
        if (state is TeacherToStudentBtnWithRequestedInvitation) {
          return ResponseBtn(
            username: widget.student.username,
            inFriend: state.isFriendPending,
            inSupervision: state.isSupervisionPending,
            onAcceptFriendRequest: () {
              BlocProvider.of<TeacherToStudentBtnCubit>(context)
                  .respondOnRequest(
                      invitationId: widget.student.invitations.inFriendRequest!,
                      invitationType: InvitationType.friendRequest,
                      status: 'accepted');
            },
            onAcceptSupervisionRequest: () {
              BlocProvider.of<TeacherToStudentBtnCubit>(context)
                  .respondOnRequest(
                      invitationId:
                          widget.student.invitations.inSupervisionRequest!,
                      invitationType: InvitationType.supervisionRequest,
                      status: 'accepted');
            },
            onRejectFriendRequest: () {
              BlocProvider.of<TeacherToStudentBtnCubit>(context)
                  .respondOnRequest(
                      invitationId: widget.student.invitations.inFriendRequest!,
                      invitationType: InvitationType.friendRequest,
                      status: 'rejected');
            },
            onRejectSupervisionRequest: () {
              BlocProvider.of<TeacherToStudentBtnCubit>(context)
                  .respondOnRequest(
                      invitationId:
                          widget.student.invitations.inSupervisionRequest!,
                      invitationType: InvitationType.supervisionRequest,
                      status: 'rejected');
            },
          );
        }

        if (state is TeacherToStudentBtnHasRelation) {
          return HasRelationBtn(state: state, student: widget.student);
        }

        if (state is TeacherToStudentBtnPendingRequestState) {
          return PendingBtn(
            student: widget.student,
            state: state,
            onBlock: () {
              BlocProvider.of<TeacherToStudentBtnCubit>(context).block();
            },
          );
        }

        if (state is TeacherToStudentBtnBlockState) {
          return UnblockBtn(onUnblock: () {
            BlocProvider.of<TeacherToStudentBtnCubit>(context).unblock();
          });
        }

        return InitialBtn(student: widget.student);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class InitialBtn extends StatelessWidget {
  const InitialBtn({
    super.key,
    required this.student,
  });

  final Student student;

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      title: tr('Student'),
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
                  student.username,
                  style: TextStyle(
                    color: AppColor.txtColor3,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(color: AppColor.lightGrey),
                BottomSheetOption(
                  onTap: () {
                    BlocProvider.of<TeacherToStudentBtnCubit>(context)
                        .requestFriendRequest();
                  },
                  optTitle: tr('Send friend request'),
                ),
                BottomSheetOption(
                  onTap: () {
                    BlocProvider.of<TeacherToStudentBtnCubit>(context)
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
    required this.student,
  });

  final TeacherToStudentBtnHasRelation state;
  final Student student;

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
                BottomSheetTitle(title: student.username),
                if (state.relationships.friend)
                  BottomSheetOption(
                    optTitle: tr('Unfriend'),
                    dialog: BaseDialog(
                      alertType: AlertType.warning,
                      onSubmit: () {
                        BlocProvider.of<TeacherToStudentBtnCubit>(context)
                            .unfriend();
                      },
                      msg: tr('Are you sure you want to unfriend this user'),
                    ),
                  ),
                if (!state.relationships.friend)
                  BottomSheetOption(
                    optTitle: tr('Send friend request'),
                    onTap: () {
                      BlocProvider.of<TeacherToStudentBtnCubit>(context)
                          .requestFriendRequest();
                    },
                  ),
                if (!state.relationships.supervision)
                  BottomSheetOption(
                    optTitle: tr('Ask to be favorite teacher'),
                    onTap: () {
                      BlocProvider.of<TeacherToStudentBtnCubit>(context)
                          .requestSupervisionRequest();
                    },
                  ),
                TeacherToStudentBlockBtn(
                  student: student,
                  onBlock: () {
                    BlocProvider.of<TeacherToStudentBtnCubit>(context).block();
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
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      child: Text(
        state.relationships.supervision ? tr('My Student') : tr('Friend'),
        style: TextStyle(
          color: AppColor.txtColor3,
        ),
      ),
    );
  }
}

class TeacherToStudentBlockBtn extends StatelessWidget {
  const TeacherToStudentBlockBtn({
    super.key,
    required this.student,
    required this.onBlock,
  });

  final Student student;
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
              userId: student.id,
              onBlock: onBlock,
            );
          },
        );
      },
    );
  }
}

class PendingBtn extends StatelessWidget {
  const PendingBtn({
    super.key,
    required this.student,
    required this.state,
    required this.onBlock,
  });

  final Student student;
  final TeacherToStudentBtnPendingRequestState state;
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
                BottomSheetTitle(title: student.username),
                if (state.isSupervisionPending)
                  BottomSheetOption(
                    onTap: () {
                      BlocProvider.of<TeacherToStudentBtnCubit>(context)
                          .cancelSupervisionRequest();
                    },
                    optTitle: tr('Cancel Ask to be favorite teacher'),
                  ),
                if (state.isFriendPending)
                  BottomSheetOption(
                    onTap: () {
                      BlocProvider.of<TeacherToStudentBtnCubit>(context)
                          .cancelFriendRequest();
                    },
                    optTitle: tr('Cancel friend request'),
                  ),
                if (state.isFriend)
                  BottomSheetOption(
                    dialog: UnfriendDialog(
                      onSubmit: () {
                        BlocProvider.of<TeacherToStudentBtnCubit>(context)
                            .unfriend();
                      },
                    ),
                    optTitle: tr('Unfriend'),
                  ),
                if (!state.isFriend && !state.isFriendPending)
                  BottomSheetOption(
                    onTap: () {
                      BlocProvider.of<TeacherToStudentBtnCubit>(context)
                          .requestFriendRequest();
                    },
                    optTitle: tr('Send friend request'),
                  ),
                if (!state.isFavoriteTeacher && !state.isSupervisionPending)
                  BottomSheetOption(
                    onTap: () {
                      BlocProvider.of<TeacherToStudentBtnCubit>(context)
                          .requestSupervisionRequest();
                    },
                    optTitle: tr('Ask to be favorite teacher'),
                  ),
                TeacherToStudentBlockBtn(student: student, onBlock: onBlock),
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
