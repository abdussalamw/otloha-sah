import 'package:flutter/material.dart';

import '../../../home/presentation/widget/home_sub_main_sction.dart';

import '../../../../data_source/models/setting_model/setting.dart';

import '../../../home/presentation/widget/sub_section_item.dart';

class ItemSetting extends StatelessWidget {
  const ItemSetting({Key? key, required this.settings, required this.change})
      : super(key: key);

  final Settings settings;
  final Function() change;

  @override
  Widget build(BuildContext context) {
    return HomeSubMainSection(
      item: SubSectionItem(
        title: settings.name,
        image: settings.image,
        action2: (context) {
          Navigator.of(context).pushNamed(settings.actionTo ?? '').then(
                (_) => change(),
              );
        },
        subTitle: settings.subTitle,
        isPng: true,
      ),
    );
  }
}
