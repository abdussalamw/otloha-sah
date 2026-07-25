import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/exception_indicators/error_indicator.dart';
import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/widgets/tool_bar_app.dart';
import '../../../auth_module/presentation/pages/login_page.dart';
import '../../business_logic_v2/cubit/markable_recitations_cubit.dart';
import '../widgets/general_message_item.dart';

class MarkableRecitationsPage extends StatefulWidget {
  const MarkableRecitationsPage({Key? key, this.isTeacherData = false})
      : super(key: key);

  final bool isTeacherData;

  @override
  State<MarkableRecitationsPage> createState() =>
      _MarkableRecitationsPageState();
}

class _MarkableRecitationsPageState extends State<MarkableRecitationsPage> {
  late MarkableRecitationsCubit cubit;
  final PagingController<int, Recitation> pagingController =
      PagingController(firstPageKey: 1);
  @override
  void initState() {
    cubit = MarkableRecitationsCubit.get(context)
      ..setIsTeacher(widget.isTeacherData);
    cubit.getMarkableRecitations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topView(context, widget.isTeacherData),
            BlocBuilder<MarkableRecitationsCubit, MarkableRecitationsState>(
              builder: (context, state) {
                if (state is RecitationsLoadingState) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (state is NoAuthState) {
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginPage.routeName);
                  });
                }
                if (state is RecitationsErrorState) {
                  /// return const Expanded(child: ViewError(error: 'No Data'));
                  return Expanded(child: ErrorIndicator(error: state.error));
                }
                if (state is RecitationsSuccessState ||
                    state is RemoveUserRecitationState) {
                  return _showData(cubit);
                }
                return Expanded(
                    child: ErrorIndicator(error: SomeThingWentWrong()));
              },
            ),
          ],
        ),
      ),
    );
  }

  // child: ListView.builder(
  Widget _showData(MarkableRecitationsCubit cubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PaginationData<Recitation>(
            getData: (nextLink) async {
              return await cubit.fetchNextPage(nextLink);
            },
            drowItem: (results, index) {
              return _getItem(index, results, cubit);
            },
            initData: cubit.data!,
            pagingController: pagingController),
      ),
    );
  }

  Widget _getItem(
      int index, Recitation generalResponse, MarkableRecitationsCubit cubit) {
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
      onPress: () {
        // print('prcess ');
        //   Get.to(const MessageDetails());
      },
      // isCertic: generalResponse.ownerData?.isCertified ?? true,
      isLocal: false,
      // recordPath: generalResponse.record,
      isPlay: index == cubit.indexPlay,
      toggelPlay: () {
        cubit.setIndexPlay(index);
      },
      delete: () {
        cubit.deleteMessage(index);
      },
      // typeUser: getUserType3(generalResponse.ownerData),
    );
  }
}

Widget _topView(context, bool isTeacherData) {
  return ToolBarApp(
    backIcon: IconButton(
      icon: GestureDetector(
        child: const Icon(Icons.arrow_back_ios),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
    title: isTeacherData
        ? translate('TeachersRecitation')
        : translate('MarkableRecitations'),
  );
}
