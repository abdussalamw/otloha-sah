import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/exception_indicators/error_indicator.dart';
import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/widgets/tool_bar_app.dart';

import '../../../auth_module/presentation/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/teacherviewtype_cubit.dart';
import '../widgets/item_teacher.dart';

class StudentsPage extends StatefulWidget {
  static const routeName = '/students';

  const StudentsPage({Key? key}) : super(key: key);

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  bool _type = true;

  late TeacherviewtypeCubit? cubit;
  PagingController pagingController =
      PagingController<int, User>(firstPageKey: 1);
  @override
  void initState() {
    super.initState();

    cubit = TeacherviewtypeCubit.get(context);
    cubit!.getStudents();
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
            return Column(
              children: [_topView(), _viewDate(state)],
            );
          },
        ),
      ),
    );
  }

  _viewDate(TeacherviewtypeState state) {
    if (state is TeacherErrorState) {
      return Expanded(child: ErrorIndicator(error: state.error));
    } else if (state is TeacherFetchedState || state is TeacherviewtypeChange) {
      if (cubit!.teachers != null && cubit!.teachers!.isNotEmpty) {
        return _viewItems();
      } else {
        return const Expanded(
          child: ErrorIndicator(
            error: EmptyListException,
          ),
        );
      }
    } else if (state is TeacherErrorState) {
      return Expanded(
          child: ErrorIndicator(
        error: state.error,
      ));
    }

    if (state is NoAuthState) {
      Future.microtask(() =>
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName));
    }
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Expanded _viewItems() {
    return Expanded(
      child:
          Padding(padding: const EdgeInsets.all(8.0), child: _showData(_type)),
    );
  }

  _showData(bool type) {
    print(type);
    return PaginationData<User>(
      getData: (nextLink) async {
        return await cubit?.getNextStudents(nextLink);
      },
      drowItem: (results, index) {
        return type ? _itemView(index, results) : _itemViewGrid(index, results);
      },
      pagingController: pagingController,
      initData: cubit!.teachers!,
      isGrid: !type,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 2 / 2,
      ),
    );
  }

  _itemViewGrid(int index, User results) {
    return BlocBuilder<TeacherviewtypeCubit, TeacherviewtypeState>(
      builder: (context, state) {
        return ItemTeacherGrid(
          fullName: results.fullname!,
          userName: '${results.firstName!} ${results.lastName!}',
          rate: "${results.rate ?? ''}",
          userId: (results.level ?? '') + tr('Student'),
          userbio: results.bio,
          action: () {},
          typeView: _type,
          isCertified: results.teacherProfile?.isCertified ?? false,
          isFav: false,
          isStudent: true,
          userImg: results.profileImage ?? '',
        );
      },
    );
  }

  _itemView(int index, User results) {
    return BlocBuilder<TeacherviewtypeCubit, TeacherviewtypeState>(
      builder: (context, state) {
        return ItemTeacher(
          userName: results.username ?? '',
          rate: "${results.rate ?? ''}",
          userId: (results.level ?? '') + tr('Student'),
          userbio: results.bio,
          action: () {},
          typeView: _type,
          isCertified: results.teacherProfile?.isCertified ?? false,
          isFav: false,
          isStudent: true,
          userImg: results.profileImage ?? '',
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
      //onSearch: (val) {},
      actionIcon: IconButton(
        icon: Icon(_type ? Icons.grid_view : Icons.list),
        onPressed: () {
          BlocProvider.of<TeacherviewtypeCubit>(context).changeType(!_type);
        },
      ),
      title: translate('Students'),
    );
  }
}
