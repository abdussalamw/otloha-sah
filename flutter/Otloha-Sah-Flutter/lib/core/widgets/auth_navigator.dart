import 'package:flutter/material.dart';
import '../../data_source/user_services_data.dart';
import '../../modules/auth_module/presentation/pages/login_page.dart';

class AuthNavigator extends StatefulWidget {
  const AuthNavigator({required this.child}) : super();

  final Widget child;

  static _AuthNavigatorState? of(BuildContext context) =>
      context.findAncestorStateOfType<_AuthNavigatorState>();

  @override
  _AuthNavigatorState createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends State<AuthNavigator> {
  Future pushConditionally<T extends Object>(BuildContext context, String route,
          {var arguments}) =>
      Navigator.pushNamed(
        context,
        route,
        arguments: arguments,
      );

  @override
  Widget build(BuildContext context) => widget.child;
}
