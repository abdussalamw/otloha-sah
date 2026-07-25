import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/auth_navigator.dart';
import '../../../../core/widgets/text_view.dart';
import 'sub_section_item.dart';

class HomeSubMainSection extends StatelessWidget {
  const HomeSubMainSection({Key? key, required this.item}) : super(key: key);

  final SubSectionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (item.action2 != null) {
          item.action2!(context);
        } else {
          AuthNavigator.of(context)!
              .pushConditionally(context, item.action!)
              .then((value) {});
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * .12,
        width: MediaQuery.of(context).size.height * .125,
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.gradient4, AppColor.gradient4],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            !item.isPng
                ? SvgPicture.asset(
                    item.image,
                    width: 32,
                    height: 32,
                    color: AppColor.gradient2,
                  )
                : Image.asset(
                    item.image,
                    width: 32,
                    height: 32,
                    color: AppColor.gradient2.withOpacity(.8),
                  ),
            TextView(
              text: item.title,
              colorText: AppColor.txtColor3,
              sizeText: 12,
              weightText: FontWeight.w700,
              padding: const EdgeInsets.all(0),
              textAlign: TextAlign.center,
            ),
            if (item.subTitle != null && item.subTitle!.isNotEmpty)
              SizedBox(
                height: 20,
                child: TextView(
                  text: item.subTitle ?? '',
                  colorText: AppColor.txtColor4,
                  sizeText: 12,
                  padding: const EdgeInsets.all(0),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
