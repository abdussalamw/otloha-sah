import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation_recieved.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/invitation_recieved_list/invitation_recieved_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/invitation_card.dart';

class RecievedInvitationsListing extends StatefulWidget {
  const RecievedInvitationsListing({super.key, required this.pagingController});
  final PagingController<int, InvitationRecieved> pagingController;

  @override
  State<RecievedInvitationsListing> createState() =>
      _RecievedInvitationsListingState();
}

class _RecievedInvitationsListingState extends State<RecievedInvitationsListing>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PaginationData<InvitationRecieved>(
        getData: (nextLink) async {
          return await BlocProvider.of<InvitationRecievedCubit>(context)
              .getNextPage(nextLink);
        },
        drowItem: (results, index) {
          return InvitationCard(
            invitationReceived: results,
            pagingController: widget.pagingController,
          );
        },
        initData: const [],
        pagingController: widget.pagingController,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
