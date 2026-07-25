import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/local/database/database/database.dart';
import '../../../../../core/exception_indicators/exception_indicator.dart';

import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/utils/res/icons_app.dart';
import '../../../../home/presentation/pages/home/home_page.dart';
import '../../../business_logic/cubit/getuserquranaction_cubit.dart';
import '../../../business_logic/cubit/quran_cubit.dart';
import '../../../../settings/presentation/widgets/search_bar_app.dart';
import '../../../../settings/presentation/widgets/user_like.dart';

class LikedVersesPage extends StatelessWidget {
  const LikedVersesPage({
    Key? key,
  }) : super(key: key);

  static const routeName = '/quran/liked';

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GetUserQuranActionCubit>(context).findAllVerseLikeds();
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
      title: translate('Likes'),
    );
  }

  Expanded _viewItems() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetUserQuranActionCubit, GetUserQuranActionState>(
          builder: (context, state) {
            if (state is GetUserQuranActionLikeds) {
              List<FavoriteVerse> verses = Set.of(state.verses).toList();
              return ListView.builder(
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  return _itemBuild(() {
                    QuranViewCubit.get(context)
                        .controller
                        .changeInitPage(verses[index].pageNumber);

                    Navigator.of(context).pushNamedAndRemoveUntil(
                      HomePage.routeName,
                      ModalRoute.withName('/'),
                      arguments: 1,
                    );
                  }, index, context, verses[index]);
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

  Widget _itemBuild(
      Function() action, index, context, FavoriteVerse verseLiked) {
    var cubit = GetUserQuranActionCubit.get(context);
    return UserLiked(
      id: verseLiked.id,
      index: index,
      userName: verseLiked.textFristVerse,
      userImage: AppIcons.quran2Icon,
      note: null,
      isTextHafs: true,
      action: action,
      onDismissed: (value) {
        cubit.deleteVerseLiked(verseLiked.id);

        Get.snackbar(
          translate('DeletedDone'),
          translate('YouUndoDeleted'),
          mainButton: TextButton(
            onPressed: () {
              cubit.undoDeleteVerseLiked(verseLiked);
              cubit.findAllVerseLikeds();
            },
            child: Text(translate('Undo')),
          ),
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
