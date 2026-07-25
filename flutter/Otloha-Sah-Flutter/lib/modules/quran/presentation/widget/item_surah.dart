import 'package:flutter/material.dart';
import '../../../../core/utils/res/svg_app.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/utils/constant/utils.dart';

import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';

class ItemSurah extends StatelessWidget {
  const ItemSurah({
    Key? key,
    required this.name,
    required this.partName,
    required this.pageFrom,
    required this.pageTO,
    required this.verses,
    required this.onLongPress,
    this.action,
    this.isMakkah = true,
    this.isSelect = false,
  }) : super(key: key);

  final String name;
  final String partName;
  final int pageFrom;
  final int pageTO;
  final int verses;
  final bool isMakkah;
  final bool isSelect;
  final Function() onLongPress;
  final Function()? action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: action,
      child: Card(
        elevation: isSelect ? 5 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        shadowColor: isSelect
            ? AppColor.borderColor.withOpacity(.5)
            : AppColor.conColor2,
        margin: const EdgeInsets.all(4),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelect ? AppColor.borderColor : AppColor.conColor2,
              width: 1,
            ),
            color: ThemeCubit.isDark ? null : AppColor.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                AppSVG.chapter,
                width: 20,
                height: 20,
                color: AppColor.lightBlue,
              ),
              TextView(
                text: name,
                colorText:
                    ThemeCubit.isDark ? AppColor.lightBlue : AppColor.darkBlue,
                sizeText: 18,
                weightText: FontWeight.bold,
                fontFamily: 'Hafs17',
                padding: EdgeInsets.zero,
              ),
              TextView(
                text:
                    '${translate('Pages')} $pageFrom ${translate('to')} $pageTO',
                colorText: AppColor.txtColor4,
                sizeText: 8,
                padding: EdgeInsets.zero,
              ),
              TextView(
                text: '${translate('Verses')} $verses',
                colorText: AppColor.txtColor4,
                sizeText: 8,
                padding: EdgeInsets.zero,
              ),
              TextView(
                text: partName,
                colorText: AppColor.txtColor4,
                sizeText: 8,
                padding: EdgeInsets.zero,
              ),
              SvgPicture.asset(
                isMakkah ? AppSVG.makkah : AppSVG.madina,
                width: 14,
                height: 14,
                color: AppColor.lightBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
