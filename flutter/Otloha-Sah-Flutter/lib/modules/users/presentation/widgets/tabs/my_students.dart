import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/my_students_cubit/my_students_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/cards/student_card.dart';

class MyStudentsList extends StatefulWidget {
  const MyStudentsList({super.key, required this.pagingController});
  final PagingController<int, Student> pagingController;

  @override
  State<MyStudentsList> createState() => _MyStudentsListState();
}

class _MyStudentsListState extends State<MyStudentsList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<MyStudentsCubit, MyStudentsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PaginationData<Student>(
            getData: (nextLink) async {
              return await BlocProvider.of<MyStudentsCubit>(context)
                  .getNextPage(nextLink);
            },
            drowItem: (results, index) {
              return StudentCard(student: results);
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
