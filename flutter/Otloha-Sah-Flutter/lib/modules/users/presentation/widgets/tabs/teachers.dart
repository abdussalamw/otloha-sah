import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/teachers_list_cubit/teachers_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/cards/teacher_card.dart';

class TeachersList extends StatefulWidget {
  const TeachersList({
    super.key,
    required this.pagingController,
  });

  final PagingController<int, Teacher> pagingController;

  @override
  State<TeachersList> createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TeachersListCubit, TeachersListState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PaginationData<Teacher>(
            getData: (nextLink) async {
              return await BlocProvider.of<TeachersListCubit>(context)
                  .getNextPage(nextLink);
            },
            drowItem: (results, index) {
              return TeacherCard(teacher: results);
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
