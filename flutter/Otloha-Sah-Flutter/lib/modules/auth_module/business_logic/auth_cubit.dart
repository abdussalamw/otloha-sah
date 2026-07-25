import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:otloha_sah_flutter/data_source/remote/user_services.dart';
import '../../../core/utils/constant/constants.dart';
import '../../../data_source/cache_helper.dart';
import '../../../data_source/remote/auth_services.dart';
import '../../../data_source/remote/firebase_service.dart';
import '../../../data_source/user_services_data.dart';
import '../../splash/business_logic/cubit/splash_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/error/exceptions.dart';
import '../../../data_source/data_source.dart';
import '../../../data_source/models/auth_model/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final loginformKey = GlobalKey<FormBuilderState>();
  final signupformKey = GlobalKey<FormBuilderState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'SA');
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isStudent = true, isTeacher = false;

  studentPressed() {
    isStudent = true;
    isTeacher = false;
    emit(StudentRolePickedState());
  }

  teacherPressed() {
    isTeacher = true;
    isStudent = false;
    emit(TeacherRolePickedState());
  }

  DateTime currentDate = DateTime.now();

  String select = 'male';
  String msg = '';
  static AuthCubit get(context) => BlocProvider.of(context);

  late User userProfile;

  setInitail() {
    emit(AuthInitial());
  }

  thenAuth() async {
    userProfile = await AppDataSource().myProfile();

    await UserDataServices.instance.insertUser(userProfile);
    if (userProfile.teacherProfile != null) {
      CacheHelper.saveData(
          key: Constants.teacherProfile,
          value: jsonEncode(userProfile.teacherProfile!.toJson()));
    }

    if (userProfile.phoneVerifiedAt != null) {
      if (userProfile.favoriteTeacher != null) {
        User teacherProfile =
            await AppDataSource().userProfile(userProfile.favoriteTeacher ?? 0);

        await UserDataServices.instance.insertTeacher(teacherProfile);
      }

      await SplashCubit().getUsersInfo(fetchedUserprofile: userProfile);
      if (!Platform.isIOS) {
        await FirebaseService.instance.initNotifications();
      }

      // final settings = await SettingsApi().getSettingList('privacy');
      // if (settings.isEmpty) {
      //   await SettingsApi().resetSettings('privacy');
      // }
      // bool isProfileComplelete = !(userProfile.email == null ||
      //     userProfile.username == null ||
      //     userProfile.phone == null ||
      //     (userProfile.phone != null && userProfile.phone!.isEmpty) ||
      //     userProfile.birthdate == null ||
      //     userProfile.gender == null);

      emit(ThenAuthState(isFirstSocial: false, isProfileCompelete: true));
    } else {
      //TODO: is Phone verified
    }
  }

  Future<void> userLogIn({required email, required password}) async {
    emit(LogInLoadingState());

    try {
      final response =
          await AppDataSource().userLogIn(email: email, password: password);
      var userModel = UserModelAuth.fromJson(response.data);
      await UserDataServices.instance
          .saveToken(userModel.accessToken, userModel.refreshToken);

      SplashCubit.isLogin = true;

      emit(LogInSuccessState());
    } on InvalidData catch (error) {
      emit(LogInErrorState(error.errors!));
    } on AuthError catch (error) {
      emit(LogInErrorState({'non_field_errors': translate('Invalid credentials')}));
    } on Exception catch (e, _) {
      print(e);
      ExceptionHandling.hanleToastFromException(e);
      emit(ErrorState(error: e));
    }
  }

  Future<void> passwordReset({required email}) async {
    emit(ForgotPasswordLoadingState());

    try {
      final response = await AppDataSource().passwordReset(email: email);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: tr('Reset Password email has been sent to your email please check it!'), toastLength: Toast.LENGTH_LONG);
        msg = tr('Reset Password email has');
        emit(ForgotPasswordSuccessState());
      } else {
        // msg = response.data['message'];
        emit(
          ForgotPasswordErrorState(
            {
              'email': [msg]
            },
          ),
        );
      }
    } on InvalidData catch (error) {
      emit(ForgotPasswordErrorState(error.errors!));
    } on Exception catch (e, _) {
      ExceptionHandling.hanleToastFromException(e);
      emit(ErrorState(error: e));
    }

    //print(await AppDataSource().getProfile());
  }

  Future<void> userRegister({
    email,
    username,
    password1,
    password2,
    birthdate,
    phone,
    gender,
  }) async {
    emit(RegisterLoadingState());
    try {
      final response = await AppDataSource().userRegister(
          birthdate: birthdate,
          email: email,
          gender: gender,
          password1: password1,
          password2: password2,
          phone: phone,
          username: username);
      var userModel = UserModelAuth.fromJson(response.data);
      await UserDataServices.instance
          .saveToken(userModel.accessToken, userModel.refreshToken);
      SplashCubit.isLogin = true;
      // await thenAuth(response);

      emit(RegisterSuccessState());
    } on InvalidData catch (error) {
      emit(RegisterErrorState(error.errors!));
    } on ServerError catch (_) {
    } on Exception catch (e, _) {
      print('error $e');
      ExceptionHandling.hanleToastFromException(e);
      emit(ErrorState(error: e));
    }
  }

  Future<void> userLogOut() async {
    emit(LogOutLoadingState());
    try {
      AppDataSource().logOut();
    } catch (error) {
      // emit(LogOutErrorState(error.toString()));
    }
    FirebaseService.instance.deleteToken();
    SplashCubit.signOut();
    changeIsLogin(islog: false);
    emit(LogOutSuccessState());
    UserDataServices.instance.signOut();
  }

  Future<void> changeIsLogin({bool? islog}) async {
    String? token = UserDataServices.instance.getToken;
    if (token == null || token.isEmpty || token == '' || islog == false) {
      emit(ChangeIsLogInFalseStateState());
    } else {
      emit(ChangeIsLogInTrueStateState());
    }
  }

  void startSignUp() {
    log(signupformKey.currentState!.saveAndValidate().toString());
    if (signupformKey.currentState!.validate()) {
      String formattedDate =
          DateFormat('yyyy-MM-dd', 'en_US').format(currentDate);

      userRegister(
        email: emailController.text,
        username: userNameController.text,
        phone: phoneNumber.phoneNumber,
        password2: confirmPasswordController.text,
        password1: passwordController.text,
        gender: select.toLowerCase(),
        birthdate: formattedDate,
      ).then((value) {
        //Get.offAll(() => const HomePage());
      });
    }
  }

  Future<void> deleteAccount() async {
    await AuthApi().deleteAccount();
    SplashCubit.signOut();
    await changeIsLogin(islog: false);
    emit(LogOutSuccessState());
    UserDataServices.instance.signOut();
    emit(LogOutSuccessState());
  }

  Map<Providers, BaseProvider> providers = {
    Providers.facebook: FacebookProvider(),
  };

  Future loginWith(Providers provider) async {
    final response = await providers[provider]!.login();
    try {
      // await thenAuth(response);
      emit(LogInSuccessState());
    } on InvalidData catch (error) {
      emit(LogInErrorState(error.errors!));
    } on Exception catch (e, _) {
      ExceptionHandling.hanleToastFromException(e);
      emit(ErrorState(error: e));
    }
  }

  Future<void> updateProfile() async {
    String formattedDate =
        DateFormat('yyyy-MM-dd', 'en_US').format(currentDate);
    emailController.text = emailController.text.trim();
    if (signupformKey.currentState!.validate()) {
      emit(RegisterLoadingState());
      try {
        await UserServices().updateProfile(
          username: userProfile.username != null
              ? userProfile.username
              : userNameController.text,
          gender: userProfile.gender != null
              ? userProfile.gender!
              : genderController.text,
          birthdate: userProfile.birthdate == null
              ? formattedDate
              : userProfile.birthdate!,
          email: userProfile.email ?? emailController.text,
          phone: userProfile.phone == null || userProfile.phone!.isEmpty
              ? phoneNumber.phoneNumber
              : userProfile.phone,
        );
        userProfile = await AppDataSource().myProfile();
        await UserDataServices.instance.insertUser(userProfile);
        emit(RegisterSuccessState());
      } on InvalidData catch (error) {
        emit(RegisterErrorState(error.errors!));
      } on ServerError catch (_) {
      } on Exception catch (e, _) {
        print('error $e');
        ExceptionHandling.hanleToastFromException(e);
        emit(ErrorState(error: e));
      }
    }
  }

  Future<void> verifyPhone(String code) async {
    emit(VerifyPhoneStateLoading());
    try {
      await AppDataSource().verifyOTP(code);
      emit(VerifyPhoneSuccessState());
    } on InvalidData catch (e) {
      emit(VerifyPhoneErrorState(error: e.errors ?? {}));
      if (e.errors != null && e.errors!.keys.contains('__all__')) {
        Fluttertoast.showToast(
            msg: e.errors!['__all__']
                .toString()
                .substring(1, e.errors!['__all__'].toString().length - 1));
      }
    }
  }

  Future<void> resendPhoneCode() async {
    try {
      await AppDataSource().resendOTP();
    } catch (e) {}
  }
}
