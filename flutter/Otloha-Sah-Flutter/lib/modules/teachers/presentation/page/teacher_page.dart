import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/exception_indicators/error_indicator.dart';
import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/widgets/tool_bar_app.dart';
import '../../../auth_module/presentation/pages/login_page.dart';
import '../../../profile/presentation/page/profile_bnb_page.dart';
import '../../business_logic/cubit/teacherviewtype_cubit.dart';
import '../widgets/item_teacher.dart';

class TeacherPage extends StatefulWidget {
  static const routeName = '/teacher';

  const TeacherPage({Key? key}) : super(key: key);

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  bool _type = true;
  PagingController pagingController =
      PagingController<int, User>(firstPageKey: 1);

  late TeacherviewtypeCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = TeacherviewtypeCubit.get(context);
    cubit.setPagingController(pagingController);
    cubit.getTeacher();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: BlocBuilder<TeacherviewtypeCubit, TeacherviewtypeState>(
          builder: (context, state) {
            if (state is TeacherviewtypeChange) {
              _type = state.type;
            }
            var cubit = TeacherviewtypeCubit.get(context);
            return Column(
              children: [_topView(), _viewDate(state, cubit)],
            );
          },
        ),
      ),
    );
  }

  _showData(bool type) {
    return PaginationData<User>(
      getData: (nextLink) async {
        return await cubit.getNextTeachers(nextLink);
      },
      drowItem: (results, index) {
        return type ? _itemView(index, results) : _itemViewGrid(index, results);
      },
      initData: cubit.teachers ?? [],
      pagingController: pagingController,
      isGrid: !type,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 2,
      ),
    );
  }

  Expanded _viewItems() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: _showData(_type),
      ),
    );
  }

  _itemViewGrid(int index, User results) {
    return BlocBuilder<TeacherviewtypeCubit, TeacherviewtypeState>(
      builder: (context, state) {
        TeacherviewtypeCubit teacherViewCubit =
            TeacherviewtypeCubit.get(context);
        return ItemTeacherGrid(
          fullName: results.fullname!,
          userName:
              '${results.firstName ?? tr('Add')} ${results.lastName ?? tr('Add')}',
          rate: "${results.rate ?? ''}",
          userId:
              '${results.teacherProfile?.teacherType ?? ''} ${tr('Teacher')}',
          userbio: results.bio,
          action: () {
            Get.to(() => ProfileBNBPage(user: results));
          },
          typeView: _type,
          isCertified: results.teacherProfile?.isCertified ?? false,
          isFav: cubit.selected == results.id,
          userImg: results.profileImage ?? '',
          setFav: () {
            teacherViewCubit.markAsFavTeacher(
              id: results.id,
              results: results,
              context: context,
            );
          },
        );
      },
    );
  }

  _itemView(int index, User results) {
    return BlocBuilder<TeacherviewtypeCubit, TeacherviewtypeState>(
      builder: (context, state) {
        TeacherviewtypeCubit teacherViewCubit =
            TeacherviewtypeCubit.get(context);
        return ItemTeacher(
          userName: results.username,
          rate: '${results.rate ?? ''}',
          userId: tr((results.teacherProfile?.teacherType ?? '')),
          userbio: results.bio,
          action: () {
            Get.to(() => ProfileBNBPage(user: results));
          },
          typeView: _type,
          isCertified:
              results.teacherProfile?.certifications?.isNotEmpty ?? false,
          isFav: cubit.selected == results.id,
          userImg: results.profileImage ?? '',
          setFav: () {
            teacherViewCubit.markAsFavTeacher(
              id: results.id,
              results: results,
              context: context,
            );
          },
        );
      },
    );
  }

  Widget _topView() {
    return ToolBarApp(
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actionIcon: IconButton(
        icon: Icon(_type ? Icons.grid_view_rounded : Icons.view_list_rounded),
        onPressed: () {
          BlocProvider.of<TeacherviewtypeCubit>(context).changeType(!_type);
        },
      ),
      title: translate('Teachers'),
    );
  }

  _viewDate(TeacherviewtypeState state, TeacherviewtypeCubit cubit) {
    if (state is TeacherLoadingState) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (state is TeacherErrorState) {
      return Expanded(child: ErrorIndicator(error: state.error));
    } else if (state is TeacherFetchedState || state is TeacherviewtypeChange) {
      if (cubit.teachers != null && cubit.teachers!.isNotEmpty) {
        return _viewItems();
      } else {
        return const Expanded(child: ErrorIndicator(error: EmptyListException));
      }
    }
    if (state is NoAuthState) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      });
    }
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
