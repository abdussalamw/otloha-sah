import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/core/widgets/action_button.dart';
import 'package:otloha_sah_flutter/core/widgets/loading.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/user_to_entity_btn/user_to_entity_btn_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/user_to_entity_btn/user_to_entity_btn_state.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/bottom_sheet_option.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/bottom_sheet_title.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/student_to_teacher_btn.dart';

class UserToEntityBtn extends StatelessWidget {
  const UserToEntityBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserToEntityBtnCubit, UserToEntityBtnState>(
      builder: (context, state) {
        if (state is UserToEnityLoadingState) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SizedBox(
              width: 20,
              height: 20,
              child: LoadingWidget(),
            ),
          );
        }
        if (state is UserToEntityBtnPendingState) {
          return const PendingBtn();
        }

        if (state is UserToEntityBtnJoinedState) {
          return const JoinedBtn();
        }

        if (state is UserToEntityBtnInitialState) {
          return const InitialBtn();
        }
        return const SizedBox();
      },
    );
  }
}

class PendingBtn extends StatelessWidget {
  const PendingBtn({super.key});

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
                BottomSheetTitle(
                    title: BlocProvider.of<UserToEntityBtnCubit>(context)
                        .entity
                        .name),
                BottomSheetOption(
                  optTitle: tr('Cancel request'),
                  onTap: () {
                    BlocProvider.of<UserToEntityBtnCubit>(context)
                        .cancelJoinRequest();
                  },
                ),
                BottomSheetOption(
                  optTitle: tr('Block'),
                  onTap: () {},
                )
              ],
            ),
          ),
        );
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.lightGrey),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(EdgeInsets.zero)),
      child: Text(
        tr('Pending'),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}

class InvitationRequestReceived extends StatelessWidget {
  const InvitationRequestReceived({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class JoinedBtn extends StatelessWidget {
  const JoinedBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class InitialBtn extends StatelessWidget {
  const InitialBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      title: tr('Join'),
      radius: 8,
      onPress: () {
        BlocProvider.of<UserToEntityBtnCubit>(context).sendJoinRequest();
      },
    );
  }
}
