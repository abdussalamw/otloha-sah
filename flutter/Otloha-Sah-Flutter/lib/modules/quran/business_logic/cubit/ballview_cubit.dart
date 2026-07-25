import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'ballview_state.dart';

class BallViewCubit extends Cubit<BallViewState> {
  BallViewCubit() : super(BallViewInitial());

  bool isOpen = false;

  static BallViewCubit get(context) => BlocProvider.of<BallViewCubit>(context);

  bool isHafeOp = false;
  bool isFullOp = false;
  Timer? timer;

  void viewMenu() {
    if (isHafeOp || !isFullOp) {
      isHafeOp = false;
      isFullOp = true;
      emit(BallFullOpcity());
      _setTimerFun();
    } else {
      emit(BallViewMenu());
    }
  }

  _setTimerFun() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer(const Duration(seconds: 5), () {
      if (isFullOp) {
        isFullOp = false;
        isHafeOp = true;

        emit(BallHafeOpcity());
        _setTimerFun();
      } else {
        timer!.cancel();
        isHafeOp = false;
        emit(BallHideOpcity());
      }
    });
  }

  setHaveOpcity() {
    if (!isHafeOp) {
      isHafeOp = true;
      emit(BallHafeOpcity());
    }
    _setTimerFun();
  }

  void setIsOpen(bool bool) {
    isOpen = bool;
    emit(BallViewMenuOpen());
  }
}
