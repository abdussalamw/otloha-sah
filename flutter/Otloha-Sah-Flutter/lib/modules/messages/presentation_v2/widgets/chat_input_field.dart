import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../../../../core/utils/themes/color.dart';
import '../../business_logic_v2/cubit/chat_cubit.dart';
import '../../business_logic_v2/cubit/record_cubit.dart';
import '../../business_logic_v2/cubit/record_state.dart';
import 'message_chat_widget.dart';
import 'record_view.dart';

class ChatInputField extends StatelessWidget {
  final Function? onSend;
  final Function? onCancelRecord;
  final Function(String?)? onChanged;

  const ChatInputField({
    Key? key,
    required this.onSend,
    this.onCancelRecord,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return BlocBuilder<RecordCubit, RecordState>(
          builder: (context, recordState) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: AppColor.messageColor2,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      children: [
                        if (ChatCubit.get(context).replyMessage != null)
                          const Row(
                            children: [
                               Expanded(child: ReplyToMessageView()),
                              SizedBox(width: 85)
                            ],
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColor.background,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: AppColor.lightBlue,
                                    width: 1,
                                  ),
                                ),
                                child: recordState is RecordingState
                                    ? const WhenRecordingView()
                                    : const TextCommentView(),
                              ),
                            ),
                            RecordingView(
                              onCancelRecord: onCancelRecord,
                              onStop: (recordPath) {
                                ChatCubit.get(context)
                                    .setRecordPath(recordPath);
                              },
                              hasCancel: true,
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: onSend == null
                                  ? null
                                  : () {
                                onSend!(ChatCubit.get(context).controller.text);
                                ChatCubit.get(context).controller.clear();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColor.headTextColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.send,
                                    color: AppColor.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),


              ],
            );
          },
        );
      },
    );
  }
}

// class ChatInputField2 extends StatelessWidget {
//   const ChatInputField2({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         BlocBuilder<ChatCubit, ChatState>(
//           builder: (context, state) {
//             return Container(
//               margin: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: AppColor.messageColor2,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (ChatCubit.get(context).isReply)
//                     const ReplyToMessageView(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: AppColor.background,
//                           borderRadius: BorderRadius.circular(6),
//                           border: Border.all(
//                             color: AppColor.lightBlue,
//                             width: 1,
//                           ),
//                         ),
//                         child: ChatCubit.get(context).isRecordeing
//                             ? const WhenRecordingView()
//                             : const TextCommentView(),
//                       ),
//                       const RecordingActionView()
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         InkWell(
//           onTap: ChatCubit.get(context).sendMessage,
//           child: Container(
//             width: 30,
//             height: 30,
//             margin: const EdgeInsets.symmetric(vertical: 8),
//             decoration: BoxDecoration(
//               color: AppColor.darkBlue,
//               borderRadius: BorderRadius.circular(15),
//             ),
//             child: const Center(
//               child: Icon(
//                 Icons.send,
//                 color: AppColor.white,
//                 size: 16,
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

class ReplyToMessageView extends StatelessWidget {
  const ReplyToMessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        return Container(
          height: 60,
          decoration: BoxDecoration(
            color: AppColor.messageColor2b,
            borderRadius: BorderRadius.circular(4),
          ),
          margin: const EdgeInsets.all(4),
          child:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    // width: MediaQuery.of(context).size.width * (278 / 360),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ChatCubit.get(context)
                              .room
                              .users
                              .firstWhere((element) =>
                          element.id ==
                              ChatCubit.get(context).replyMessage!.user)
                              .fullname!,
                          style: const TextStyle(
                            color: AppColor.hidenBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: ChatCubit.get(context).removeReply,
                          child: const Icon(
                            Icons.clear,
                            color: AppColor.hidenBlue,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ReplyToMessage(
                    replyTo: ChatCubit.get(context).replyMessage!,
                    decoration: const BoxDecoration(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TextCommentView extends StatelessWidget {
  const TextCommentView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldMessageWidget(
      title: 'اكتب رسالتك',
      controller: ChatCubit.get(context).controller,
      onChanged: ChatCubit.get(context).onTextChange,
      onStopTyping: ChatCubit.get(context).onStopTyping,
    );
  }
}

class WhenRecordingView extends StatelessWidget {
  const WhenRecordingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        'جاري تسجيل الرد',
        style: TextStyle(
          color: AppColor.userNameColor,
          fontSize: 14,
        ),
      ),
    );
  }
}

// class RecordingActionView extends StatelessWidget {
//   const RecordingActionView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ChatCubit, ChatState>(
//       builder: (context, state) {
//         return BlocBuilder<RecordCubit, RecordState>(
//           builder: (context, state) {
//             return Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 if (state is RecordingState)
//                   Text(
//                     RecordCubit.get(context).timer,
//                     style: const TextStyle(
//                       color: AppColor.txtColor5,
//                       fontSize: 8,
//                     ),
//                   ),
//                 if (state is RecordingState)
//                   PlayPause(isPlay: false, playPauseAction: () {}, size: 16),
//                 const SizedBox(width: 4),
//                 if (ChatCubit.get(context).isRecordeing)
//                   InkWell(
//                     onTap: ChatCubit.get(context).stopRecord,
//                     child: const Icon(
//                       Icons.stop,
//                       color: AppColor.txtColor5,
//                       size: 16,
//                     ),
//                   ),
//                 if (!ChatCubit.get(context).isRecordeing)
//                   InkWell(
//                     onTap: ChatCubit.get(context).startRecord,
//                     child: Image.asset(
//                       AppIcons.mic,
//                       color: AppColor.headTextColor,
//                       width: 16,
//                       height: 16,
//                     ),
//                   ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }

// ignore: must_be_immutable
class TextFieldMessageWidget extends StatelessWidget {
  TextFieldMessageWidget({
    Key? key,
    required this.title,
    this.controller,
    this.validator,
    this.onChanged,
    this.onStopTyping,
  }) : super(key: key);

  final String title;
  final TextEditingController? controller;
  final String Function(String?)? validator;
  final Function(String?)? onChanged;
  final Function? onStopTyping;

  Timer? searchOnStoppedTyping;

  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping!.cancel(); // clear timer
    }
    searchOnStoppedTyping = Timer(duration, () => onStopTyping?.call());
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: title,
      onChanged: (text) {
        if (text!.isNotEmpty) {
          _onChangeHandler(text);
        }
        onChanged?.call(text);
      },
      style: TextStyle(
        color: AppColor.userNameColor,
        fontSize: 14,
        height: 1.5
      ),
      controller: controller,

      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        hintText: title,
        fillColor: AppColor.background,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          gapPadding: 0,
        ),
      ),
      validator: validator,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      scrollPadding: EdgeInsets.zero,
    );
  }
}
