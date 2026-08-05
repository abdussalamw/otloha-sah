import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:otloha_sah_flutter/data_source/local/database/database/database.dart';

import '../../../../../core/design_system/components/cards/app_card.dart';
import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_radius.dart';
import '../../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/exception_indicators/exception_indicator.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../settings/presentation/widgets/search_bar_app.dart';
import '../../../business_logic/cubit/getuserquranaction_cubit.dart';
import '../../widget/add_note.dart';

class NotesVersePage extends StatelessWidget {
  const NotesVersePage({
    Key? key,
  }) : super(key: key);

  static const routeName = '/quran/note';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    var cubit = GetUserQuranActionCubit.get(context);

    BlocProvider.of<GetUserQuranActionCubit>(context).findAllVerseNotes();
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [_topView(context, cubit), _viewItems(cubit)],
        ),
      ),
    );
  }

  Widget _topView(BuildContext context, GetUserQuranActionCubit cubit) {
    return SearchBarApp(
      onSearch: (value) {
        cubit.search(value);
      },
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('Note'),
    );
  }

  Expanded _viewItems(GetUserQuranActionCubit cubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: BlocBuilder<GetUserQuranActionCubit, GetUserQuranActionState>(
          builder: (context, state) {
            if (state is GetUserQuranActionNotes || state is NoteSearchError) {
              if (cubit.verseNote.isEmpty) {
                return Center(child: ExceptionIndicator(title: tr('No Data Found')));
              }
              return ListView.builder(
                itemCount: cubit.verseNote.length,
                itemBuilder: (context, index) {
                  VerseNote verse = cubit.verseNote[index];
                  return _itemBuild(
                    action: () {
                      Scaffold.of(context).showBottomSheet(
                        (context) {
                          return AddNoteWidget(
                            isEdit: true,
                            title: cubit.verseNote[index].noteText,
                          );
                        },
                      );
                    },
                    cubit: BlocProvider.of<GetUserQuranActionCubit>(context),
                    verseNote: verse,
                    context: context,
                    index: index,
                  );
                },
              );
            }
            if (state is NoteSearched) {
              if (cubit.searchedList.isEmpty) {
                return Center(child: ExceptionIndicator(title: tr('No Data Found')));
              }
              return ListView.builder(
                itemCount: cubit.searchedList.length,
                itemBuilder: (context, index) {
                  VerseNote verse = cubit.searchedList[index];
                  return _itemBuild(
                    action: () {
                      Scaffold.of(context).showBottomSheet(
                        (context) {
                          return AddNoteWidget(
                            isEdit: true,
                            title: cubit.verseNote[index].noteText,
                          );
                        },
                      );
                    },
                    cubit: BlocProvider.of<GetUserQuranActionCubit>(context),
                    verseNote: verse,
                    context: context,
                    index: index,
                  );
                },
              );
            }
            if (state is NoteSearchLoading) {
              return const Center(child: CircularProgressIndicator());
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

  Widget _itemBuild({
    required Function() action,
    required GetUserQuranActionCubit cubit,
    required VerseNote verseNote,
    required int index,
    required BuildContext context,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      onTap: action,
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (val) async {
          await cubit.deleteVerseNotes(verseNote.id);
          Get.snackbar(
            translate('DeletedDone'),
            translate('YouUndoDeleted'),
            mainButton: TextButton(
              onPressed: () async {
                await cubit.undoDeleteNote(verseNote);
                cubit.findAllVerseNotes();
              },
              child: Text(translate('Undo')),
            ),
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs + 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: AppRadius.radiusSm,
              ),
              child: const Icon(Icons.note_alt_rounded, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    verseNote.textFristVerse ?? '',
                    style: AppTypography.bodyMedium(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ).copyWith(
                      fontFamily: 'Hafs20',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (verseNote.noteText != null && verseNote.noteText!.isNotEmpty)
                    Text(
                      verseNote.noteText!,
                      style: AppTypography.bodySmall(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
