import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/remote/user_services.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/teacher_profile_cubit/teacher_profile_state.dart';

class TeacherProfileCubit extends Cubit<TeacherProfileState> {
  final UserServices _userServices = UserServices();

  TeacherProfileCubit() : super(TeacherProfileInitial());

  Future<void> fetchProfile(int id) async {
    emit(TeacherProfileLoading());
    // try {
    final userProfileData = await _userServices.teacherProfile(id);
    emit(TeacherProfileLoaded(userProfileData));
    // } catch (e) {
    //   // Handle errors
    //   emit(ProfileError("Error fetching profile: $e"));
    // }
  }
}
