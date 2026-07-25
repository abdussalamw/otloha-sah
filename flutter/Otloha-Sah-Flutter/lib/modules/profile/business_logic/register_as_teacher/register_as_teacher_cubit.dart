import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otloha_sah_flutter/data_source/models/user/teacher_profile.dart';
import 'register_as_teacher_state.dart';
import '../../../settings/business_logic/settings/settings_cubit.dart';
import '../../../splash/business_logic/cubit/splash_cubit.dart';
import 'package:quran_widget_flutter/data_source/local/local_data_source/narration_local_data_source.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';
import 'dart:io' as io;

class TeacherRegistrationCubit extends Cubit<TeacherRegistrationState> {
  TeacherRegistrationCubit() : super(TeacherRegistrationInitState());

  List<Narration>? narrations = [];

  final TextEditingController nameController = TextEditingController();

  final TextEditingController educationController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  PlatformFile? cv;

  Map<Narration, String?> selectedNarrations = {};

  static TeacherRegistrationCubit cubit(context) =>
      BlocProvider.of<TeacherRegistrationCubit>(context);

  Future<void> initData() async {
    narrations = await NarrationLocalDataSource().fetchNarrationsList() ?? [];
    TeacherProfile? teacherProfile = SplashCubit.teacherProfile;
    if (teacherProfile != null) {
      nameController.text = SplashCubit.teacherProfile!.fullName!;
      educationController.text = SplashCubit.teacherProfile!.educationDegree!;
      teacherProfile.certifications?.forEach((e) {
        selectedNarrations.addAll({
          narrations!.firstWhere((element) => element.id == e.narration):
              e.certification
        });
      });
    }
    emit(TeacherRegistrationChangeState(narrations));
  }

  List<Narration> getRestNarrations() {
    return narrations!
        .where((element) => !selectedNarrations.containsKey(element))
        .toList();
  }

  void uploadCVFile(PlatformFile? cv) {
    this.cv = cv;
    emit(TeacherRegistrationChangeState(cv));
  }

  void removeCVFile() {
    cv = null;

    emit(TeacherRegistrationChangeState(cv));
  }

  void addNarration(Map<Narration, String?> narrationCertification) {
    selectedNarrations.addAll(narrationCertification);
    emit(TeacherRegistrationChangeState(narrationCertification));
  }

  void removeNarration(Narration narration) {
    selectedNarrations.remove(narration);
    emit(TeacherRegistrationChangeState(selectedNarrations));
  }

  void update(
    SettingsCubit cubit,
    SettingsState state,
    BuildContext context,
  ) async {
    if (formKey.currentState!.validate()) {
      var formData = FormData.fromMap({
        // 'full_name': nameController.text,
        'teacher_type': 'volunteer',
        'education_degree': educationController.text,
        if (cv != null)
          'cv': await MultipartFile.fromFile(cv!.path!,
              filename: cv!.path!.split('/').last),
      });
      if (selectedNarrations.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Select Narration'.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        selectedNarrations.forEach(
              (key, value) {
            if (value != null && io.File(value).existsSync()) {
              formData.files.add(
                MapEntry(
                    'certifications[${selectedNarrations.keys.toList().indexOf(key)}]certification',
                    MultipartFile.fromFileSync(
                      value,
                      filename: value.split('/').last,
                    )),
              );
            }
            formData.fields.add(
              MapEntry(
                  'certifications[${selectedNarrations.keys.toList().indexOf(key)}]narration',
                  key.id.toString()),
            );
          },
        );

        await cubit.regiAsTeacher(
            data: formData,
            onDone: () async {
              await SplashCubit.get(context).getUsersInfo();
            });
      }

    }
  }
}
