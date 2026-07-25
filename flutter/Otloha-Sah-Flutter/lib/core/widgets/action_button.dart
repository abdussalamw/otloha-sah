import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.title,
    this.icon,
    this.onPress,
    this.color,
    this.radius,
  });

  final String title;
  final Color? color;
  final Widget? icon;
  final Function()? onPress;

  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: InkWell(
          onTap: onPress,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius ?? 18),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  color ?? const Color(0xff00D2FF),
                  color ?? const Color(0xff3A7BD5),
                ],
              ),
            ),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColor.white,
                    // fontSize: 20,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
