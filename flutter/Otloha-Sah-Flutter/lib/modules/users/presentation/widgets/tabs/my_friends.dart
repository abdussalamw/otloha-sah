import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/my_friends_list_cubit/friends_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/my_friends_list_cubit/friends_list_state.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/cards/student_card.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/cards/teacher_card.dart';

class MyFriendsList extends StatefulWidget {
  const MyFriendsList({super.key, required this.pagingController});
  final PagingController<int, BaseUser> pagingController;

  @override
  State<MyFriendsList> createState() => _MyFriendsListState();
}

class _MyFriendsListState extends State<MyFriendsList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<FriendsListCubit, FriendsListState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PaginationData<BaseUser>(
            getData: (nextLink) async {
              return await BlocProvider.of<FriendsListCubit>(context)
                  .getNextPage(nextLink);
            },
            drowItem: (results, index) {
              if (!(results.isTeacher ?? true)) {
                return StudentCard(
                  student: results.toStudent().copyWith(
                        relationships:
                            results.relationships?.copyWith(friend: true),
                      ),
                );
              }
              return TeacherCard(
                teacher: results.toTeacher().copyWith(
                      relationships:
                          results.relationships?.copyWith(friend: true),
                    ),
              );
            },
            initData: const [],
            pagingController: widget.pagingController,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
