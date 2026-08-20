import 'dart:convert';

import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:retry_queue_manager/retry_queue_manager.dart';

import '../core/network/refresh_token_model.dart';
import '../core/utils/constant/constants.dart';
import 'cache_helper.dart';
import 'local/database/database_repository.dart';

class UserDataServices {
  static final UserDataServices _ds = UserDataServices._internalInstance();

  UserDataServices._internalInstance();

  static UserDataServices get instance => _ds;

  factory UserDataServices() => instance;

  User? _user;
  User? _teacherFav;

  bool get isLogin => getToken != null;

  String? get getToken {
    String? token = CacheHelper.getData(key: Constants.tokenKey);
    if (token != null && token.isNotEmpty) {
      return token;
    } else {
      return null;
    }
  }

  bool get isHaveFavTeacher =>
      _user?.favoriteTeacher != null && (_user!.favoriteTeacher ?? 0) > 0;

  bool get isATeacher => _user?.isTeacher ?? false;

  Future saveToken(String? token, String? refreshToken) async {
    await CacheHelper.saveData(key: Constants.tokenKey, value: token);
    await CacheHelper.saveData(
        key: Constants.tokenRefrechKey, value: refreshToken);
  }

  String? get getTokenRefresh {
    return CacheHelper.getData(key: Constants.tokenRefrechKey);
  }

  String? get teacherName => _teacherFav?.fullname;

  Future<User?> getUserData() async {
    var userId = getUserId();
    if (userId != null) {
      _user = await DatabaseRepository.instance.getUser(userId);

      return _user;
    } else {
      return null;
    }
  }

  User? getUserDataFast() {
    var userData = CacheHelper.getData(key: Constants.userDataKey);
    if (userData != null) {
      _user = User.fromJson(jsonDecode(userData));
      return _user;
    } else {
      return null;
    }
  }

  Future<User?> getFavTeacherData() async {
    if ((await getUserData()) != null) {
      return _teacherFav ??= await DatabaseRepository.instance
          .getFavTeacher(_user?.favoriteTeacher ?? 0);
    }
    return null;
  }

  signOut() async {
    await CacheHelper.clearData(key: Constants.userDataKey);
    await CacheHelper.clearData(key: Constants.userIdKey);
    await CacheHelper.clearData(key: Constants.tokenKey);
    await CacheHelper.clearData(key: Constants.tokenRefrechKey);
    await CacheHelper.clearData(key: Constants.teacherProfile);

    await QueueManager(apiHandler: ApiBaseHelper()).clear();
    _user = null;
    _teacherFav = null;
  }

  int? getUserId() {
    return CacheHelper.getData(key: Constants.userIdKey);
  }

  Future updateUser(RefreshTokenModel refreshTokenModel) async {
    await saveToken(refreshTokenModel.access, refreshTokenModel.refresh);
    // // await DatabaseRepository.instance.updateUser(_user!);
    // await CacheHelper.saveData(
    //     key: Constants.userDataKey, value: _user!.toJson());
  }

  Future<User> updateUserData(User user) async {
    await DatabaseRepository.instance.updateUser(user);
    await CacheHelper.saveData(
        key: Constants.userDataKey, value: jsonEncode(user.toJson()));
    _user = user;
    return user;
  }
/*
*User user = (await DatabaseRepository().getUser(currentToken))!;
                user.accessToken = t.access;

                await DatabaseRepository().updateUser(user);
                await CacheHelper.saveData(
                    key: Constants.tokenKey, value: t.access); */

  Future insertTeacher(User user) async {
    await DatabaseRepository.instance.insertUser(user);

    _teacherFav = user;
  }

  removeFavoriteTeach() {
    _teacherFav = null;
    _user?.favoriteTeacher = null;
  }

  Future<void> insertUser(User user) async {
    await DatabaseRepository.instance.initDb;
    await DatabaseRepository.instance.migrateGuestQuranData(user.id);

    await CacheHelper.saveData(key: Constants.userIdKey, value: user.id);
    await CacheHelper.saveData(
      key: Constants.userDataKey,
      value: jsonEncode(user.toJson()),
    );
    await DatabaseRepository.instance.insertUser(user);
  }
}
