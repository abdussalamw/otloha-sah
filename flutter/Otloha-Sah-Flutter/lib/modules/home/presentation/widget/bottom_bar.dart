import 'package:flutter/material.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../../../lib_edit/bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../../../../core/utils/themes/color.dart';
import 'bottom_bar_item.dart';

///////////commit proplem
class BubbleBottomBarApp extends StatelessWidget {
  final Function(int? val) onItemTapped;
  final int selectedIndex;
  final Color? backColor;
  final List<BottomBarData> items;

  const BubbleBottomBarApp({
    super.key,
    required this.onItemTapped,
    required this.selectedIndex,
    required this.items,
    this.backColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.background,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BubbleBottomBar(
          opacity: .2,
          currentIndex: selectedIndex,
          backgroundColor: AppColor.background,
          onTap: onItemTapped,
          elevation: 0,
          hasNotch: true,
          hasInk: true,
          inkColor: AppColor.bottomBar,
          items: <BubbleBottomBarItem>[
            ...items.map((e) => _getItem(e)).toList()
          ],
        ),
      ),
    );
  }

  BubbleBottomBarItem _getItem(BottomBarData e) {
    return BubbleBottomBarItem(
      showBadge: e.isBadge,
      badge: e.isBadge
          ? Text(
              '${e.badge}',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            )
          : Container(),
      badgeColor: Colors.grey.shade600,
      backgroundColor: AppColor.bottom2Bar,
      icon: Image(
        image: getIcon(e.iconData, e.isSVG),
        width: e.iconData == AppSVG.quranBNB ? 30 : 22,
        height: e.iconData == AppSVG.quranBNB ? 30 : 22,
        color: AppColor.borderIconColor,
      ),
      activeIcon: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const RadialGradient(
            center: Alignment.bottomCenter,
            radius: 1.0,
            colors: [AppColor.gradient1, AppColor.gradient2],
            tileMode: TileMode.mirror,
          ).createShader(bounds);
        },
        child: Image(
          image: getIcon(e.activeIconData, e.isSVG),
          width: 26,
          height: 26,
          color: AppColor.white,
        ),
      ),
      title: Text(
        e.title,
        style: TextStyle(color: e.badgeColor),
      ),
    );
  }

  ImageProvider<Object> getIcon(String iconData, bool isSVG) {
    if (isSVG && iconData.contains('svg')) {
      return Svg(iconData);
    } else {
      return AssetImage(iconData);
    }
  }
}
