// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
// import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
// import 'package:otloha_sah_flutter/modules/users/cubit/list_state.dart';
// import 'package:otloha_sah_flutter/modules/users/presentation/widgets/users_list.dart';

// class UsersCubit extends Cubit<UsersState> {
//   final ListType listType;
//   final PagingController<int, BaseUser> pagingController;
//   UsersCubit({
//     required this.listType,
//     required this.pagingController,
//   }) : super(UsersLoading());

//   getNextPage(int nextLink) async {
//     Response? response;
//     String link = '';
//     if (listType == ListType.myStudents) {
//       link = '/api/v2/my-profiles/students/my_students';
//     } else if (listType == ListType.friends) {
//       link = '/api/v2/my-profiles/friends/';
//     } else {
//       link = '/api/v2/users-profiles/${listType.toString()}/';
//     }

//     response = await ApiBaseHelper().getHTTP(
//       link,
//       queryParameters: {'page': nextLink},
//       dioTypes: DioTypes.authRequired,
//     );
//     return response;
//   }

//   removeItemFromList(int userId) {
//     pagingController.itemList = pagingController.itemList!
//         .where((element) => element.id != userId)
//         .toList();
//   }
// }
