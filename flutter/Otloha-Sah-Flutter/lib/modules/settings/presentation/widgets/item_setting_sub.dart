import 'package:flutter/material.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';

import '../../../../data_source/models/setting_model/setting.dart';

class ItemSubSetting extends StatelessWidget {
  const ItemSubSetting({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(settings.actionTo ?? '');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Card(
            margin: EdgeInsets.zero,
            color: AppColor.gradient3,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                //  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    settings.image,
                    width: 32,
                    height: 32,
                    color: AppColor.txtColor3,
                  ),
                  const SizedBox(width: 8),
                  TextView(
                    text: settings.name,
                    colorText: AppColor.txtColor3,
                    sizeText: 16,
                    weightText: FontWeight.w900,
                    padding: const EdgeInsets.all(2),
                    textAlign: TextAlign.start,
                  ),
                  TextView(
                    text: settings.subTitle ?? '',
                    colorText: AppColor.txtColor4,
                    sizeText: 14,
                    padding: const EdgeInsets.all(2),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
