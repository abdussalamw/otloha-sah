import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../../core/network/api_base_helper.dart';

import '../../../../data_source/user_services_data.dart';
import '../../../home/business_logic/cubit/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../data_source/data_source.dart';

part 'teacherviewtype_state.dart';

class TeacherviewtypeCubit extends Cubit<TeacherviewtypeState> {
  TeacherviewtypeCubit() : super(TeacherviewtypeInitial());
  List<User>? teachers;
  int selected = -1;

  static TeacherviewtypeCubit get(context) => BlocProvider.of(context);

  changeType(bool type) {
    emit(TeacherviewtypeChange(type: type));
  }

  getTeacher() async {
    selected = (await UserDataServices.instance.getFavTeacherData())?.id ?? -1;
    emit(TeacherLoadingState());
    AppDataSource().getTeacher(1)!.then((value) async {
      if (value != null && value.isNotEmpty) {
        teachers = value;

        emit(TeacherFetchedState());
      } else {
        emit(TeacherErrorState(EmptyListException()));
      }
    }).catchError((e) {
      if (e is AuthError) {
        emit(NoAuthState());
        return;
      }
      if (e is Exception) {
        emit(TeacherErrorState(e));
      }
    });
  }

  markAsFavTeacher({int? id, results, required BuildContext context}) async {
    final response = await AppDataSource().markAsFavTeacher(id: id);

    selected = results.id;

    // (controller?.itemList![controller!.itemList!.indexOf(results)]
    //         as User)
    //     .isFavorite = true;

    await saveFavTeacher(id, context);

    emit(MarkAsFavTeacherErrorState());
    emit(TeacherFetchedState());
    return response;
  }

  saveFavTeacher(int? id, BuildContext context) async {
    User? user = await UserDataServices.instance.getUserData();

    if (id != null && user != null) {
      UserDataServices.instance.insertUser(user..favoriteTeacher = id);
      User teacherProfile = await AppDataSource().userProfile(id);

      UserDataServices.instance.insertTeacher(teacherProfile);

      await UserDataServices.instance.getFavTeacherData();

      // ignore: use_build_context_synchronously
      HomeCubit.get(context).setChange();
    }
  }

  getStudents() {
    emit(TeacherLoadingState());
    AppDataSource().getStudents(1).then((value) async {
      if (value != null && value.isNotEmpty) {
        teachers = value;

        emit(TeacherFetchedState());
      } else {
        emit(TeacherErrorState(EmptyListException()));
      }
    }).catchError((e) {
      if (e is AuthError) {
        emit(NoAuthState());
        return;
      }
      emit(TeacherErrorState(e));
    });
  }

  Future<File?>? uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      emit(state);
      return file;
    }
    return null;
  }

  getNextTeachers(int nextLink) async {
    return ApiBaseHelper().getHTTP(
      '/api/v1/users/teachers/',
      queryParameters: {'page': nextLink},
      dioTypes: DioTypes.authRequired,
    );
  }

  getNextStudents(int nextLink) async {
    return ApiBaseHelper().getHTTP(
      '/api/v1/users/students/',
      queryParameters: {'page': nextLink},
      dioTypes: DioTypes.authRequired,
    );
  }

  PagingController? controller;
  setPagingController(PagingController controller) {
    this.controller = controller;
  }
}
