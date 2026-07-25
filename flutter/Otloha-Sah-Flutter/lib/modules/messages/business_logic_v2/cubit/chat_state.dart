part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatChangeDurationState extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatChangeReplyState extends ChatState {
  final int messageId;

  const ChatChangeReplyState(this.messageId);

  @override
  List<Object> get props => [messageId];
}

class ChatRemoveReplyState extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatChangeIndexPlayerState extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatPlayerIsPauseState extends ChatState {
  @override
  List<Object?> get props => [];
}

class SendingMessageState extends ChatState {
  @override
  List<Object?> get props => [];
}

class MessageSentState extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatClosed extends ChatState {
  @override
  List<Object?> get props => [];
}

class ChatFetchMessagesState extends ChatState {
  @override
  List<Object?> get props => [];
}
