import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/models/favorite_pages/favorite_pages.dart';
import '../../../../../core/exception_indicators/exception_indicator.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../business_logic/cubit/quran_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/utils/res/icons_app.dart';
import '../../../../../core/widgets/text_view.dart';
import '../../../../home/presentation/pages/home/home_page.dart';
import '../../../../settings/presentation/widgets/search_bar_app.dart';
import '../../../business_logic/cubit/getuserquranaction_cubit.dart';

class PagesBookMarkPage extends StatelessWidget {
  const PagesBookMarkPage({
    Key? key,
  }) : super(key: key);

  static const routeName = '/quran/bookmark';

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GetUserQuranActionCubit>(context).findAllPageMarkeds();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [_topView(context), _viewItems()],
        ),
      ),
    );
  }

  Widget _topView(BuildContext context) {
    return SearchBarApp(
        backIcon: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: translate('BookMarks'));
  }

  Expanded _viewItems() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetUserQuranActionCubit, GetUserQuranActionState>(
          builder: (context, state) {
            if (state is GetUserQuranActionMarks) {
              return ListView.builder(
                itemCount: state.pages.length,
                itemBuilder: (context, index) {
                  return ItemBookMark(
                    index: index,
                    onPress: () {
                      QuranViewCubit.get(context)
                          .controller
                          .changeInitPage(state.pages[index].pageNumber!);

                      Navigator.of(context).pushNamedAndRemoveUntil(
                        HomePage.routeName,
                        ModalRoute.withName('/'),
                        arguments: 1,
                      );
                    },
                    pageMarked: state.pages[index],
                  );
                },
              );
            } else {
              return Center(
                  child: ExceptionIndicator(
                // onTryAgain: onTryAgain,
                //assetName: AppIcons.emptyIcon,
                title: tr('No Data Found'),
              ));
            }
          },
        ),
      ),
    );
  }
}

class ItemBookMark extends StatelessWidget {
  const ItemBookMark({
    Key? key,
    required this.pageMarked,
    required this.onPress,
    this.action,
    required this.index,
    this.isSelect = false,
  }) : super(key: key);

  final int index;
  final bool isSelect;
  final FavoritePage pageMarked;
  final Function() onPress;
  final Function()? action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (value) async {
          var cubit = GetUserQuranActionCubit.get(context);

          await cubit.deleteVerseBookMark(pageMarked.id);

          Get.snackbar(
            translate('DeletedDone'),
            translate('YouUndoDeleted'),
            mainButton: TextButton(
              onPressed: () {
                cubit.undoDeleteMark(pageMarked);
                cubit.findAllPageMarkeds();
              },
              child: Text(translate('Undo')),
            ),
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // border: Border.all(
            //   color: isSelect ? AppColor.borderColor : AppColor.conColor2,
            //   width: 1,
            // ),
            color: AppColor.conColor2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    AppIcons.quran3Icon,
                    width: 32,
                    height: 32,
                  ),
                  TextView(
                    text: pageMarked.textVerse,
                    colorText: AppColor.txtColor3,
                    sizeText: 16,
                    weightText: FontWeight.bold,
                    fontFamily: 'Hafs20',
                  ),
                ],
              ),
              const Spacer(),
              TextView(
                text: '${translate('Page')} ${pageMarked.pageNumber} ',
                colorText: AppColor.txtColor4,
                sizeText: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
