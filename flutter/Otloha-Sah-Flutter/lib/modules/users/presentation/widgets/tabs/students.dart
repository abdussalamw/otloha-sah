import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/students_list_cubit/students_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/cards/student_card.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({
    super.key,
    required this.pagingController,
  });

  final PagingController pagingController;

  @override
  State<StudentsList> createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<StudentsListCubit, StudentsListState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PaginationData<Student>(
            getData: (nextLink) async {
              return await StudentsListCubit.cubit(context)
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
