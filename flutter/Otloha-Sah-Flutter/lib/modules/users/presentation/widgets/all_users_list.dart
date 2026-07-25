import 'package:flutter/widgets.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/all_users_sections/entities.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/all_users_sections/my_friends.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/all_users_sections/my_students.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/all_users_sections/students.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/all_users_sections/teachers.dart';

class AllUsersList extends StatefulWidget {
  const AllUsersList({
    super.key,
    required this.onShowMoreEntities,
    required this.onShowMoreFriends,
    required this.onShowMoreMyStudents,
    required this.onShowMoreStudents,
    required this.onShowMoreTeachers,
  });
  final Function() onShowMoreFriends;
  final Function() onShowMoreMyStudents;
  final Function() onShowMoreStudents;
  final Function() onShowMoreTeachers;
  final Function() onShowMoreEntities;

  @override
  State<AllUsersList> createState() => _AllUsersListState();
}

class _AllUsersListState extends State<AllUsersList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyFriends(onShowMore: widget.onShowMoreFriends),
            if (UserDataServices.instance.isATeacher)
              MyStudents(onShowMore: widget.onShowMoreMyStudents),
            Students(onShowMore: widget.onShowMoreStudents),
            Teachers(onShowMore: widget.onShowMoreTeachers),
            Entities(onShowMore: widget.onShowMoreEntities),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
