import 'package:flutter/material.dart';
import '../design_system/components/buttons/app_button.dart';

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
    return AppButton(
      text: title,
      onPressed: onPress,
      icon: icon,
      variant: AppButtonVariant.primary,
      isFullWidth: true,
    );
  }
}
