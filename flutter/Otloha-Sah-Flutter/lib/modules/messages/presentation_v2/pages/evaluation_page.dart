import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:otloha_sah_flutter/modules/messages/business_logic_v2/cubit/rooms_cubit.dart';
import 'package:otloha_sah_flutter/modules/messages/presentation_v2/pages/chating_page.dart';
import '../../../../core/utils/constant/constants.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/utils/themes/text_style.dart';
import '../../../../core/widgets/warnings_and_alerts/warning.dart';
import '../../../../data_source/models/message_model/message_model.dart';
import '../../../../data_source/models/room/room.dart';
import '../../../../data_source/user_services_data.dart';
import '../../../audio/presentation/wave_view.dart';
import '../../business_logic_v2/cubit/message_details_cubit.dart';
import '../../business_logic_v2/evaluation_form/evaluation_form_cubit.dart';
import '../../business_logic_v2/evaluation_form/evaluation_form_state.dart';
import '../widgets/evaluation_form.dart';
import '../widgets/popup_action_on_message.dart';
import '../widgets/user_app_bar.dart';
import '../widgets/view_comment.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';
import 'package:web_socket_channel/io.dart';

class EvaluationPage extends StatefulWidget {
  final Room? room;
  const EvaluationPage({super.key, this.room});

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  late IOWebSocketChannel channel;
  late Stream streamSubscription;
  List<MessageModel> messages = [];
  User? receiver;

  @override
  initState() {
    channel = IOWebSocketChannel.connect(
      // ws://utl/ws/chat/type/uuid/?token=refresh_token
      '${Constants.socketUrl}/ws/chat/recitation/${widget.room!.uuid}/?token=${UserDataServices.instance.getTokenRefresh}',
    );

    MessageDetailsCubit.get(context).setRoom(widget.room!);
    receiver = widget.room!.users.firstWhere(
      (element) => element.id != UserDataServices.instance.getUserId(),
    );

    streamSubscription = channel.stream.asBroadcastStream();
    super.initState();
  }

  bool get messagesHasRecord {
    return messages.where((e) => e.record != null).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.grey[200],
        width: double.infinity,
        child: ListTile(
          title: StreamBuilder<dynamic>(
              stream: streamSubscription,
              builder: (context, snapshot) {
                return Container(
                  height: 40,
                  color: Colors.grey[200],
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: messagesHasRecord
                          ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff00D2FF),
                                Color(0xff3A7BD5),
                              ],
                            )
                          : null,
                    ),
                    child: InkWell(
                      onTap: messagesHasRecord
                          ? () {
                              showModalBottomSheet(
                                backgroundColor:
                                    const Color.fromARGB(0, 97, 0, 0),
                                context: context,
                                builder: (context) =>
                                    const PopupActionOnMessage(),
                              );
                            }
                          : null,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          translate('finish_evaluation'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
          trailing: PopupMenuButton<String>(
            icon: const Icon(Icons.settings),
            onSelected: (value) async {
              if (value == '1') {
                Loader.show(context);
                await MessageDetailsCubit.get(context)
                    .finishEvaluation(recitationResult: 'rejected');
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatingPage(
                      room: MessageDetailsCubit.get(context).room!.copyWith(
                            recitation: MessageDetailsCubit.get(context)
                                .room!
                                .recitation!
                                .copyWith(
                                    evaluatedAt: DateTime.now().toString()),
                          ),
                    ),
                  ),
                );
                Loader.hide();
                // ignore: use_build_context_synchronously
                await RoomsCubit.get(context).getRooms(withLoading: false);
              } else {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => const ConfirmReport(),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: '1',
                child: Text(translate('reject')),
              ),
              PopupMenuItem(
                value: '2',
                child: Text(translate('report')),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: UserAppBar(
          isTyping: false,
          user: receiver!,
        ),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: AppColor.userNameColor,
            )),
      ),
      body: StreamBuilder<dynamic>(
          stream: streamSubscription,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              channel = IOWebSocketChannel.connect(
                // ws://utl/ws/chat/type/uuid/?token=refresh_token
                '${Constants.socketUrl}/ws/chat/recitation/${widget.room!.uuid}/?token=${UserDataServices.instance.getTokenRefresh}',
              );
            }
            print(
                '${Constants.socketUrl}/ws/chat/recitation/${widget.room!.uuid}/?token=${UserDataServices.instance.getTokenRefresh}');
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data!);
              if (data['type'] == 'initialize') {
                messages = data['message']['messages']
                    .map<MessageModel>(
                        (element) => MessageModel.fromMap(element))
                    .toList();
              } else if (data['type'] == 'typing') {
                messages.add(MessageModel.fromMap(data['message']));
              } else if (data['type'] == 'add_message') {
                messages.add(MessageModel.fromMap(data['message']));
              } else if (data['type'] == 'delete_message') {
                messages.removeWhere(
                    (element) => element.id == data['message']['id']);
              } else if (data['type'] == 'edit_message') {
                int editedMessageIndex = messages.indexWhere(
                    (element) => data['message']['id'] == element.id);
                messages[editedMessageIndex] =
                    MessageModel.fromMap(data['message']);
              } else if (data['type'] == 'form-errors') {
                Fluttertoast.showToast(
                  msg: data['message']['non_field_errors'][0],
                  backgroundColor: Colors.red,
                );
              }
            }

            return BlocBuilder<MessageDetailsCubit, MessageDetailsState>(
              builder: (context, state) {
                return BlocProvider(
                  create: (context) => EvaluationFormCubit(
                    channel: channel,
                    commentController: TextEditingController(),
                    verseText: MessageDetailsCubit.get(context).ayha,
                  ),
                  child: BlocBuilder<EvaluationFormCubit, EvaluationFormState>(
                    builder: (context, formState) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.warningColor,
                            ),
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(
                              top: 10,
                              left: 20,
                              right: 20,
                            ),
                            child: WarningMessage(
                              text:
                                  '${translate('Give')} ${receiver?.username} ${translate('better evaluation and record to him.')}',
                            ),
                          ),
                          Expanded(
                            child: ListView(children: [
                              const SizedBox(height: 8),
                              const MessageDetailsInfo(),
                              if (EvaluationFormCubit.get(context).message ==
                                  null)
                                EvaluationForm(channel: channel),
                              ViewMessages(
                                channel: channel,
                                messages: messages,
                              ),
                            ]),
                          ),
                          const SizedBox(
                            height: 30,
                          )
                        ],
                      );
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}

class ButtonApp extends StatelessWidget {
  const ButtonApp({
    Key? key,
    required this.title,
    this.icon,
    this.onPress,
    this.color,
    this.radius,
  }) : super(key: key);

  final String title;
  final Color? color;
  final Widget? icon;
  final Function()? onPress;

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: InkWell(
          onTap: onPress,
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius ?? 18),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color ?? const Color(0xff00D2FF),
                  color ?? const Color(0xff3A7BD5),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColor.white,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MessageDetailsInfo extends StatelessWidget {
  const MessageDetailsInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Color(ThemeCubit.isDark ? 0xFF272727 : 0xfff6f6f6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 165),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: UserDataServices.instance
                              .getUserDataFast()
                              ?.teacherProfile
                              ?.canReplyOnEveryVerseInRecitation ??
                          false
                      ? SelectableText(
                          MessageDetailsCubit.get(context).ayha,
                          style: AppStyle().textStyle1.copyWith(
                                fontSize: 20,
                                color: AppColor.headTextColor,
                                fontWeight: FontWeight.bold,
                                wordSpacing: .5,
                                fontFamily: 'Hafs17',
                              ),
                          onSelectionChanged: MessageDetailsCubit.get(context)
                              .onSelectionChanged,
                          toolbarOptions: const ToolbarOptions(
                              copy: false, selectAll: false),
                        )
                      : Text(
                          MessageDetailsCubit.get(context).ayha,
                          style: AppStyle().textStyle1.copyWith(
                                fontSize: 20,
                                color: AppColor.headTextColor,
                                fontWeight: FontWeight.bold,
                                wordSpacing: .5,
                                fontFamily: 'Hafs17',
                              ),
                        ),
                ),
              ),
            ),
          ),
          if (MessageDetailsCubit.get(context).recitation?.record == null)
            WarningMessage(text: translate('Record is Not Availabe'))
          else
            WaveViewPlayAudio(
              isPlay: false,
              record: MessageDetailsCubit.get(context).recitation!.record!,
              wavePath: '',
            ),
        ],
      ),
    );
  }
}
