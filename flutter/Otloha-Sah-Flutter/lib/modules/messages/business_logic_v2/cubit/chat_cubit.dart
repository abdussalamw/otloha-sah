import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data_source/models/message_model/message_model.dart';
import '../../../../data_source/models/room/room.dart';
import '../../../../data_source/remote/recitation_services.dart';
import '../../../../data_source/remote/room_services.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  static ChatCubit get(BuildContext context) => BlocProvider.of(context);
  TextEditingController controller = TextEditingController();

  bool isFormEdit = false;
  MessageModel? replyMessage;
  late Room room;
  String? recordPath;
  Function(String?)? onTextChange;
  Function()? onStopTyping;
  late bool isRoomClosed;

  void setRoom(Room room) {
    this.room = room;
    isRoomClosed = room.isClosed;
  }

  Future getMessages() async {
    emit(ChatLoading());
    Response? res = await RoomServices().roomDetails(room.id);
    res!.data['room']['messages'] = res.data['messages'];
    room = Room.fromJson(res.data['room']);
    emit(ChatFetchMessagesState());
  }

  void closeRoom() {
    isRoomClosed = true;
    room = room.copyWith(isClosed: true);
    emit(ChatClosed());
  }

  void onReply(MessageModel message) {
    replyMessage = message;
    emit(ChatChangeReplyState(replyMessage!.id));
  }

  void removeReply() {
    replyMessage = null;
    emit(ChatRemoveReplyState());
  }

  void setRecordPath(String? recordPath) {
    this.recordPath = recordPath;
  }

  reset() {
    controller.clear();
    recordPath = null;
    replyMessage = null;
  }

  void setOnTextChange(Function(String?)? onTextChange) {
    // print(onTextChange);
    this.onTextChange = onTextChange;
  }

  setOnStopTyping(Function()? onStopTyping) {
    this.onStopTyping = onStopTyping;
  }

  void setOnChangeText(Function(String?)? onTextChange) {
    this.onTextChange = onTextChange;
  }

  rateTeacher(double rate, int recitationId) {
    UserRecitationApi().rateTeacherResponse(recitationId, rate);
    room =
        room.copyWith(recitation: room.recitation!.copyWith(ownerRate: rate));
  }

  Future<Map<String, dynamic>> sendMessage(String? text) async {
    emit(SendingMessageState());
    Map<String, dynamic> message = {};
    if (text != null || recordPath != null) {
      if (replyMessage != null) {
        message['reply_to'] = replyMessage!.id;
      }
      if (text != null && text.isNotEmpty) {
        message['text'] = text;
      }
      if (recordPath != null) {
        int recordId;
        try {
          recordId = await RoomServices().uploadRecord(recordPath!);
          message['record'] = recordId;
        } catch (e) {
          emit(MessageSentState());
        }
      }
    }
    print(message);
    reset();
    emit(MessageSentState());
    return message;
  }
}
