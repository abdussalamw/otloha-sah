import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/modules/messages/business_logic_v2/cubit/genaralmessage_cubit.dart';
import 'package:otloha_sah_flutter/modules/messages/presentation_v2/widgets/general_message_item.dart';

class GeneralMessagePage extends StatefulWidget {
  const GeneralMessagePage({super.key});

  @override
  State<GeneralMessagePage> createState() => _GeneralMessagePageState();
}

class _GeneralMessagePageState extends State<GeneralMessagePage> {
  GenaralmessageCubit? cubit;
  final PagingController<int, Recitation> pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    cubit = GenaralmessageCubit.get(context);
    cubit?.getPagingController(pagingController);
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
                title: translate('صندوق الرسائل العام'),
              ),
              BlocBuilder<GenaralmessageCubit, GenaralmessageState>(
                builder: (context, state) {
                  return _showData(cubit);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showData(GenaralmessageCubit? cubit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PaginationData<Recitation>(
          getData: (nextLink) async {
            return await cubit!.fetchNextPage(nextLink);
          },
          drowItem: (results, index) {
            return _getItem(index, results);
          },
          initData: const [],
          pagingController: pagingController,
        ),
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
      userName: generalResponse.owner?.fullname ?? '',
      dateStr: (generalResponse.finishedAt != null)
          ? DateFormat('hh:mm dd MMM').format(DateTime.parse(generalResponse.finishedAt ?? ''))
          : null,
      color: Colors.transparent,
      onPress: () {},
      isLocal: false,
      isPlay: index == cubit?.indexPlay,
      toggelPlay: () {
        cubit?.setIndexPlay(index);
      },
      delete: () {
        cubit?.deleteMessage(index);
      },
    );
  }
}
