import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/exception_indicators/error_indicator.dart';
import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/tool_bar_app.dart';

import '../../../auth_module/presentation/pages/login_page.dart';
import '../../business_logic_v2/cubit/corrected_recitations_cubit.dart';
import '../widgets/general_message_item.dart';

class CorrectedRecitationsPage extends StatefulWidget {
  const CorrectedRecitationsPage({super.key});

  @override
  State<CorrectedRecitationsPage> createState() =>
      _CorrectedRecitationsPageState();
}

class _CorrectedRecitationsPageState extends State<CorrectedRecitationsPage> {
  PagingController pagingController =
      PagingController<int, Recitation>(firstPageKey: 1);
  late CorrectedRecitationsCubit cubit;

  @override
  void initState() {
    cubit = CorrectedRecitationsCubit.get(context)..getCorrectedRecitations();
    cubit.getPagingController(pagingController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topView(context),
            BlocBuilder<CorrectedRecitationsCubit, CorrectedRecitationsState>(
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

  Widget _topView(context) {
    return ToolBarApp(
      backIcon: IconButton(
        icon: GestureDetector(
          child: const Icon(Icons.arrow_back_ios),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('CorrectedRecitations'),
    );
  }

  Widget _showData(CorrectedRecitationsCubit cubit) {
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
}

Widget _getItem(
    int index, Recitation generalResponse, CorrectedRecitationsCubit cubit) {
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
    // recordPath: generalResponse.record?.record ?? '',
    isPlay: index == cubit.indexPlay,
    toggelPlay: () {
      cubit.setIndexPlay(index);
    },
    delete: () {
      cubit.deleteMessage(index);
    },
  );
}
