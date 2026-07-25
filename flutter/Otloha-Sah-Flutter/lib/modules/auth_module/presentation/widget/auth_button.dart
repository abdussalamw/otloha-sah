import 'package:flutter/material.dart';
import '../../../../core/utils/themes/color.dart';

class ButtonApp extends StatelessWidget {
  final String buttonText;
  final double width;
  final double? height;
  final Function()? onPressed;
  final List<Color> colors;
  final BorderRadius? borderRaduis;
  final TextStyle? labelStyle;

  const ButtonApp({
    required this.buttonText,
    required this.width,
    required this.onPressed,
    required this.colors,
    this.height,
    this.borderRaduis,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 1),
            blurRadius: 1.0,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          //stops: const [0.0, 1.0],
          colors: colors,
        ),
        color: Colors.deepPurple.shade300,
        borderRadius: borderRaduis ?? BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: borderRaduis ?? BorderRadius.circular(22.0),
            ),
          ),
          minimumSize: MaterialStateProperty.all(Size(width, height ?? 40)),
          maximumSize: MaterialStateProperty.all(Size(width, height ?? 40)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          // elevation: MaterialStateProperty.all(3),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: onPressed,
        child: Text(
          buttonText,
          style: labelStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  final String buttonText;
  final double width;
  final Function onPressed;
  final List<Color> colors;

  const UploadButton({
    required this.buttonText,
    required this.width,
    required this.onPressed,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(width: 1, color: AppColor.lightBlue),
          ),
          onPressed: () => onPressed(),
          child: Text(
            buttonText,
            style: const TextStyle(color: AppColor.lightBlue),
          ),
        ));
  }
}
