import 'package:flutter/material.dart';

class PageAuthLayout extends StatelessWidget {
  const PageAuthLayout({
    Key? key,
    required this.pageComponents,
  }) : super(key: key);
  final Widget pageComponents;
  @override
  Widget build(BuildContext context) {
    return _pageLayout(context);
  }

  Widget _pageLayout(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/auth_background.png'),
            fit: BoxFit.cover),
      ),
      child: pageComponents,
    );
  }
}
