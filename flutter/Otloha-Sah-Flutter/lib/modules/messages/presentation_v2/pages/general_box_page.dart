import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/exception_indicators/error_indicator.dart';
import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/tool_bar_app.dart';
import '../../../auth_module/presentation/pages/login_page.dart';
import '../../business_logic_v2/cubit/genaralmessage_cubit.dart';
import '../widgets/general_message_item.dart';

class GeneralMessagePage extends StatefulWidget {
  const GeneralMessagePage({super.key});

  @override
  State<GeneralMessagePage> createState() => _GeneralMessagePageState();
}

class _GeneralMessagePageState extends State<GeneralMessagePage> {
  late GenaralmessageCubit? cubit;
  final PagingController<int, Recitation> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    cubit = GenaralmessageCubit.get(context);
    cubit!.getPagingController(pagingController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ToolBarApp(
              backIcon: IconButton(
                icon: GestureDetector(
                  child: const Icon(Icons.arrow_back_ios),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: translate('General'),
            ),
            BlocBuilder<GenaralmessageCubit, GenaralmessageState>(
              builder: (context, state) {
                return _showData(cubit);
              },
            ),
          ],
        ),
      ),
    );
  }

  // child: ListView.builder(
  //   itemCount: cubit.generalResponses?.length ?? 0,
  //   itemBuilder: (context, index) {
  //     return _getItem(index, cubit.generalResponses![index]);
  //   },
  // )

  Widget _showData(GenaralmessageCubit? cubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PaginationData<Recitation>(
            getData: (nextLink) async {
              return await cubit!.fetchNextPage(nextLink);
            },
            drowItem: (results, index) {
              return _getItem(index, results);
            },
            initData: [],
            pagingController: pagingController),
      ),
    );
  }

  Widget _getItem(int index, Recitation generalResponse) {
    return GeneralMessageItem(
      recitation: generalResponse,
      isRead: false,
      owner: generalResponse.owner,
      id: generalResponse.id,
      ayah: generalResponse.name ?? '',
      userImage: generalResponse.owner?.profileImage ?? '',
      userName: generalResponse.owner!.fullname ?? '',
      dateStr: (generalResponse.finishedAt != null)
          ? DateFormat('hh:mm dd MMM')
              .format(DateTime.parse(generalResponse.finishedAt ?? ''))
          : null,
      color: AppColor.transparent,
      onPress: () {},
      isLocal: false,
      // recordPath: generalResponse.record?.record,
      isPlay: index == cubit?.indexPlay,
      toggelPlay: () {
        cubit?.setIndexPlay(index);
      },
      delete: () {
        cubit?.deleteMessage(index);
      },
      // typeUser: getUserType3(generalResponse.ownerData),
    );
  }
}

/*
   waveform: waveform,
      isLike: _liked.contains(index),
      liked: () {
        setState(() {
          _liked.add(index);
        });
      },
      goLike: () =>
          Navigator.of(context).pushNamed(LikedPage.routeName, arguments: 0),
      goNote: () =>
          Navigator.of(context).pushNamed(LikedPage.routeName, arguments: 1),
      goReMraker: () =>
          Navigator.of(context).pushNamed(LikedPage.routeName, arguments: 2),
      likeCount: (generalResponse.likes?.length ?? 0) +
          (_liked.contains(index) ? 1 : 0),
      toggelPlay: () {
        setState(() {
          _selectedPlay = index;
        });
      },
      viewBottom: true,
      isPlay: index == _selectedPlay, recordPath: '', wavePath: '',
      commentCount: generalResponse.comments?.length ?? 0,
      remarkableCount: generalResponse.remarkable?.length ?? 0, */
