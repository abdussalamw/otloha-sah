import 'package:flutter/material.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/utils/res/svg_app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../../../../settings/business_logic/themes/theme_cubit.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

import '../../../../../core/utils/themes/color.dart';
import '../../../../../core/widgets/loading.dart';
import '../../../../../core/widgets/text_view.dart';
import '../../../../home/presentation/widget/bottom_bar.dart';
import '../../../../home/presentation/widget/init_data.dart';
import '../../../business_logic/cubit/quran_cubit.dart';
import '../../widget/item_surah.dart';
import '../../../../settings/business_logic/chapter/chapter_cubit.dart';
import '../../../../settings/presentation/widgets/search_bar_app.dart';
import '../../../../settings/presentation/widgets/view_error.dart';

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
    return Scaffold(
      backgroundColor: ThemeCubit.isDark ? null : AppColor.white,
      body: SafeArea(
          child: Stack(
        children: [
          BlocBuilder<ChapterCubit, ChapterState>(
            builder: (context, state) {
              if (state is ChapterFetched) {
                return _pageView(state.chapters);
              } else if (state is ChapterInitial) {
                return const LoadingWidget();
              } else {
                return const ViewError(error: '');
              }
            },
          ),
          _viewTop(context),
        ],
      )),
      bottomNavigationBar: BubbleBottomBarApp(
        onItemTapped: _changePage,
        selectedIndex: 1,
        items: HomeMenuItems().homeMenuItems,
        backColor: AppColor.darkBlue,
      ),
    );
  }

  Widget _viewTop(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Hero(
        tag: 'ToChooseSurah',
        child: GestureDetector(
          onTap: () => _changePage(1),
          child: Container(
            padding: const EdgeInsets.all(4),
            //margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const [
                  Color(0xFF08226C),
                  Color(0xFF2566B0),
                  Color(0xFF3A7BD5),
                  Color(0xFF00D2FF),
                ],
              ),
              image: const DecorationImage(
                image: Svg(
                  AppSVG.back2,
                  color: AppColor.white,
                ),
                fit: BoxFit.cover,
                opacity: .08,
                repeat: ImageRepeat.noRepeat,
                scale: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextView(
                  text: QuranViewCubit.get(context).chapterName,
                  textAlign: TextAlign.center,
                  colorText: AppColor.txtColor2,
                  sizeText: 16,
                  fontFamily: 'Hafs20',
                ),
                const Icon(
                  Icons.expand_less,
                  color: AppColor.txtColor2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column _pageView(List<Chapter>? chapters) {
    return Column(
      children: [
        _topView(),
        _viewItems(chapters),
      ],
    );
  }

  Widget _topView() {
    return SearchBarApp(
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
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
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: AppColor.background,
      ),
      height: MediaQuery.of(context).size.height * 0.75,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: chapters!.length,
        itemBuilder: (context, index) {
          return ItemSurah(
            name: chapters[index].name?.translate() ?? '',
            partName: '',
            pageFrom: chapters[index].pageFrom ?? 1,
            pageTO: chapters[index].pageTo ?? 1,
            verses: chapters[index].versesSize ?? 7,
            isMakkah: _getOorigin(chapters[index].origin),
            isSelect:
                QuranViewCubit.get(context).chapterId == chapters[index].id,
            onLongPress: () {},
            action: () async {
              QuranViewCubit.get(context)
                  .controller
                  .changeChapter(chapters[index]);
              _changePage(1);
            },
          );
        },
      ),
    );
  }

  _changePage(int? index) {
    Navigator.of(context).pop();
  }

  _getOorigin(String? origin) {
    if (origin == 'makkiah') {
      return true;
    }
    return false;
  }
}
