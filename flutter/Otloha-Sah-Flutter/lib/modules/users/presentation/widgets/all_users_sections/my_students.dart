import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/sections/users_list_section_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/all_users_sections/base_listing.dart';

class MyStudents extends StatelessWidget {
  const MyStudents({
    super.key,
    required this.onShowMore,
  });
  final Function() onShowMore;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersListSectionCubit(),
      child: BaseSection<List<BaseUser>>(
        title: translate('My Students'),
        onShowMore: onShowMore,
        hasShowMore: true,
        dataCallback: (context) {
          BlocProvider.of<UsersListSectionCubit>(context).getMyStydents();
        },
      ),
    );
  }
}
