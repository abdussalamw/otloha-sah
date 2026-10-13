import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:otloha_sah_flutter/data_source/models/favorite_pages/favorite_pages.dart';

import '../../../../../core/design_system/components/cards/app_card.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_radius.dart';
import '../../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/exception_indicators/exception_indicator.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../home/presentation/pages/home/home_page.dart';
import '../../../../settings/presentation/widgets/search_bar_app.dart';
import '../../../../../data_source/cache_helper.dart';
import '../../../business_logic/cubit/getuserquranaction_cubit.dart';
import '../../../business_logic/cubit/quran_cubit.dart';

class PagesBookMarkPage extends StatelessWidget {
  const PagesBookMarkPage({
    Key? key,
  }) : super(key: key);

  static const routeName = '/quran/bookmark';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    BlocProvider.of<GetUserQuranActionCubit>(context).findAllPageMarkeds();

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _topView(context),
            _viewItems(),
          ],
        ),
      ),
    );
  }

  Widget _topView(BuildContext context) {
    return SearchBarApp(
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('BookMarks'),
    );
  }

  Expanded _viewItems() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: BlocBuilder<GetUserQuranActionCubit, GetUserQuranActionState>(
          builder: (context, state) {
            if (state is GetUserQuranActionMarks) {
              if (state.pages.isEmpty) {
                return Center(
                  child: ExceptionIndicator(
                    title: tr('No Data Found'),
                  ),
                );
              }
              return ListView.builder(
                itemCount: state.pages.length,
                itemBuilder: (context, index) {
                  return ItemBookMark(
                    index: index,
                    onPress: () {
                      final selectedPage = state.pages[index].pageNumber;
                      CacheHelper.saveData(key: 'hafs_initial_page', value: selectedPage);
                      try {
                        QuranViewCubit.get(context)
                            .controller
                            .changeInitPage(selectedPage);
                      } catch (_) {}

                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop(selectedPage);
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          HomePage.routeName,
                          ModalRoute.withName('/'),
                          arguments: 2,
                        );
                      }
                    },
                    pageMarked: state.pages[index],
                  );
                },
              );
            } else {
              return Center(
                child: ExceptionIndicator(
                  title: tr('No Data Found'),
                ),
              );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: onPress,
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.bookmark_rounded,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  pageMarked.textVerse,
                  style: AppTypography.bodyMedium(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ).copyWith(
                    fontFamily: 'Hafs20',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: AppRadius.radiusFull,
              ),
              child: Text(
                '${translate('Page')} ${pageMarked.pageNumber}',
                style: AppTypography.bodySmall(color: AppColors.primary).copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
