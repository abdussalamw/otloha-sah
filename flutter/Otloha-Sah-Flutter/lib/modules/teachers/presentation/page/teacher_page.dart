import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/widgets/tool_bar_app.dart';
import '../../../auth_module/presentation/pages/login_page.dart';
import '../../../profile/presentation/page/profile_bnb_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/teacherviewtype_cubit.dart';
import '../widgets/item_teacher.dart';
import 'package:get/get.dart';

import '../../../../core/exception_indicators/error_indicator.dart';

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
    return Scaffold(
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
      child:
          Padding(padding: const EdgeInsets.all(8.0), child: _showData(_type)),
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
          //     'bio of teacher bio of teacher bio of teacher bio of teacher bio of teacher ',
          action: () {
            Get.to(
              () => ProfileBNBPage(user: results),
            );
          },
          typeView: _type,
          isCertified: results.teacherProfile?.isCertified ?? false,
          isFav: cubit.selected == results.id,
          userImg: results.profileImage ?? '',
          //  results: results,
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
          // 'Irure sint sint aute velit amet.Eu do Lorem nisi nulla excepteur esse eu est dolor esse tempor.',
          action: () {
            Get.to(
              () => ProfileBNBPage(
                user: results,
              ),
            );
          },
          typeView: _type,
          isCertified:
              results.teacherProfile?.certifications?.isNotEmpty ?? false,
          isFav: cubit.selected == results.id,
          userImg: results.profileImage ?? '',
          //  results: results,
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
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actionIcon: IconButton(
        icon: Icon(_type ? Icons.grid_view : Icons.list),
        onPressed: () {
          BlocProvider.of<TeacherviewtypeCubit>(context).changeType(!_type);
        },
      ),
      title: translate('Teachers'),
    );
  }

  _viewDate(TeacherviewtypeState state, TeacherviewtypeCubit cubit) {
    if (state is TeacherLoadingState) {
      //return _viewItems();
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
    } else if (state is TeacherErrorState) {
      return Expanded(
          child: ErrorIndicator(
        error: state.error,
      ));
    }
    if (state is NoAuthState) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      });
    }
    return Expanded(
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
