import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../utils/constant/constants.dart';
import '../utils/themes/text_style.dart';

class TextView extends StatelessWidget {
  const TextView({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.center,
    this.action,
    this.padding = const EdgeInsets.all(4),
    this.icon,
    this.colorText,
    this.sizeText,
    this.weightText,
    this.lineHeight,
    this.fontFamily = Constants.fontFamily1,
    this.overflow = TextOverflow.ellipsis,
    this.letterSpacing,
    this.maxLines,
  }) : super(key: key);

  final String text;
  final String fontFamily;
  final TextAlign textAlign;
  final Function()? action;
  final EdgeInsetsGeometry padding;
  final Icon? icon;
  final Color? colorText;
  final double? sizeText;
  final double? lineHeight;
  final FontWeight? weightText;
  final double? letterSpacing;

  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Padding(
        padding: padding,
        child: AutoSizeText(
          text,
          style: AppStyle().textStyle1.copyWith(
                fontSize: sizeText,
                color: colorText,
                fontWeight: weightText,
                wordSpacing: .5,
                fontFamily: fontFamily,
                letterSpacing: letterSpacing,
                height: lineHeight,
              ),
          textAlign: textAlign,
          minFontSize: sizeText ?? 12,
          maxLines: maxLines,
        ),
      ),
    );
  }
}

class TextViewIcon extends StatelessWidget {
  const TextViewIcon({
    Key? key,
    required this.text,
    this.action,
    this.textAlign,
    this.padding = const EdgeInsets.all(8),
    this.icon,
    this.colorText,
    this.sizeText,
    this.weightText,
    this.fontFamily = Constants.fontFamily1,
    this.letterSpacing,
  }) : super(key: key);

  final String text;
  final String fontFamily;
  final TextAlign? textAlign;
  final Function()? action;
  final EdgeInsetsGeometry padding;
  final Widget? icon;
  final Color? colorText;
  final double? sizeText;
  final FontWeight? weightText;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: (textAlign == TextAlign.center)
              ? MainAxisAlignment.center
              : (textAlign == TextAlign.start)
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: 8),
            AutoSizeText(
              text,
              style: AppStyle().textStyle1.copyWith(
                    fontSize: sizeText,
                    color: colorText,
                    fontWeight: weightText,
                    letterSpacing: letterSpacing,
                    fontFamily: fontFamily,
                  ),
              textAlign: textAlign,
            ),
          ],
        ),
      ),
    );
  }
}
