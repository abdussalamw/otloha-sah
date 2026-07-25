import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/block.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/blocked_user_card.dart';

class BlockedUsersListing extends StatelessWidget {
  const BlockedUsersListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('Blocked users')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: PaginationData<BlockedUser>(
          initData: const [],
          getData: (page) {
            return ApiBaseHelper().getHTTP(
              '/api/v1/invitations/block/',
              queryParameters: {'page': page},
              dioTypes: DioTypes.authRequired,
            );
          },
          drowItem: (results, idx) => BlockCard(blockedUser: results),
          pagingController: PagingController<int, BlockedUser>(firstPageKey: 1),
        ),
      ),
    );
  }
}
