import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/utils/themes/text_style.dart';
import '../../../../data_source/models/message_model/message_model.dart';
import '../../../audio/presentation/wave_view.dart';
import '../../business_logic_v2/evaluation_form/evaluation_form_cubit.dart';
import '../../business_logic_v2/evaluation_form/evaluation_form_state.dart';
import 'evaluation_form.dart';
import 'record_view.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';
import 'package:web_socket_channel/io.dart';

class ViewMessages extends StatelessWidget {
  const ViewMessages({
    Key? key,
    required this.messages,
    required this.channel,
  }) : super(key: key);
  final List<MessageModel> messages;
  final IOWebSocketChannel channel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: messages.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CommentItem(
            comment: messages[index],
            channel: channel,
          );
        },
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    Key? key,
    required this.comment,
    required this.channel,
  }) : super(key: key);

  final MessageModel comment;
  final IOWebSocketChannel channel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EvaluationFormCubit, EvaluationFormState>(
      builder: (context, state) {
        MessageModel? editMessage = EvaluationFormCubit.get(context).message;
        if (editMessage != null && editMessage.id == comment.id) {
          return EvaluationForm(channel: channel);
        }
        return Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(ThemeCubit.isDark ? 0xFF272727 : 0xfff6f6f6)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (comment.fault != null &&
                                  comment.fault!.errorText != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 8,
                                  ),
                                  child: Text(
                                    comment.fault!.errorText!,
                                    style: AppStyle().textStyle1.copyWith(
                                          fontSize: 16,
                                          color: AppColor.headTextColor,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: .5,
                                          fontFamily: 'Hafs17',
                                        ),
                                  ),
                                ),
                              if (comment.text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 8),
                                  child: Text(
                                    comment.text,
                                    style: TextStyle(
                                      color: AppColor.userNameColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              if (comment.record != null)
                                WaveViewPlayAudio(
                                  isPlay: false,
                                  record: comment.record!,
                                  wavePath: '',
                                ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ActionAudioIcon(
                          iconWidget: Icon(
                            Icons.clear_sharp,
                            color: AppColor.headTextColor,
                            size: 16,
                          ),
                          colorBack: AppColor.white,
                          colorText: AppColor.headTextColor,
                          action: () => channel.sink.add(
                              EvaluationFormCubit.deleteMessage(comment.id)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ActionAudioIcon(
                          iconWidget: Icon(
                            Icons.edit_outlined,
                            color: AppColor.headTextColor,
                            size: 16,
                          ),
                          colorBack: AppColor.white,
                          colorText: AppColor.headTextColor,
                          action: () => EvaluationFormCubit.get(context)
                              .editMessage(comment),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (comment.fault != null && comment.fault!.faultType != null)
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    translate(comment.fault!.faultType!),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
