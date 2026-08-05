import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/error/exceptions.dart';
import 'package:otloha_sah_flutter/core/exception_indicators/error_indicator.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/modules/auth_module/presentation/pages/onboard_page.dart';
import 'package:otloha_sah_flutter/modules/messages/business_logic_v2/cubit/corrected_recitations_cubit.dart';
import 'package:otloha_sah_flutter/modules/messages/presentation_v2/widgets/general_message_item.dart';

class CorrectedRecitationsPage extends StatefulWidget {
  const CorrectedRecitationsPage({super.key});

  @override
  State<CorrectedRecitationsPage> createState() => _CorrectedRecitationsPageState();
}

class _CorrectedRecitationsPageState extends State<CorrectedRecitationsPage> {
  PagingController pagingController = PagingController<int, Recitation>(firstPageKey: 1);
  late CorrectedRecitationsCubit cubit;

  @override
  void initState() {
    cubit = CorrectedRecitationsCubit.get(context)..getCorrectedRecitations();
    cubit.getPagingController(pagingController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              ToolBarApp(
                backIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                title: translate('التلاوات المصححة'),
              ),
              BlocBuilder<CorrectedRecitationsCubit, CorrectedRecitationsState>(
                builder: (context, state) {
                  if (state is RecitationsLoadingState) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state is NoAuthState) {
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Navigator.of(context).pushReplacementNamed(OnBoardPage.routeName);
                    });
                  }
                  if (state is RecitationsErrorState) {
                    return Expanded(child: ErrorIndicator(error: state.error));
                  }
                  if (state is RecitationsSuccessState || state is RemoveUserRecitationState) {
                    return _showData(cubit);
                  }
                  return Expanded(child: ErrorIndicator(error: SomeThingWentWrong()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showData(CorrectedRecitationsCubit cubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PaginationData<Recitation>(
          getData: (nextLink) async {
            return await cubit.fetchNextPage(nextLink);
          },
          drowItem: (results, index) {
            return _getItem(index, results, cubit);
          },
          initData: cubit.data ?? [],
          pagingController: pagingController,
        ),
      ),
    );
  }
}

Widget _getItem(int index, Recitation generalResponse, CorrectedRecitationsCubit cubit) {
  return GeneralMessageItem(
    recitation: generalResponse,
    isRead: false,
    owner: generalResponse.owner,
    id: generalResponse.id,
    ayah: generalResponse.name ?? '',
    userImage: generalResponse.owner?.profileImage ?? '',
    userName: generalResponse.owner?.fullname ?? '',
    dateStr: (generalResponse.finishedAt != null)
        ? DateFormat('hh:mm dd MMM').format(DateTime.parse(generalResponse.finishedAt ?? ''))
        : null,
    color: Colors.transparent,
    onPress: () {},
    isLocal: false,
    isPlay: index == cubit.indexPlay,
    toggelPlay: () {
      cubit.setIndexPlay(index);
    },
    delete: () {
      cubit.deleteMessage(index);
    },
  );
}
