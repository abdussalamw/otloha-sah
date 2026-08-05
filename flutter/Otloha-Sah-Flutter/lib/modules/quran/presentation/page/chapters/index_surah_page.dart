import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../../core/design_system/tokens/app_colors.dart';
import '../../../../../core/design_system/tokens/app_radius.dart';
import '../../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../../core/design_system/tokens/app_typography.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../home/presentation/widget/bottom_bar.dart';
import '../../../../home/presentation/widget/init_data.dart';
import '../../../../settings/business_logic/chapter/chapter_cubit.dart';
import '../../../../settings/business_logic/themes/theme_cubit.dart';
import '../../../../settings/presentation/widgets/search_bar_app.dart';
import '../../../../settings/presentation/widgets/view_error.dart';
import '../../../business_logic/cubit/quran_cubit.dart';
import '../../widget/item_surah.dart';

class IndexSurahPage extends StatefulWidget {
  const IndexSurahPage({super.key});
  static const routeName = '/quran/index';

  @override
  State<IndexSurahPage> createState() => _IndexSurahPageState();
}

class _IndexSurahPageState extends State<IndexSurahPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChapterCubit>(context).fetchChaptersList(
      isSelect: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Search Bar Top Header
            _topView(),

            // Chapters List Container
            Expanded(
              child: BlocBuilder<ChapterCubit, ChapterState>(
                builder: (context, state) {
                  if (state is ChapterFetched) {
                    return _viewItems(state.chapters);
                  } else if (state is ChapterInitial) {
                    return const LoadingWidget();
                  } else {
                    return const ViewError(error: '');
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BubbleBottomBarApp(
        onItemTapped: _changePage,
        selectedIndex: 2,
        items: HomeMenuItems().homeMenuItems,
      ),
    );
  }

  Widget _topView() {
    return SearchBarApp(
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('index'),
      onSearch: (val) {
        BlocProvider.of<ChapterCubit>(context)
            .fetchChaptersList(qurey: val, isSelect: true);
      },
    );
  }

  Widget _viewItems(List<Chapter>? chapters) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: chapters!.length,
      itemBuilder: (context, index) {
        return ItemSurah(
          name: chapters[index].name?.translate() ?? '',
          partName: '',
          pageFrom: chapters[index].pageFrom ?? 1,
          pageTO: chapters[index].pageTo ?? 1,
          verses: chapters[index].versesSize ?? 7,
          isMakkah: _getOrigin(chapters[index].origin),
          isSelect: QuranViewCubit.get(context).chapterId == chapters[index].id,
          onLongPress: () {},
          action: () async {
            QuranViewCubit.get(context)
                .controller
                .changeChapter(chapters[index]);
            _changePage(2);
          },
        );
      },
    );
  }

  _changePage(int? index) {
    Navigator.of(context).pop();
  }

  bool _getOrigin(String? origin) {
    return origin == 'makkiah';
  }
}
