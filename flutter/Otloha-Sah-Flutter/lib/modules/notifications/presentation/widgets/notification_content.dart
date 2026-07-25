import 'package:flutter/material.dart';
import '../../../../core/utils/themes/color.dart';

class NotificationContent extends StatelessWidget {
  const NotificationContent({Key? key, required this.text}) : super(key: key);
  final String text;

  TextStyle style(String item) {
    return TextStyle(
      color:
          RegExp(r'([#][^\s#]*)').hasMatch(item) ? Colors.blue : Colors.black,
      fontFamily:
          // RegExp(r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa-zA-Z-_]*$')
          //         .hasMatch(item.replaceAll("'", ''))
          //     ?
          'Hafs20',
      // : 'Cairo',
      fontSize: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> content = text.split(' ');

    Map<String, TextStyle> styledContent = {};
    for (int i = 0; i < content.length; i++) {
      if (content[i].contains("'")) {}
    }
    for (final item in content) {
      if (item.contains('[') || item.contains(']')) {
        styledContent[item
                .splitMapJoin(r'[', onMatch: (m) => '')
                .splitMapJoin(r']', onMatch: (m) => '')] =
            const TextStyle(
                color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold);
      } else if (item.contains('r') && item.contains("'")) {
        styledContent[item.substring(1, item.length)] = style(item);
      } else if (item.contains('c') && item.contains("'")) {
        styledContent[item.substring(1) + '⭐️'] = const TextStyle(
            color: AppColor.lightYellow,
            fontSize: 16,
            fontWeight: FontWeight.bold);
      } else {
        styledContent[item] = style(item);
      }
    }
    return RichText(
      text: TextSpan(
          children: styledContent.keys
              .map<TextSpan>(
                (key) => TextSpan(
                  text: '$key ',
                  style: styledContent[key],
                ),
              )
              .toList()),
    );
  }
}
