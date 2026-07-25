import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({
    Key? key,
    this.commingSoonMessage = 'comming_soon',
  }) : super(key: key);
  final String commingSoonMessage;
  static const routeName = '/comming_soon';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          tr(commingSoonMessage),
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
