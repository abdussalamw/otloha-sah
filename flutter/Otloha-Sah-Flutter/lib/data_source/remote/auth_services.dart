import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';

class AuthApi {
  Future<Response> userLogIn({
    email,
    password,
  }) async {
    return await ApiBaseHelper().postHTTP(
      '/api/v2/token/',
      {
        'identifier': email,
        'password': password,
      },
      DioTypes.noAuthRequired,
    );
  }

  Future<Response> logOut({String? auth}) async {
    return await ApiBaseHelper().postHTTP(
      '/api/v2/token/blacklist/',
      {'refresh': UserDataServices.instance.getTokenRefresh},
      DioTypes.authRequired,
    );
  }

  Future<Response> passwordResetConfirm({
    uid,
    token,
    newPassword1,
    newPassword2,
  }) {
    return ApiBaseHelper().postHTTP(
      '/api/v1/password/reset/confirm/',
      {
        'uid': uid,
        'token': token,
        'new_password1': newPassword1,
        'new_password2': newPassword2,
      },
      DioTypes.noAuthRequired,
    );
  }

  Future<Response> passwordReset({required String email}) {
    return ApiBaseHelper().postHTTP(
      '/api/v2/password-reset/',
      {
        'email': email,
      },
      DioTypes.noAuthRequired,
    );
  }

  Future<Response> passwordChange(
      {old_password, new_password1, new_password2}) async {
    return await ApiBaseHelper().postHTTP(
      '/api/v1/password/change/',
      {
        'old_password': old_password,
        'new_password1': new_password1,
        'new_password2': new_password2,
      },
      DioTypes.authRequired,
    );
  }

  Future<Response> refreshToken() async {
    return await ApiBaseHelper().postHTTP(
      '/api/v1/token/refresh/',
      {},
      DioTypes.authRequired,
    );
  }

  Future<Response> userRegister(
      {email, username, password1, password2, birthdate, phone, gender}) async {
    return await ApiBaseHelper().postHTTP(
      '/api/v2/register/',
      {
        'email': email,
        'password1': password1,
        'password2': password2,
        'username': username,
        'phone': phone,
        'birthdate': birthdate,
        'gender': gender,
      },
      DioTypes.noAuthRequired,
    );
  }

  Future<User?> resendEmailVerificationEmail() async {
    Response? response = await ApiBaseHelper().getHTTP(
        '/api/v1/resend_email_activation/',
        dioTypes: DioTypes.authRequired);
    return User.fromJson(response?.data);
  }

  Future<void> verifyOTP(String code) async {
    await ApiBaseHelper().postPhotoHTTP(
      '/api/v1/verify/phone/',
      {'code': code},
      DioTypes.authRequired,
    );
  }

  Future<void> resendOTP() async {
    await ApiBaseHelper().getHTTP(
      '/api/v1/resend_phone_activation/',
      dioTypes: DioTypes.authRequired,
    );
  }

  Future<Response> deleteAccount() async {
    return await ApiBaseHelper().postHTTP(
      '/api/v1/profile/delete-account/',
      {},
      DioTypes.authRequired,
    );
  }
}

class SocialAuth {
  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //   Optional clientId
  //   clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  //   scopes: <String>[
  //     'email',
  //     'https://www.googleapis.com/auth/contacts.readonly',
  //   ],
  // );
}

abstract class BaseProvider {
  Future<Map<String, dynamic>> authenticate();
  Future<Response> login() async {
    final data = await authenticate();
    return ApiBaseHelper().postHTTP(
      '/api/v1/social/${getProviderName().toLowerCase()}/',
      data,
      DioTypes.noAuthRequired,
    );
  }

  String getProviderName() {
    return runtimeType.toString().split('Provider')[0];
  }
}

enum Providers {
  google,
  facebook,
}

class FacebookProvider extends BaseProvider {
  @override
  Future<Map<String, dynamic>> authenticate() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: [
      'email',
      'public_profile',
      'user_birthday',
      'user_gender',
    ]);

    print(result.toString());
    // print(result.accessToken);
    // print(await FacebookAuth.instance
    //     .getUserData(fields: 'name,email,birthday,gender,picture.width(400)'));

    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      final userData = await FacebookAuth.instance
          .getUserData(fields: 'name,email,birthday,gender,picture.width(400)');
      return {
        ...accessToken.toJson(),
        ...userData,
      };
    } else {
      print(result.status);
      // you are not logged
      throw Exception('Facebook login failed');
    }
  }
}

class GSIAndroidAuth {
  static final scopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'openid'
  ];
  GoogleSignIn googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId:
    //     '244791172888-pguue37p4nai4mvjssenvc0no52mp9j5.apps.googleusercontent.com',
    // serverClientId:
    // hostedDomain: 'https://5436-154-178-123-184.ngrok-free.app',
    scopes: scopes,
  );

  Future<void> handleSignIn() async {
    try {
      GoogleSignInAccount? res = await googleSignIn.signIn();
      print(res.toString());
    } catch (error) {
      print(error);
    }
  }
}
