import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utils/res/icons_app.dart';

class SomethingWentWrongWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(tr('Something went wrong')));
  }
}

class ServerErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [Image.asset(AppIcons.emptyIcon), Text(tr('Server Error'))],
    ));
  }
}
