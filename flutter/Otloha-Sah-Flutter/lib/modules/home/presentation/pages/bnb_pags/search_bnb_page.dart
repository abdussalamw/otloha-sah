import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../business_logic/cubit/home_cubit.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class SearchBNBPage extends StatefulWidget {
  const SearchBNBPage({Key? key}) : super(key: key);

  @override
  State<SearchBNBPage> createState() => _SearchBNBPageState();
}

class _SearchBNBPageState extends State<SearchBNBPage> {
  @override
  Widget build(BuildContext context) {
    return SearchQuran(
      onTapVerse: () {
        HomeCubit.get(context).changeIndex(1);
      },
      onTapChapter: () {
        HomeCubit.get(context).changeIndex(1);
      },
      locale: Get.locale!.languageCode,
    );
  }
}
