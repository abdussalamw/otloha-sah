import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../data_source/data_source.dart';
import '../../../../data_source/models/setting_model/setting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());
  static SettingsCubit get(context) => BlocProvider.of(context);

  changeSetting(List<Settings> settings) {
    emit(SettingsChange(settings: settings));
  }

  changeSettingDwon(List<Settings> settings) {
    emit(SettingsChangeDown(settings: settings));
  }

  updatePhone({required phone, required password}) {
    emit(UpdatePhoneLoadingState());
    AppDataSource().updatePhone(phone: phone, password: password).then((value) {
      emit(UpdatePhoneSuccessState(value));
    }).catchError((error) {
      if (error is InvalidData) {
        emit(InvalidDataErrorState(error: error));
        return;
      }
      emit(UpdatePhoneErrorState(error.toString()));
    });
  }

  updateEmail({required email, required password}) {
    emit(UpdateEmailLoadingState());
    AppDataSource().updateEmail(email: email, password: password).then((value) {
      emit(UpdateEmailSuccessState(value));
    }).catchError((error) {
      if (error is InvalidData) {
        emit(InvalidDataErrorState(error: error));
        return;
      }
      emit(UpdateEmailErrorState(error));
    });
  }

  regiAsTeacher({required FormData data, required Function onDone}) async {
    emit(RegisterAsTeacherLoadingState());
    try {
      Response response = await AppDataSource().registerAsATeacher(data);
      await onDone();
      emit(RegisterAsTeacherSuccessState(response));
    } on InvalidData catch (e) {
      emit(InvalidDataErrorState(error: e));
    } catch (err) {
      emit(SomeThingWentWrongState());
    }
  }

  changePassword(
      {required oldPassword, required newPassword, required confirmPassword}) {
    emit(ChangePasswordLoadingState());
    AppDataSource()
        .changePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword)
        .then((value) {
      emit(ChangePasswordSuccessState(value));
    }).catchError((error) {
      if (error is InvalidData) {
        emit(InvalidDataErrorState(error: error));
        return;
      }
      emit(ChangePasswordErrorState(error));
    });
  }

  Future<File?>? uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      emit(state);
      return file;
    } else {
      // User canceled the picker
    }
    return null;
  }
}
