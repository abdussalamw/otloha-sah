// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
// import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
// import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
// import 'package:otloha_sah_flutter/modules/users/cubit/list_cubit.dart';
// import 'package:otloha_sah_flutter/modules/users/cubit/list_state.dart';
// import 'package:otloha_sah_flutter/modules/users/presentation/widgets/user_card.dart';

// enum ListType {
//   friends,
//   students,
//   teachers,
//   myStudents,
//   entities;

//   @override
//   String toString() {
//     if (this == ListType.friends) {
//       return 'friends';
//     } else if (this == ListType.students) {
//       return 'students';
//     } else if (this == ListType.teachers) {
//       return 'teachers';
//     } else if (this == ListType.entities) {
//       return 'entities';
//     }
//     return 'my-students';
//   }
// }

// class UsersList extends StatefulWidget {
//   const UsersList({super.key, required this.type});

//   final ListType type;

//   @override
//   State<UsersList> createState() => _UsersListState();
// }

// class _UsersListState extends State<UsersList>
//     with AutomaticKeepAliveClientMixin {
//   final PagingController<int, BaseUser> pagingController =
//       PagingController<int, BaseUser>(firstPageKey: 1);

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return BlocProvider(
//       create: (context) => UsersCubit(
//         listType: widget.type,
//         pagingController: pagingController,
//       ),
//       child: BlocBuilder<UsersCubit, UsersState>(
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: PaginationData<BaseUser>(
//               getData: (nextLink) async {
//                 return await BlocProvider.of<UsersCubit>(context)
//                     .getNextPage(nextLink);
//               },
//               drowItem: (results, index) {
//                 return UserCard(user: results);
//               },
//               initData: const [],
//               pagingController: pagingController,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
