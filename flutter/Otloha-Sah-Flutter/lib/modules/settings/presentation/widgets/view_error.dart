import 'package:flutter/material.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/widgets/text_view.dart';

class ViewError extends StatelessWidget {
  const ViewError({Key? key, required this.error}) : super(key: key);

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppIcons.emptyIcon,
            height: 150,
            width: 150,
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextView(text: 'No Data to Fetch!\n Error is'+error),
          ),
        ],
      ),
    );
  }
}
