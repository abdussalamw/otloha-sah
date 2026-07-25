import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:retry_queue_manager/retry_queue_manager.dart';

enum InternetStatus { online, offline }

class InternetCubit extends Cubit<InternetStatus> {
  final Connectivity connectivity;
  InternetCubit(this.connectivity) : super(InternetStatus.online) {
    _init();
  }

  Future<void> _init() async {
    connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  void _handleConnectivityChange(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      emit(InternetStatus.offline);
    } else {
      QueueManager(apiHandler: ApiBaseHelper()).processQueue();
    }
  }
}
