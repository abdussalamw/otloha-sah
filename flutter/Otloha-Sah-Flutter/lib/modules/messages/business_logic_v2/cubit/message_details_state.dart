part of 'message_details_cubit.dart';

abstract class MessageDetailsState {
  const MessageDetailsState();
}

class MessageDetailsInitial extends MessageDetailsState {}

class MessageDetailsChangeSelectedTypeState extends MessageDetailsState {}

class MessageDetailsChangeSelectedTextState extends MessageDetailsState {}

class MessageDetailsPlayerIsPauseState extends MessageDetailsState {}

class MessageDetailsChangeDurationState extends MessageDetailsState {}

class MessageDetailsDeleteCommentState extends MessageDetailsState {}

class MessageDetailsEditCommentState extends MessageDetailsState {}

class MessageDetailsResetFormState extends MessageDetailsState {}

class MessageDetailsChangeIndexPlayerState extends MessageDetailsState {}

class ActionOnMessageChangeIsAcceptState extends MessageDetailsState {}

class ActionOnMessagLoading extends MessageDetailsState {}

class ActionOnMessageChangeIsMarkState extends MessageDetailsState {}

class ActionOnMessageFinishDoneState extends MessageDetailsState {}

class ActionOnMessageFinishErrorState extends MessageDetailsState {}

class CreatingMessageState extends MessageDetailsState {}

class MessageCreatedState extends MessageDetailsState {}
