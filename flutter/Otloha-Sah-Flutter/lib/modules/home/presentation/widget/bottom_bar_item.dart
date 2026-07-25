import 'package:flutter/widgets.dart';

class BottomBarData {
  String title;
  String iconData;
  String activeIconData;
  bool isBadge;
  int badge;
  Color badgeColor;
  Widget page;
  bool isSVG;
  BottomBarData({
    required this.title,
    required this.iconData,
    required this.badgeColor,
    required this.page,
    this.isBadge = false,
    this.isSVG = false,
    this.badge = 0,
    required this.activeIconData,
  });
}
