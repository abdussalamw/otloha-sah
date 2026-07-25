import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/remote/firebase_service.dart';
import 'package:otloha_sah_flutter/modules/splash/business_logic/cubit/splash_cubit.dart';
import 'main_channel_state.dart';

class MainChannelCubit extends Cubit<MainChannelState> {
  MainChannelCubit() : super(MainChannelInitial()) {
    if (SplashCubit.isLogin) {
      FirebaseService.instance.setUiHandler((int notificationId) {
        emit(MainChannelUpdateState(notificationId));
      });
    }
  }

  late Stream mainChannel;

  int unseenMessageCount = 0;

  // late IOWebSocketChannel channel;

  void updateChannel() {
    // channel.sink.add(jsonEncode({'type': 'get_updates', 'message': ''}));
  }

  static MainChannelCubit get(context) => BlocProvider.of(context);
}
