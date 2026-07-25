import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/data_source/local/database/database/database.dart';
import '../../../../../core/exception_indicators/exception_indicator.dart';
import '../../widget/add_note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/utils/res/icons_app.dart';
import '../../../../settings/presentation/widgets/search_bar_app.dart';
import '../../../../settings/presentation/widgets/user_like.dart';
import '../../../business_logic/cubit/getuserquranaction_cubit.dart';

class NotesVersePage extends StatelessWidget {
  const NotesVersePage({
    Key? key,

    ///this.arg,
  }) : super(key: key);

  static const routeName = '/quran/note';

  //final int? arg;

  @override
  Widget build(BuildContext context) {
    var cubit = GetUserQuranActionCubit.get(context);

    BlocProvider.of<GetUserQuranActionCubit>(context).findAllVerseNotes();
    return Scaffold(
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
        icon: const Icon(Icons.arrow_back_ios),
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
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetUserQuranActionCubit, GetUserQuranActionState>(
          builder: (context, state) {
            if (state is GetUserQuranActionNotes || state is NoteSearchError) {
              return ListView.builder(
                itemCount: cubit.verseNote.length,
                itemBuilder: (context, index) {
                  VerseNote verse = cubit.verseNote[index];
                  return _itemBuild(
                    action: () {
                      Scaffold.of(context).showBottomSheet(
                        (context) {
                          return AddNoteWidget(
                            // verseNote: cubit.verseNote[index],
                            isEdit: true,
                            title: cubit.verseNote[index].noteText,
                          );
                        },
                        // backgroundColor: AppColor.transparent,
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
              return ListView.builder(
                itemCount: cubit.searchedList.length,
                itemBuilder: (context, index) {
                  VerseNote verse = cubit.searchedList[index];
                  return _itemBuild(
                    action: () {
                      Scaffold.of(context).showBottomSheet(
                        (context) {
                          return AddNoteWidget(
                            // verseNote: cubit.searchedList[index],
                            isEdit: true,
                            title: cubit.verseNote[index].noteText,
                          );
                        },
                        // backgroundColor: AppColor.transparent,
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

  Widget _itemBuild({
    required Function() action,
    required GetUserQuranActionCubit cubit,
    required VerseNote verseNote,
    required int index,
    required BuildContext context,
  }) {
    return UserLiked(
      id: verseNote.id,
      index: index,
      userName: verseNote.textFristVerse,
      userImage: AppIcons.quran2Icon,
      note: verseNote.noteText,
      action: action,
      onDismissed: (val) async {
        await cubit.deleteVerseNotes(verseNote.id);
        // await cubit.findAllVerseNo
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
    );
  }
}
