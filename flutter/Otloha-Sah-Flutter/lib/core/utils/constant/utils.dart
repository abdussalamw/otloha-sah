import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../themes/color.dart';

String translate(key) => tr(key);
final dateformat = DateFormat('yyyy-MMM-dd');

OutlineInputBorder border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: const BorderSide(width: 2, color: AppColor.borderColor),
);

UnderlineInputBorder underLineBorder = UnderlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: const BorderSide(width: 2, color: AppColor.lightGrey),
);

OutlineInputBorder borderFocuse = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: const BorderSide(width: 2, color: AppColor.borderHoverColor),
);

LinearGradient toolBarGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    AppColor.toolBar1.withOpacity(.5),
    AppColor.toolBar2,
  ],
);
