import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otloha_sah_flutter/data_source/remote/auth_services.dart';

class SignInDemo extends StatefulWidget {
  ///
  const SignInDemo({super.key});

  @override
  State createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';
  GSIAndroidAuth gsiAndroidAuth = GSIAndroidAuth();

  @override
  void initState() {
    super.initState();

    gsiAndroidAuth.googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
// #docregion CanAccessScopes
      // In mobile, being authenticated means being authorized...
      bool isAuthorized = account != null;

      setState(() {
        _currentUser = account;
        _isAuthorized = isAuthorized;
      });

      // Now that we know that the user can access the required scopes, the app
      // can call the REST API.
      if (isAuthorized) {
        unawaited(_handleGetContact(account));
      }
    });

    // In the web, gsiAndroidAuth. googleSignIn.signInSilently() triggers the One Tap UX.
    //
    // It is recommended by Google Identity Services to render both the One Tap UX
    // and the Google Sign In button together to "reduce friction and improve
    // sign-in rates" ([docs](https://developers.google.com/identity/gsi/web/guides/display-button#html)).
    gsiAndroidAuth.googleSignIn.signInSilently();
  }

  // Calls the People API REST endpoint for the signed-in user to retrieve information.
  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final Response response = await Dio(
      BaseOptions(
        responseType: ResponseType.json,
        headers: await user.authHeaders,
      ),
    ).get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
    );

    // final http.Response response = await http.get(
    //   Uri.parse('https://people.googleapis.com/v1/people/me/connections'
    //       '?requestMask.includeField=person.names'),
    //   headers: await user.authHeaders,
    // );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.data}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.data) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => (contact as Map<Object?, dynamic>)['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name = names.firstWhere(
        (dynamic name) =>
            (name as Map<Object?, dynamic>)['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  // This is the on-click handler for the Sign In button that is rendered by Flutter.
  //
  // On the web, the on-click handler of the Sign In button is owned by the JS
  // SDK, so this method can be considered mobile only.
  // #docregion SignIn
  Future<void> _handleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount =
          await gsiAndroidAuth.googleSignIn.signIn();
      print('-----------------------------------------------------');
      print(googleSignInAccount.toString());
      var auth = await googleSignInAccount!.authentication;

      print(auth.accessToken);
      debugPrint('asdasdasd');
      debugPrint(auth.idToken ?? '');
      showAboutDialog(context: context, children: [
        TextField(
          controller: TextEditingController(text: auth.idToken),
        ),
      ]);
      log(auth.idToken ?? '');
      print('-----------------------------------------------------');
    } catch (error) {
      print(error);
    }
  }

  // #enddocregion SignIn
  // Prompts the user to authorize `scopes`.
  //
  // This action is **required** in platforms that don't perform Authentication
  // and Authorization at the same time (like the web).
  //
  // On the web, this must be called from an user interaction (button click).
  Future<void> _handleAuthorizeScopes() async {
    const bool isAuthorized = true;
    // #enddocregion RequestScopes
    setState(() {
      _isAuthorized = isAuthorized;
    });
    // #docregion RequestScopes
    if (isAuthorized) {
      unawaited(_handleGetContact(_currentUser!));
    }
    // #enddocregion RequestScopes
  }

  Future<void> _handleSignOut() => gsiAndroidAuth.googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      // The user is Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Signed in successfully.'),
          if (_isAuthorized) ...<Widget>[
            // The user has Authorized all required scopes
            Text(_contactText),
            ElevatedButton(
              child: const Text('REFRESH'),
              onPressed: () => _handleGetContact(user),
            ),
          ],
          if (!_isAuthorized) ...<Widget>[
            // The user has NOT Authorized all required scopes.
            // (Mobile users may never see this button!)
            const Text('Additional permissions needed to read your contacts.'),
            ElevatedButton(
              onPressed: _handleAuthorizeScopes,
              child: const Text('REQUEST PERMISSIONS'),
            ),
          ],
          ElevatedButton(
            onPressed: _handleSignOut,
            child: const Text('SIGN OUT'),
          ),
        ],
      );
    } else {
      // The user is NOT Authenticated
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const Text('You are not currently signed in.'),
          // This method is used to separate mobile from web code with conditional exports.
          // See: src/sign_in_button.dart
          IconButton(
            icon: Icon(Icons.g_mobiledata),
            onPressed: _handleSignIn,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
