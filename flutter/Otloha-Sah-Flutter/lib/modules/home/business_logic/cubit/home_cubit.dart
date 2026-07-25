import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../../data_source/remote/notification_service.dart';
import '../../../../data_source/user_services_data.dart';
import '../../presentation/widget/init_data.dart';
import '../../presentation/widget/sub_section_item.dart';
import '../../../splash/business_logic/cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);

  bool isExit = false;

  int unseenMessagesCount = 0;
  int unseenNotificationsCount = 0;
  getUnseenCount() async {
    if (SplashCubit.isLogin) {
      Map<String, dynamic> payload =
          await NotificationsService().getUnseenCount();
      unseenMessagesCount = payload['unseen_messages']! as int;
      unseenNotificationsCount = payload['unseen_notifications']! as int;
      emit(ChangeDataState());
    }
  }

  setExit(bool value) {
    isExit = value;
  }

  getUserData() {
    emit(ChangeDataState());
  }

  List<SubSectionItem> get subSectionData =>
      _subSectionData(UserDataServices.instance.isATeacher);

  List<SubSectionItem> _subSectionData(bool isATeacher) {
    if (isATeacher) {
      SubSectionDataTeacher().subSectionDataTeacher[4].subTitle =
          UserDataServices.instance.teacherName ?? '';
      return SubSectionDataTeacher().subSectionDataTeacher;
    } else {
      SubSectionDataStudents().subSectionDataStudents[4].subTitle =
          UserDataServices.instance.teacherName ?? '';
      return SubSectionDataStudents().subSectionDataStudents;
    }
  }

  changeIndex(int? index) {
    debugPrint('index $index');
    emit(HomeChangeIndex(index ?? 0));
  }

  void setChange() {
    _subSectionData(SplashCubit.user?.isTeacher ?? false);
    emit(ChangeDataState());
  }
}
