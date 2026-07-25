import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../../core/error/exceptions.dart';

import '../../../../data_source/remote/user_services.dart';
import '../../../../data_source/user_services_data.dart';
import 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  static UpdateProfileCubit get(context) => BlocProvider.of(context);

  late User user;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firseNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  String? birthDate;
  XFile? pickedImage;
  final picker = ImagePicker();
  String remoteImageUrl = '';

  void init() {
    user = UserDataServices.instance.getUserDataFast()!;
    firseNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    usernameController.text = user.username;
    genderController.text = user.gender;
    bioController.text = user.bio ?? '';
    birthdateController.text = user.birthdate ?? '';
    remoteImageUrl = user.profileImage ?? '';
    birthDate = user.birthdate;
  }

  pickImage(ImageSource source) async {
    pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) emit(ImagePickedState(pickedImage!.path));
  }

  Future<void> updateProfile() async {
    try {
      if (formKey.currentState!.validate()) {
        emit(UpdateProfileLoading());

        File? file = pickedImage != null ? File(pickedImage!.path) : null;

        await UserServices().updateProfile(
          firstName: firseNameController.text,
          lastName: lastNameController.text,
          username: usernameController.text,
          bio: bioController.text,
          image: file == null
              ? null
              : MultipartFile.fromBytes(file.readAsBytesSync(),
                  filename: pickedImage?.path.split('/').last),
          gender: genderController.text,
          birthdate: birthdateController.text,
        );
        User user = await UserServices().myProfile();
        final userDb = await UserDataServices.instance.updateUserData(user);
        emit(UpdateProfileSuccess(userDb));
        Fluttertoast.showToast(msg: tr('profile_updated_successfully'));
      }
    } on InvalidData catch (e) {
      emit(InvalidDataErrorState(e.errors ?? {}));
    }
  }
}
