import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/data_source/remote/user_services.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/profile_cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserServices _userServices = UserServices();

  ProfileCubit() : super(ProfileInitial());

  Future<void> fetchProfile(int id) async {
    emit(ProfileLoading());
    // try {
    final userProfileData = await _userServices.studentProfile(id);
    emit(ProfileLoaded(userProfileData));
    // } catch (e) {
    //   // Handle errors
    //   emit(ProfileError("Error fetching profile: $e"));
    // }
  }
}
