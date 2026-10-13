import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  String get providerKey;
  Future<Map<String, dynamic>> authenticate();
  Future<Response> login() async {
    final data = await authenticate();
    return ApiBaseHelper().postHTTP(
      '/api/v2/social-login/',
      data,
      DioTypes.noAuthRequired,
    );
  }
}

enum Providers {
  google,
  facebook,
  apple,
}

class FacebookProvider extends BaseProvider {
  @override
  String get providerKey => 'facebook';

  @override
  Future<Map<String, dynamic>> authenticate() async {
    final LoginResult result = await FacebookAuth.instance.login(permissions: [
      'email',
      'public_profile',
      'user_birthday',
      'user_gender',
    ]);

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final userData = await FacebookAuth.instance
          .getUserData(fields: 'name,email,birthday,gender,picture.width(400)');
      return {
        'provider': providerKey,
        'access_token': accessToken.tokenString,
        ...accessToken.toJson(),
        ...userData,
      };
    } else {
      throw Exception('Facebook login failed: ${result.message}');
    }
  }
}

class GoogleProvider extends BaseProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
      'openid',
    ],
  );

  @override
  String get providerKey => 'gsi';

  @override
  Future<Map<String, dynamic>> authenticate() async {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account == null) {
      throw Exception('Google sign in cancelled by user');
    }
    final GoogleSignInAuthentication auth = await account.authentication;
    final token = auth.idToken ?? auth.accessToken;
    if (token == null) {
      throw Exception('No token returned from Google');
    }
    return {
      'provider': providerKey,
      'access_token': token,
      'email': account.email,
      'name': account.displayName,
    };
  }
}

class AppleProvider extends BaseProvider {
  @override
  String get providerKey => 'apple';

  @override
  Future<Map<String, dynamic>> authenticate() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final token = credential.identityToken ?? credential.authorizationCode;
    return {
      'provider': providerKey,
      'access_token': token,
      'email': credential.email,
      'first_name': credential.givenName,
      'last_name': credential.familyName,
    };
  }
}

class GSIAndroidAuth {
  static final scopes = [
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
    'openid'
  ];
  GoogleSignIn googleSignIn = GoogleSignIn(
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

