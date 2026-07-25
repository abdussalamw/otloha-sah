import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/local_recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';

import '../../../../core/utils/constant/constants.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../../data_source/local/database/database_repository.dart';
import '../../../../data_source/models/room/room.dart';
import '../../../../data_source/remote/messages_service.dart';
import '../../../../data_source/user_services_data.dart';
import '../../../messages/business_logic_v2/cubit/genaralmessage_cubit.dart';
import '../../../messages/business_logic_v2/cubit/message_details_cubit.dart';
import '../../../messages/presentation_v2/pages/evaluation_page.dart';
import '../../../quran/business_logic/cubit/progress/progress_cubit.dart';
import '../../business_logic/cubit/popup_action_cubit.dart';
import '../../business_logic/cubit/popup_actions_state.dart';
import '../../business_logic/cubit/teachersend_cubit.dart';
import '../page/update_recitation_page.dart';
import 'popup_rate.dart';

enum PopupActions {
  markAsFinished,
  addToGeneral,
  markAsRemarkable,
  delete,
  send,
  createMessge,
  updateRecitation,
  rateing,
  report,
  accept,
  reject,
}

class PopupRecitation extends StatefulWidget {
  const PopupRecitation({
    super.key,
    this.recitationId,
    this.messageId = 0,
    required this.isFinished,
    required this.isTeacher,
    required this.isOwner,
    this.showInGeneral,
    this.canCreateMessage,
    this.isAccepted,
    this.recitation,
    required this.actions,
    this.delete,
    this.refrech,
    required this.userId,
    required this.isLocal,
    this.onAddToGeneral,
    this.onSendToTeacher,
    this.userRecitation,
    this.onSetRemakable,
  });

  final int? recitationId;
  final int messageId;
  final int userId;
  final bool isFinished;
  final bool isTeacher;
  final bool isOwner;
  final bool? showInGeneral;
  final bool? canCreateMessage;
  final bool? isAccepted;
  final bool isLocal;

  final Recitation? recitation;
  final LocalRecitation? userRecitation;
  final List<PopupActions> actions;
  final Function()? delete;
  final Function(String)? refrech;
  final Function(Recitation? recitation)? onAddToGeneral;
  final Function(Recitation? recitation)? onSendToTeacher;
  final Function(Recitation? recitation)? onSetRemakable;

  @override
  State<PopupRecitation> createState() => _PopupRecitationState();
}

class _PopupRecitationState extends State<PopupRecitation> {
  late PopupActionsCubit cubit;
  @override
  void initState() {
    cubit = BlocProvider.of<PopupActionsCubit>(context);
    print('before set ${widget.recitation?.showInGeneral}');
    cubit.setShared(widget.recitation?.showInGeneral ?? false);
    cubit.setIsRemarkable(widget.recitation?.showInRemarkable ?? false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PopupActionsCubit, PopupActionsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (actions.contains(PopupActions.markAsFinished) && !isFinished)
              //   _itemView(
              //     onTap: () async {
              //       await cubit.markAsFinished(recitationId!);
              //       if (refrech != null) refrech!(DateTime.now().toString());

              //       Get.dialog(const AlertDialogFullScreen());
              //     },
              //     title: 'MarkAsFinish',
              //     icon: Icons.mark_chat_read,
              //     color: AppColor.headTextColor,
              //   ),
              if (widget.actions.contains(PopupActions.updateRecitation) &&
                  (widget.recitation?.result == 'pending' ||
                      widget.recitation?.result == 'rejected' ||
                      widget.recitation?.result == null))
                _itemView(
                  onTap: () async {
                    Get.to(
                      UpdateRecitationPage(recitation: widget.recitation!),
                    );
                  },
                  title: 'UpdateRecitation',
                  icon: Icons.upgrade,
                  color: AppColor.headTextColor,
                ),
              if (widget.actions.contains(PopupActions.report) &&
                  (widget.isAccepted ?? false))
                _itemView(
                  onTap: () async {
                    showLoader(context);
                    await cubit.serReport(
                        widget.recitationId!, widget.messageId);
                    hideLoader();
                    Get.dialog(const AlertDialogFullScreen());
                  },
                  title: 'Report',
                  icon: Icons.report,
                  color: AppColor.txtColor5,
                ),
              if (widget.actions.contains(PopupActions.accept))
                _itemView(
                  onTap: () async {
                    //  context.loaderOverlay.show();
                    await cubit.serAccept(
                        widget.recitationId!, widget.messageId);

                    // context.loaderOverlay.hide();
                    // Get.dialog(const AlertDialogFullScreen());
                  },
                  title: 'Accept',
                  icon: Icons.done,
                  color: AppColor.headTextColor,
                ),
              if (widget.actions.contains(PopupActions.reject))
                _itemView(
                  onTap: () async {
                    cubit.serReject(widget.recitationId!, widget.messageId);
                  },
                  title: 'Reject',
                  icon: Icons.cancel,
                  color: AppColor.txtColor5,
                ),
              if (widget.actions.contains(PopupActions.addToGeneral) &&
                  widget.isOwner)
                _itemView(
                  onTap: () async {
                    Loader.show(context);
                    if (widget.isLocal) {
                      final recitation =
                          await TeacherSendCubit.get(context).sendTeacher(
                        id: widget.recitationId,
                        userRecitation: widget.userRecitation,
                        context: context,
                      );
                      if (recitation != null) {
                        cubit.setShared(!cubit.isShared);
                        await ProgressCubit.get(context)
                            .getProgress(int.parse(recitation.chapterId!));
                      }
                      await DatabaseRepository.instance
                          .deleteUserRecitation(widget.userRecitation!.id!);
                      widget.onAddToGeneral?.call(
                          recitation?.copyWith(showInGeneral: cubit.isShared));
                    } else {
                      if ((widget.showInGeneral ?? false) ||
                          widget.userRecitation == null) {
                        await GetMessages().addToGeneral(widget.recitationId!);
                        cubit.setShared(!cubit.isShared);
                      } else {
                        final recitation =
                            await TeacherSendCubit.get(context).sendTeacher(
                          id: widget.recitationId,
                          userRecitation: widget.userRecitation,
                          context: context,
                        );
                        if (recitation != null) {
                          cubit.setShared(!cubit.isShared);
                          await ProgressCubit.get(context)
                              .getProgress(int.parse(recitation.chapterId!));
                        }
                      }
                      widget.onAddToGeneral?.call(widget.recitation
                          ?.copyWith(showInGeneral: cubit.isShared));
                    }

                    Loader.hide();
                  },
                  title: widget.isTeacher
                      ? (cubit.isShared
                          ? 'RemoveFromTeacherRecitation'
                          : 'AddToTeacherRecitation')
                      : (cubit.isShared ? 'RemoveFromGeneral' : 'AddToGeneral'),
                  icon: Icons.share,
                  color: AppColor.headTextColor,
                  trailing: cubit.isShared ? Icons.check : null,
                ),
              if (widget.actions.contains(PopupActions.send) &&
                  widget.isOwner &&
                  !widget.isTeacher &&
                  UserDataServices.instance.isHaveFavTeacher)
                _itemView(
                  onTap: () async {
                    showLoader(context);
                    var recitation =
                        await TeacherSendCubit.get(context).sendTeacher(
                      id: widget.recitationId,
                      userRecitation: widget.userRecitation,
                      sendToFavoriteTeacher: true,
                      context: context,
                    );
                    if (widget.onSendToTeacher != null && recitation != null) {
                      widget.onSendToTeacher!(recitation);
                      await ProgressCubit.get(context)
                          .getProgress(int.parse(recitation.chapterId!));
                      Get.dialog(const AlertDialogFullScreen());
                    }
                    // Get.back();
                    hideLoader();
                  },
                  title: 'SendTo',
                  icon: Icons.send,
                  color: AppColor.headTextColor,
                  isTransform: true,
                ),
              if (widget.actions.contains(PopupActions.markAsRemarkable) &&
                  ((!widget.recitation!.isRemarkable! &&
                          widget.isTeacher &&
                          !widget.isOwner) ||
                      (widget.recitation!.isRemarkable! && widget.isOwner)))
                _itemView(
                    onTap: () async {
                      showLoader(context);

                      await cubit.markAsRemarkable(widget.recitationId!);
                      widget.onSetRemakable?.call(widget.recitation
                          ?.copyWith(showInRemarkable: cubit.isRemarkable));
                      hideLoader();
                    },
                    title: cubit.isRemarkable
                        ? translate('remove_from_remarkable_list')
                        : translate('add_to_markable_list'),
                    icon: Icons.workspace_premium_outlined,
                    color: AppColor.headTextColor),
              if (widget.actions.contains(PopupActions.rateing)) // && !isOwner
                _itemView(
                  onTap: () async {
                    Get.bottomSheet(
                      PopupRateRecitation(
                        recitationId: widget.recitationId!,
                      ),
                    );
                  },
                  title: 'Rate',
                  icon: Icons.favorite,
                  color: AppColor.txtColor3,
                ),
              if (widget.actions.contains(PopupActions.delete) &&
                  widget.isOwner &&
                  !(widget.recitation?.beingEvaluated ?? false))
                _itemView(
                  onTap: () async {
                    await cubit.deleteRecitations(
                      isLocal: widget.isLocal,
                      id: widget.recitationId,
                      userRecitation: widget.userRecitation,
                    );
                    widget.delete!();
                  },
                  title: 'Delete',
                  icon: Icons.close,
                  color: AppColor.txtColor5,
                ),
              if (widget.isTeacher &&
                  widget.actions.contains(PopupActions.createMessge))
                BlocBuilder<MessageDetailsCubit, MessageDetailsState>(
                  builder: (context, state) {
                    MessageDetailsCubit.get(context)
                        .setRecitation(widget.recitation!);
                    return _itemView(
                      onTap: () async {
                        Room? room = (await cubit.createRoom(
                            widget.recitationId!, widget.userId, context));
                        if (room != null) {
                          MessageDetailsCubit.get(context).setRoom(room);
                          GenaralmessageCubit.get(context)
                              .getGeneraBoXMessage();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EvaluationPage(room: room),
                            ),
                          );
                        }
                      },
                      title: 'CreateMessage',
                      icon: Icons.message,
                      color: AppColor.txtColor3,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  _itemView({
    required Function() onTap,
    required String title,
    required IconData icon,
    IconData? trailing,
    required Color color,
    bool isTransform = false,
  }) {
    return ListTile(
      onTap: onTap,
      title: TextView(
        text: translate(title),
        colorText: color,
        textAlign: TextAlign.start,
      ),
      leading: isTransform
          ? Transform(
              alignment: Alignment.center,
              transform:
                  Constants.isEn ? Matrix4.rotationY(0) : Matrix4.rotationY(pi),
              child: Icon(
                icon,
                color: color,
              ),
            )
          : Icon(
              icon,
              color: color,
            ),
      trailing: (trailing != null)
          ? Icon(
              trailing,
              color: color,
            )
          : const SizedBox(),
    );
  }
}
