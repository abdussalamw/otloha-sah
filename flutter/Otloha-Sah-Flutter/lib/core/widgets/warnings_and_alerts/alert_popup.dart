import 'package:easy_localization/easy_localization.dart' as local;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import '../../utils/res/icons_app.dart';
import '../../utils/themes/color.dart';
import '../../../modules/auth_module/presentation/widget/auth_button.dart';

enum AlertType {
  seccess,
  danger,
  warning,
}

class AlertPopup extends StatefulWidget {
  const AlertPopup({
    super.key,
    required this.alertType,
    required this.message,
    this.title,
    this.buttonColor,
    this.actions,
    this.buttonText,
    this.onTap,
    this.hideBtn,
    this.autoDismissDuration,
  });
  final AlertType alertType;
  final String? title;
  final String message;
  final List<Widget>? actions;
  final Color? buttonColor;
  final String? buttonText;
  final Function()? onTap;
  final bool? hideBtn;
  final Duration? autoDismissDuration;

  @override
  State<AlertPopup> createState() => _AlertPopupState();
}

class _AlertPopupState extends State<AlertPopup> {
  @override
  void initState() {
    super.initState();
    if (widget.alertType == AlertType.seccess) {
      Future.delayed(widget.autoDismissDuration ?? const Duration(seconds: 4), () {
        if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
          if (widget.onTap != null) {
            widget.onTap!();
          } else {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }
      });
    }
  }

  String getIcon() {
    if (widget.alertType == AlertType.seccess) {
      return AppIcons.sucessIcon;
    } else if (widget.alertType == AlertType.warning) {
      return AppIcons.waningIcon;
    }
    return AppIcons.dangerIcon;
  }

  String getText() {
    if (widget.alertType == AlertType.seccess) {
      return translate('Done'.tr());
    } else if (widget.alertType == AlertType.warning) {
      return translate('ok');
    }
    return translate('cancel');
  }

  Color getColor() {
    if (widget.alertType == AlertType.seccess) {
      return AppColor.headTextColor;
    } else if (widget.alertType == AlertType.warning) {
      return AppColor.warningAlertColor;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(getIcon()),
            const SizedBox(height: 30),
            if (widget.alertType == AlertType.warning)
              Text(
                'Warning'.tr(),
                style: TextStyle(
                  color: getColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            if (widget.title != null)
              Text(
                widget.title!,
                style: TextStyle(
                  color: getColor(),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            Text(
              widget.message,
              style: const TextStyle(
                color: AppColor.txtGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: widget.actions == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if ((widget.alertType == AlertType.seccess ||
                        widget.alertType == AlertType.warning) &&
                    !(widget.hideBtn ?? true))
                  SizedBox(
                    height: 35,
                    child: ButtonApp(
                        buttonText: widget.buttonText ?? getText(),
                        onPressed: widget.onTap ??
                            () {
                              Navigator.pop(context);
                            },
                        width: 220 / ((widget.actions?.length ?? 0) + 1),
                        borderRaduis: BorderRadius.circular(10),
                        colors: widget.buttonColor == null
                            ? [
                                AppColor.darkBlue,
                                AppColor.lightBlue,
                              ]
                            : [
                                widget.buttonColor!,
                                widget.buttonColor!,
                              ]),
                  ),
                if (widget.actions != null)
                  for (Widget action in widget.actions!) ...[
                    SizedBox(
                      height: 35,
                      width: 220 / ((widget.actions?.length ?? 0) + 1),
                      child: action,
                    )
                  ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
