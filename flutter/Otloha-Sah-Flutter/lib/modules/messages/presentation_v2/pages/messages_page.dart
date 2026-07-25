import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/room/room.dart';

import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../settings/business_logic/themes/theme_cubit.dart';
import '../../business_logic_v2/cubit/rooms_cubit.dart';
import '../widgets/message_base.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final PagingController<int, Room> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    RoomsCubit.get(context).setPageController(pagingController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          translate('Messages'),
          style: TextStyle(
            color: ThemeCubit.isDark ? null : AppColor.headTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: AppColor.userNameColor,
          ),
        ),
      ),
      body: BlocBuilder<RoomsCubit, RoomsState>(
        buildWhen: (previous, current) {
          return current is RoomsFetechedDataState ||
              current is RoomsLoadingDataState ||
              current is RoomsErrorState;
        },
        builder: (context, state) {
          // if (state is RoomsFetechedDataState) {
          return PaginationData<Room>(
            getData: (nextLink) async {
              return await RoomsCubit.get(context).fetchNextPage(nextLink);
            },
            initData: const [],
            pagingController: pagingController,
            drowItem: (room, index) {
              return MessageBase(
                room: room,
              );
            },
          );
          // } else if (state is RoomsLoadingDataState) {
          //   return const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // } else if (state is RoomsErrorState) {
          //   return ErrorIndicator(error: state.exception);
          // } else {
          //   return Center(
          //     child: ErrorIndicator(error: EmptyListException()),
          //   );
          // }

          // return ListView(
          //   children: const [
          //     MessageViewWidget(
          //         isSeen: true, isReplayed: false, source: Source.incoming),
          //     MessageViewWidget(
          //         isSeen: true, isReplayed: true, source: Source.incoming),
          //     MessageViewWidget(
          //         isSeen: false, isReplayed: false, source: Source.incoming),
          //     MessageViewWidget(
          //         isSeen: false, isReplayed: true, source: Source.incoming),

          //     /// out
          //     MessageViewWidget(
          //       isSeen: true,
          //       isReplayed: false,
          //       source: Source.outgoing,
          //     ),
          //     MessageViewWidget(
          //         isSeen: true, isReplayed: true, source: Source.outgoing),
          //     MessageViewWidget(
          //         isSeen: false, isReplayed: false, source: Source.outgoing),
          //     MessageViewWidget(
          //         isSeen: false, isReplayed: true, source: Source.outgoing),

          //     //
          //     MessageViewWidget(
          //       isSeen: true,
          //       isReplayed: false,
          //       source: Source.outgoing,
          //       recitationType: RecitationType.mark,
          //     ),
          //     MessageViewWidget(
          //       isSeen: true,
          //       isReplayed: false,
          //       source: Source.outgoing,
          //       recitationType: RecitationType.reject,
          //     ),
          //     MessageViewWidget(
          //       isSeen: true,
          //       isReplayed: false,
          //       source: Source.outgoing,
          //       rate: 4.5,
          //       recitationType: RecitationType.mark,
          //     ),
          //     MessageViewWidget(
          //       isSeen: true,
          //       isReplayed: false,
          //       source: Source.outgoing,
          //       rate: 4.5,
          //       recitationType: RecitationType.reject,
          //     ),
          //   ],
          // );
        },
      ),
    );
  }
}

/*
return ListView(
      children: const [
        MessageViewWidget(
            isSeen: true, isReplayed: false, source: Source.incoming),
        MessageViewWidget(
            isSeen: true, isReplayed: true, source: Source.incoming),
        MessageViewWidget(
            isSeen: false, isReplayed: false, source: Source.incoming),
        MessageViewWidget(
            isSeen: false, isReplayed: true, source: Source.incoming),

        /// out
        MessageViewWidget(
          isSeen: true,
          isReplayed: false,
          source: Source.outgoing,
        ),
        MessageViewWidget(
            isSeen: true, isReplayed: true, source: Source.outgoing),
        MessageViewWidget(
            isSeen: false, isReplayed: false, source: Source.outgoing),
        MessageViewWidget(
            isSeen: false, isReplayed: true, source: Source.outgoing),

        //
        MessageViewWidget(
          isSeen: true,
          isReplayed: false,
          source: Source.outgoing,
          recitationType: RecitationType.mark,
        ),
        MessageViewWidget(
          isSeen: true,
          isReplayed: false,
          source: Source.outgoing,
          recitationType: RecitationType.reject,
        ),
        MessageViewWidget(
          isSeen: true,
          isReplayed: false,
          source: Source.outgoing,
          rate: 4.5,
          recitationType: RecitationType.mark,
        ),
        MessageViewWidget(
          isSeen: true,
          isReplayed: false,
          source: Source.outgoing,
          rate: 4.5,
          recitationType: RecitationType.reject,
        ),
      ],
    );
*/