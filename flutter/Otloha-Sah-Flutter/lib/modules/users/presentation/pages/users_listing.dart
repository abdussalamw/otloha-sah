import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_colors.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_radius.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_spacing.dart';
import 'package:otloha_sah_flutter/core/design_system/tokens/app_typography.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/widgets/tool_bar_app.dart';
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

class _UsersListingState extends State<UsersListing> with TickerProviderStateMixin {
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
    BlocProvider.of<InvitationRecievedCubit>(context).setSearchController(controller);

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

  void _triggerRefresh() {
    studentsPagingController.refresh();
    teachersPagingController.refresh();
    entitiesPagingController.refresh();
    friendsPagingController.refresh();

    if (UserDataServices.instance.isATeacher) {
      myStudentsPagingContoller.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              ToolBarApp(
                backIcon: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: 'دليل المستخدمين والمعلمين',
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                child: SizedBox(
                  height: 46,
                  child: TextField(
                    controller: controller,
                    style: AppTypography.bodyMedium(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    decoration: InputDecoration(
                      hintText: tr('ابحث باسم المستخدم أو المعلم...'),
                      hintStyle: AppTypography.bodySmall(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            controller.clear();
                            _triggerRefresh();
                          }
                        },
                      ),
                      filled: true,
                      fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: AppSpacing.md),
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.radiusMd,
                        borderSide: BorderSide(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: AppRadius.radiusMd,
                        borderSide: BorderSide(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: AppRadius.radiusMd,
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                    onSubmitted: (selectedText) {
                      if (_tabController.index == 0) {
                        _tabController.animateTo(1);
                      }
                      _triggerRefresh();
                    },
                  ),
                ),
              ),

              // TabBar Pills
              Container(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 3,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  labelStyle: AppTypography.bodyMedium().copyWith(fontWeight: FontWeight.bold),
                  unselectedLabelStyle: AppTypography.bodyMedium(),
                  tabs: <Widget>[
                    Tab(text: translate('الجميع')),
                    Tab(text: translate('الدعوات')),
                    Tab(text: translate('الطلاب')),
                    Tab(text: translate('المعلمون')),
                    Tab(text: translate('الجهات')),
                    Tab(text: translate('أصدقائي')),
                    if (UserDataServices.instance.isATeacher)
                      Tab(text: translate('طلابي'))
                  ],
                ),
              ),

              // TabBarView Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    AllUsersList(
                      onShowMoreEntities: () => _tabController.animateTo(4),
                      onShowMoreFriends: () => _tabController.animateTo(5),
                      onShowMoreMyStudents: () => _tabController.animateTo(6),
                      onShowMoreStudents: () => _tabController.animateTo(2),
                      onShowMoreTeachers: () => _tabController.animateTo(3),
                    ),
                    RecievedInvitationsListing(
                      pagingController: invitationRecievedPagingController,
                    ),
                    StudentsList(pagingController: studentsPagingController),
                    TeachersList(pagingController: teachersPagingController),
                    EntitiesListingPage(pagingController: entitiesPagingController),
                    MyFriendsList(pagingController: friendsPagingController),
                    if (UserDataServices.instance.isATeacher)
                      MyStudentsList(pagingController: myStudentsPagingContoller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
