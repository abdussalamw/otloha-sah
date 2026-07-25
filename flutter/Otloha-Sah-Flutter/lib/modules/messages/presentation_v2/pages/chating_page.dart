import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/modules/home/business_logic/cubit/home_cubit.dart';
import 'package:otloha_sah_flutter/modules/messages/business_logic_v2/cubit/rooms_cubit.dart';
import '../../../../core/utils/constant/constants.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../data_source/models/message_model/message_model.dart';
import '../../../../data_source/models/room/room.dart';
import '../../../../data_source/user_services_data.dart';
import '../../../audio/presentation/wave_view.dart';
import '../../business_logic_v2/cubit/chat_cubit.dart';
import '../../business_logic_v2/cubit/record_cubit.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/message_chat_widget.dart';
import '../widgets/user_app_bar.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/verses_local_data_source.dart';
import 'package:quran_widget_flutter/model/verse.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:readmore/readmore.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:web_socket_channel/io.dart';

class ChatingPage extends StatefulWidget {
  const ChatingPage({
    super.key,
    this.room,
  });

  final Room? room;

  @override
  State<ChatingPage> createState() => _ChatingPageState();
}

class _ChatingPageState extends State<ChatingPage> {
  List<MessageModel> messages = [];

  ScrollController _scrollController = ScrollController();


  List<MessageModel> get chatMessages {
    if (widget.room!.isClosed) {
      if (ChatCubit.get(context).room.messages == null) {
        return messages;
      }
      return ChatCubit.get(context).room.messages ?? [];
    }
    return messages.toSet().toList();
  }

  Room get room => ChatCubit.get(context).room;
  late IOWebSocketChannel channel;

  initial(List<dynamic> json) {
    json.map((e) => messages.add(MessageModel.fromMap(e))).toList();
    messages = messages.toList();
  }

  late ChatCubit chatCubit;
  late RecordCubit recordCubit;

  @override
  void initState() {
    ChatCubit.get(context).setRoom(widget.room!);
    if (widget.room!.isClosed) {
      Future.microtask(() {
        ChatCubit.get(context).getMessages().then((value) => setState(() {
          messages = chatMessages;
        }));
      });

    }

    channel = IOWebSocketChannel.connect(
        '${Constants.socketUrl}/ws/chat/recitation/${room.uuid}/?token=${UserDataServices.instance.getTokenRefresh}',
        pingInterval: const Duration(seconds: 5));
    print(
        '${Constants.socketUrl}/ws/chat/recitation/${room.uuid}/?token=${UserDataServices.instance.getTokenRefresh}');
    super.initState();
    // Future.delayed(const Duration(seconds: 1), () {
    //   RoomsCubit.get(context).getRooms(withLoading: false);
    //   MainChannelCubit.get(context).updateChannel();
    // });
    chatCubit = ChatCubit.get(context);
    recordCubit = RecordCubit.get(context);
    // chatCubit.setOnTextChange(
    //   (text) {
    //     channel.sink.add(jsonEncode({
    //       'type': 'typing',
    //       'message': {'user': UserDataServices.instance.getUserId()}
    //     }));
    //   },
    // );
    // chatCubit.setOnStopTyping(
    //   () {
    //     // channel.sink.add(jsonEncode({'type': 'typing', 'message': {}}));
    //   },
    // );

    showRateTeacherDialog();

    HomeCubit.get(context).getUnseenCount();
  }

  bool isTyping = false;

  @override
  void dispose() {
    channel.sink.close();
    // recordCubit.playPauseAction();
    chatCubit.reset();
    recordCubit.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (room.recitation!.ownerRate == 0.0) {}
    return SafeArea(
      child: StreamBuilder<dynamic>(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) print('${snapshot.error}');
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data!);
              if (data == null) {
                ChatCubit.get(context).closeRoom();
                showRateTeacherDialog();
              } else if (data['type'] == 'initialize') {
                messages.clear();
                initial(data['message']['messages']);
              } else if (data['type'] == 'typing') {
                isTyping = data['message']['user'] !=
                        UserDataServices.instance.getUserId() &&
                    data['message']['user'] != null;
              } else if (data['type'] == 'add_message') {
                messages.add(MessageModel.fromMap(data['message']));
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 40);
              } else if (data['type'] == 'close_room') {
                ChatCubit.get(context).closeRoom();
                showRateTeacherDialog();
              }
            }
      
            return Scaffold(
                appBar: AppBar(
                  title: UserAppBar(
                    user: room.users.firstWhere((element) =>
                        element.id != UserDataServices.instance.getUserId()),
                    isTyping: isTyping,
                  ),
                  elevation: 0,
                  centerTitle: false,
                  titleSpacing: 0,
                  actions: [
                    BlocBuilder<ChatCubit, ChatState>(
                      builder: (context, state) {
                        if (!ChatCubit.get(context).isRoomClosed &&
                            room.recitation!.teacher?.id ==
                                UserDataServices.instance.getUserId()) {
                          return PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 16,
                              color: AppColor.userNameColor,
                            ),
                            onSelected: (val) {
                              channel.sink.add(
                                jsonEncode(
                                  {'type': 'close_room', 'message': {}},
                                ),
                              );
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text(translate('close_chat')),
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      },
                    )
                  ],
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: AppColor.userNameColor,
                    ),
                  ),
                ),
                body: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 64.0),
                        child: Image.asset(
                          AppIcons.backChatPage,
                          width: 80,
                          height: 185,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        AppIcons.back2ChatPage,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FutureBuilder<List<Verse>>(
                          future: VersesLocalDataSource().findVersesBetween(
                              room.recitation!.getVerseList().first,
                              room.recitation!.getVerseList().last),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ReadMoreText(
                                    snapshot.data!.map((e) => e.text).join(' '),
                                    trimLines: 2,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: translate('show_more'),
                                    trimExpandedText: translate('show_less'),
                                    moreStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    lessStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppColor.headTextColor,
                                      // wordSpacing: .5,
                                      fontFamily: 'Hafs17',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                        if (room.recitation!.record != null)
                          WaveViewPlayAudio(
                            isPlay: false,
                            record: room.recitation!.record!,
                            wavePath: '',
                          ),
                        Expanded(
                          child: ListView.builder(
                            // reverse: true,
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              return SwipeTo(
                                onLeftSwipe: messages.toList()[index].user ==
                                        UserDataServices.instance.getUserId()
                                    ? (details) {
                                        ChatCubit.get(context)
                                            .onReply(messages[index]);
                                      }
                                    : null,
                                onRightSwipe: messages[index].user !=
                                        UserDataServices.instance.getUserId()
                                    ? (details) {
                                        ChatCubit.get(context)
                                            .onReply(messages[index]);
                                      }
                                    : null,
                                child: MessageChatWidget(
                                  message: messages[index],
                                  replyToMessage: messages[index].replyTo != null
                                      ? messages.firstWhere((element) =>
                                          element.id == messages[index].replyTo)
                                      : null,
                                  index: index,
                                ),
                              );
                            },
                          ),
                        ),
                        BlocBuilder<ChatCubit, ChatState>(
                          builder: (context, chatState) {
                            if (room.recitation!.evaluatedAt == null) {
                              return Container(
                                width: double.infinity,
                                color: AppColor.backItem,
                                child: Align(
                                  alignment: Alignment.center,
                                  child:
                                      Text(translate('waiting_for_evaluation')),
                                ),
                              );
                            }
                            if (room.isClosed) {
                              return Container(
                                width: double.infinity,
                                color: AppColor.backItem,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(translate('chat_closed')),
                                ),
                              );
                            }
                            if (!room.isClosed &&
                                room.recitation!.evaluatedAt != null) {
                              return ChatInputField(
                                onCancelRecord: () {
                                  ChatCubit.get(context).setRecordPath(null);
                                },
                                onSend: chatState is SendingMessageState
                                    ? null
                                    : (String text) async {
                                        await RecordCubit.get(context)
                                            .stopRecord();
                                        var message = await ChatCubit.get(context)
                                            .sendMessage(text);
                                        if (message.isNotEmpty) {
                                          channel.sink.add(jsonEncode({
                                            'type': 'add_message',
                                            'message': message
                                          }));
                                        }
                                        RecordCubit.get(context)
                                            .reset(isReset: false);
                                      },
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
                  ],
                ));
          }),
    );
  }

  showRateTeacherDialog() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (room.recitation!.ownerRate == 0.0 &&
            ChatCubit.get(context).isRoomClosed &&
            UserDataServices.instance.getUserId()! ==
                room.recitation!.owner!.id) {
          showDialog(
            context: context,
            barrierDismissible:
                true, // set to false if you want to force a rating
            builder: (context) => RatingDialog(
              initialRating: 1.0,
              // your app's name?
              title: Text(
                translate('evaluation_rating'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // encourage your user to leave a high rating?
              message: Text(
                translate('rate_your_teacher'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
              // your app's logo?
              // image: const FlutterLogo(size: 100),
              submitButtonText: translate('submit'),
              commentHint: translate('what_you_think'),
              onCancelled: () => print('cancelled'),
              onSubmitted: (response) {
                ChatCubit.get(context)
                    .rateTeacher(response.rating, room.recitation!.id);
                context.read<RoomsCubit>().getRooms(withLoading: false);
              },
            ),
          );
        }
      },
    );
  }
}

/* Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 64.0),
              child: Image.asset(
                AppIcons.backChatPage,
                width: 80,
                height: 185,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              AppIcons.back2ChatPage,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ), */

/*
Dismissible(
            key: UniqueKey(),
            onDismissed: ChatCubit.get(context).onDismissed,




             Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Image.asset(
                AppIcons.backChatPage,
                width: 80,
                height: 185,
              ),
            ),
          ), */
