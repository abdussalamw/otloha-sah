import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/modules/notifications/business_logic/base_notification.dart';

import '../../../../core/exception_indicators/error_indicator.dart';
import '../../../../core/exception_indicators/something_went_wrong.dart';
import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../core/widgets/user_avatar_widget.dart';
import '../../../../data_source/models/notifications_model/notifications_model.dart';
import '../../../../data_source/remote/notification_service.dart';
import '../../../home/business_logic/cubit/home_cubit.dart';
import '../../../notifications/presentation/widgets/notification_content.dart';
import '../../../settings/presentation/widgets/search_bar_app.dart';
import '../../business_logic/cubit/notifications_cubit.dart';
import '../../business_logic/cubit/notifications_state.dart';

class NotifiactionsPage extends StatefulWidget {
  const NotifiactionsPage({super.key});

  @override
  State<NotifiactionsPage> createState() => _NotifiactionsPageState();
}

class _NotifiactionsPageState extends State<NotifiactionsPage> {
  PagingController pagingController =
      PagingController<int, NotificationsModel>(firstPageKey: 1);

  @override
  void initState() {
    // NotificationsCubit.get(context).getNotifications(1);
    HomeCubit.get(context).getUnseenCount();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topView(context),
            _viewItems(),
          ],
        ),
      ),
    );
  }

  Expanded _viewItems() {
    return Expanded(
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PaginationData<NotificationsModel>(
              initData: const [],
              pagingController: pagingController,
              getData: NotificationsService().notificationsListing,
              drowItem: (notification, index) =>
                  _itemView(notification, context, index),
            ),
          );
        },
      ),
    );
  }

  Widget _itemView(
      NotificationsModel notification, BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor:
            notification.isRead ? AppColor.transparent : AppColor.messageColorB,
        minVerticalPadding: 0,
        onTap: () async {
          NotificationsCubit.get(context).markAsRead(notification, index);
          final cls = await BaseNotification.getCls(
              pushNotificationMap: notification.toPushNotificationMap());

          cls.pushRoute();
          // if (DefaultNotification(notificationsModel: notification).routeName !=
          //     null) {
          //   Navigator.pushNamed(
          //       context,
          //       DefaultNotification(notificationsModel: notification)
          //           .routeName!);
          // }
        },
        leading: UserAvatarWidget(
          imageUrl: notification.user?.profileImage,
          radius: 22,
        ),
        title: NotificationContent(text: notification.text),
        subtitle: Text(
          notification.createdAt,
        ),
      ),
    );
  }

// BoxMessageItem(
  Widget _topView(BuildContext context) {
    return SearchBarApp(
      backIcon: IconButton(
        color: AppColor.white,
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('Notifiactions'),
    );
  }
}
