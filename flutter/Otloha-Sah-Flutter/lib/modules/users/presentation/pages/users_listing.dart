import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/data_source/models/invitations/invitation_recieved.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/data_source/user_services_data.dart';
import 'package:otloha_sah_flutter/modules/entities/presentation/pages/entities_listing_page.dart';
import 'package:otloha_sah_flutter/modules/invitations/cubit/invitation_recieved_list/invitation_recieved_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/invitations/presentation/widgets/recieved_invitations_listing.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/entities_list_cubit/entities_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/my_friends_list_cubit/friends_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/my_students_cubit/my_students_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/students_list_cubit/students_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/teachers_list_cubit/teachers_list_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/all_users_list.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/tabs/my_friends.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/tabs/my_students.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/tabs/students.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/tabs/teachers.dart';

class UsersListing extends StatefulWidget {
  const UsersListing({super.key});

  @override
  State<UsersListing> createState() => _UsersListingState();
}

class _UsersListingState extends State<UsersListing>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  SearchController controller = SearchController();

  final PagingController<int, Student> studentsPagingController =
      PagingController<int, Student>(firstPageKey: 1);

  final PagingController<int, Teacher> teachersPagingController =
      PagingController<int, Teacher>(firstPageKey: 1);

  final PagingController<int, Student> myStudentsPagingContoller =
      PagingController<int, Student>(firstPageKey: 1);

  final PagingController<int, Entity> entitiesPagingController =
      PagingController<int, Entity>(firstPageKey: 1);

  final PagingController<int, BaseUser> friendsPagingController =
      PagingController<int, BaseUser>(firstPageKey: 1);

  final PagingController<int, InvitationRecieved>
      invitationRecievedPagingController =
      PagingController<int, InvitationRecieved>(firstPageKey: 1);
  @override
  void initState() {
    super.initState();
    int tabLength = UserDataServices.instance.isATeacher ? 7 : 6;
    _tabController = TabController(length: tabLength, vsync: this);
    BlocProvider.of<StudentsListCubit>(context).setSearchController(controller);
    BlocProvider.of<TeachersListCubit>(context).setSearchController(controller);
    BlocProvider.of<EntitiesListCubit>(context).setSearchController(controller);
    BlocProvider.of<FriendsListCubit>(context).setSearchController(controller);
    BlocProvider.of<InvitationRecievedCubit>(context)
        .setSearchController(controller);

    if (UserDataServices.instance.isATeacher) {
      BlocProvider.of<MyStudentsCubit>(context).setSearchController(controller);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();

    controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 45,
          child: SearchBar(
            controller: controller,
            trailing: [
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    controller.clear();
                    studentsPagingController.refresh();

                    teachersPagingController.refresh();

                    entitiesPagingController.refresh();

                    friendsPagingController.refresh();

                    if (UserDataServices.instance.isATeacher) {
                      myStudentsPagingContoller.refresh();
                    }
                  }
                },
              )
            ],
            elevation: MaterialStateProperty.all(0),
            overlayColor: MaterialStateProperty.all(Colors.white),
            side: MaterialStateProperty.all(
                const BorderSide(color: AppColor.lightGrey)),
            padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            onTap: () {},
            hintText: tr('Search'),
            // onChanged: (_) {
            //   controller.openView();
            // },
            onSubmitted: (selectedText) {
              if (_tabController.index == 0) {
                _tabController.animateTo(1);
              }

              studentsPagingController.refresh();

              teachersPagingController.refresh();

              entitiesPagingController.refresh();

              friendsPagingController.refresh();

              if (UserDataServices.instance.isATeacher) {
                myStudentsPagingContoller.refresh();
              }
            },
            leading: const Icon(Icons.search),
          ),
        ),
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: <Widget>[
            Tab(text: translate('All users')),
            Tab(text: translate('Incoming invitations')),
            Tab(text: translate('Students')),
            Tab(text: translate('Teachers')),
            Tab(text: translate('Entities')),
            Tab(text: translate('My friends')),
            if (UserDataServices.instance.isATeacher)
              Tab(text: translate('My students'))
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Center(
            child: AllUsersList(
              onShowMoreEntities: () {
                _tabController.animateTo(4);
              },
              onShowMoreFriends: () {
                _tabController.animateTo(5);
              },
              onShowMoreMyStudents: () {
                _tabController.animateTo(6);
              },
              onShowMoreStudents: () {
                _tabController.animateTo(2);
              },
              onShowMoreTeachers: () {
                _tabController.animateTo(3);
              },
            ),
          ),
          Center(
            child: RecievedInvitationsListing(
                pagingController: invitationRecievedPagingController),
          ),
          Center(
            child: StudentsList(pagingController: studentsPagingController),
          ),
          Center(
            child: TeachersList(pagingController: teachersPagingController),
          ),
          EntitiesListingPage(pagingController: entitiesPagingController),
          Center(
            child: MyFriendsList(pagingController: friendsPagingController),
          ),
          if (UserDataServices.instance.isATeacher)
            Center(
              child:
                  MyStudentsList(pagingController: myStudentsPagingContoller),
            ),
        ],
      ),
    );
  }
}
