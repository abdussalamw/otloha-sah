import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/widgets/action_button.dart';
import 'package:otloha_sah_flutter/core/widgets/cached_image.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation_recieved.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/invitation_card/invitation_card_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/invitation_card/invitation_card_state.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/student_to_teacher_btn/student_to_teacher_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_student_btn/teacher_to_student_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/teacher_to_teacher_btn/teacher_to_student_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/pages/student_profile.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/pages/teacher_profile.dart';

import '../../cubit/student_to_student_btn/student_to_student_btn_cubit.dart';

Map<String, String> invitationTypes = {
  'supervision_request': tr('Ask to be favorite teacher'),
  'friend_request': tr('Friend request'),
};

class InvitationCard extends StatelessWidget {
  const InvitationCard({
    super.key,
    required this.invitationReceived,
    required this.pagingController,
  });
  final InvitationRecieved invitationReceived;
  final PagingController pagingController;

  @override
  Widget build(BuildContext context) {
    if (!(invitationReceived.requester.isTeacher ?? false) &&
        !UserDataServices.instance.isATeacher) {
      return BlocProvider(
        create: (context) => StudentToStudentCubit(
          student: invitationReceived.requester.toStudent(),
        ),
        child: BlocProvider(
          create: (context) =>
              InvitationCardCubit(invitationRecieved: invitationReceived),
          child: InvitationCardWidget(
            invitation: invitationReceived,
            pagingController: pagingController,
          ),
        ),
      );
    } else if ((invitationReceived.requester.isTeacher ?? false) &&
        !UserDataServices.instance.isATeacher) {
      return BlocProvider(
        create: (context) => StudentToTeacherBtnCubit(
            teacher: invitationReceived.requester.toTeacher()),
        child: BlocProvider(
          create: (context) =>
              InvitationCardCubit(invitationRecieved: invitationReceived),
          child: InvitationCardWidget(
            invitation: invitationReceived,
            pagingController: pagingController,
          ),
        ),
      );
    } else if ((invitationReceived.requester.isTeacher ?? false) &&
        UserDataServices.instance.isATeacher) {
      return BlocProvider(
        create: (context) => TeacherToTeacherCubit(
            teacher: invitationReceived.requester.toTeacher()),
        child: BlocProvider(
          create: (context) =>
              InvitationCardCubit(invitationRecieved: invitationReceived),
          child: InvitationCardWidget(
            invitation: invitationReceived,
            pagingController: pagingController,
          ),
        ),
      );
    }
    return BlocProvider(
      create: (context) => TeacherToStudentBtnCubit(
          student: invitationReceived.requester.toStudent()),
      child: BlocProvider(
        create: (context) =>
            InvitationCardCubit(invitationRecieved: invitationReceived),
        child: InvitationCardWidget(
          invitation: invitationReceived,
          pagingController: pagingController,
        ),
      ),
    );
  }
}

class InvitationCardWidget extends StatefulWidget {
  const InvitationCardWidget({
    super.key,
    required this.invitation,
    required this.pagingController,
  });
  final InvitationRecieved invitation;
  final PagingController pagingController;

  @override
  State<InvitationCardWidget> createState() => _InvitationCardWidgetState();
}

class _InvitationCardWidgetState extends State<InvitationCardWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvitationCardCubit, InvitationCardState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (!(widget.invitation.requester.isTeacher ?? false) &&
                !UserDataServices.instance.isATeacher) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (pageContext) => BlocProvider.value(
                      value: BlocProvider.of<StudentToStudentCubit>(context),
                      child: StudentProfile(
                          student: widget.invitation.requester.toStudent())),
                ),
              );
            } else if ((widget.invitation.requester.isTeacher ?? false) &&
                !UserDataServices.instance.isATeacher) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (pageContext) => BlocProvider.value(
                    value: BlocProvider.of<StudentToTeacherBtnCubit>(context),
                    child: TeacherProfilePage(
                      teacher: widget.invitation.requester.toTeacher(),
                    ),
                  ),
                ),
              );
            } else if (!(widget.invitation.requester.isTeacher ?? false) &&
                UserDataServices.instance.isATeacher) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (pageContext) => BlocProvider.value(
                      value: BlocProvider.of<TeacherToStudentBtnCubit>(context),
                      child: StudentProfile(
                          student: widget.invitation.requester.toStudent())),
                ),
              );
            } else if ((widget.invitation.requester.isTeacher ?? false) &&
                UserDataServices.instance.isATeacher) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (pageContext) => BlocProvider.value(
                    value: BlocProvider.of<TeacherToTeacherCubit>(context),
                    child: TeacherProfilePage(
                      teacher: widget.invitation.requester.toTeacher(),
                    ),
                  ),
                ),
              );
            }
          },
          child: Column(
            children: [
              Row(
                children: [
                  CachedImage(
                      url: widget.invitation.requester.image ?? '', raduis: 40),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.invitation.requester.username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xffFF9D2B),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.invitation.requester.rate,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              invitationTypes[
                                      widget.invitation.invitationType] ??
                                  '',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // const Spacer(),
                  if (state is InvitationCardAcceptedState)
                    Text(
                      tr('Accepted'),
                      style: const TextStyle(color: Colors.green),
                    ),
                  if (state is InvitationCardRejectedState)
                    Text(
                      tr('Rejected'),
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (state is InvitationCardInitialState)
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                            child: ActionButton(
                              title: tr('Accept'),
                              radius: 8,
                              onPress: () {
                                BlocProvider.of<InvitationCardCubit>(context)
                                    .acceptInvitation();
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 30,
                            child: ActionButton(
                              title: tr('Reject'),
                              radius: 8,
                              color: Colors.red,
                              onPress: () {
                                BlocProvider.of<InvitationCardCubit>(context)
                                    .rejectInvitation();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  // if (!UserDataServices.instance.isATeacher)
                  //   SizedBox(
                  //     width: 100,
                  //     height: 30,
                  //     child: StudentToStudentBtn(student: student),
                  //   ),
                ],
              ),
              Divider(
                color: Colors.grey[200]!,
                indent: 80,
              ),
            ],
          ),
        );
      },
    );
  }
}
