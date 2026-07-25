import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/remote/invetations_service.dart';

// Events
abstract class UnblockEvent {}

class UnblockButtonPressed extends UnblockEvent {}

// States
enum UnblockState { loading, unblocked, blocked }

class UnblockCubit extends Cubit<UnblockState> {
  UnblockCubit() : super(UnblockState.blocked);

  final InvitationsService _invitationsService = InvitationsService();

  void unblock(int id) async {
    emit(UnblockState.loading);

    // Simulating an asynchronous operation
    await _invitationsService.deleteBlock(blockId: id);
    emit(UnblockState.unblocked);
  }
}
