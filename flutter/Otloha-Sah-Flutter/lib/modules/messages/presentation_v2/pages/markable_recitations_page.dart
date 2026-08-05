import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
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
import 'package:otloha_sah_flutter/modules/messages/business_logic_v2/cubit/markable_recitations_cubit.dart';
import 'package:otloha_sah_flutter/modules/messages/presentation_v2/widgets/general_message_item.dart';

class MarkableRecitationsPage extends StatefulWidget {
  const MarkableRecitationsPage({Key? key, this.isTeacherData = false})
      : super(key: key);

  final bool isTeacherData;

  @override
  State<MarkableRecitationsPage> createState() => _MarkableRecitationsPageState();
}

class _MarkableRecitationsPageState extends State<MarkableRecitationsPage> {
  late MarkableRecitationsCubit cubit;
  final PagingController<int, Recitation> pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    cubit = MarkableRecitationsCubit.get(context)..setIsTeacher(widget.isTeacherData);
    cubit.getMarkableRecitations();
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
              _topView(context, widget.isTeacherData),
              BlocBuilder<MarkableRecitationsCubit, MarkableRecitationsState>(
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

  Widget _showData(MarkableRecitationsCubit cubit) {
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

  Widget _getItem(int index, Recitation generalResponse, MarkableRecitationsCubit cubit) {
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
}

Widget _topView(BuildContext context, bool isTeacherData) {
  return ToolBarApp(
    backIcon: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
    ),
    title: isTeacherData ? translate('تلاوات المعلمين') : translate('التلاوات القابلة للتقييم'),
  );
}
