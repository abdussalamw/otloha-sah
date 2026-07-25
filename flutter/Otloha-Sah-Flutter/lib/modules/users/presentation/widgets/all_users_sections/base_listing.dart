import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/utils/constant/utils.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/data_source/models/entities/entity.dart';
import 'package:otloha_sah_flutter/data_source/models/user/base_user.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/student.dart';
import 'package:otloha_sah_flutter/data_source/models/user/listing_models/teacher.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/sections/users_list_section_cubit.dart';
import 'package:otloha_sah_flutter/modules/users/cubit/sections/users_list_section_state.dart';
import 'package:otloha_sah_flutter/modules/entities/presentation/widgets/entity_card.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/cards/student_card.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/widgets/cards/teacher_card.dart';

class BaseSection<T> extends StatefulWidget {
  const BaseSection({
    super.key,
    required this.title,
    this.hasShowMore = false,
    this.onShowMore,
    required this.dataCallback,
  })  : assert(!hasShowMore || onShowMore != null,
            'onShowMore must be provided if hasShowMore is true'),
        super();

  final String title;
  final bool hasShowMore;
  final Function()? onShowMore;
  final Function(BuildContext context) dataCallback;
  @override
  State<BaseSection<T>> createState() => _BaseSectionState<T>();
}

class _BaseSectionState<T> extends State<BaseSection<T>> {
  @override
  void initState() {
    super.initState();
    widget.dataCallback(context);
  }

  @override
  Widget build(BuildContext context) {
    if (T == List<BaseUser>) {
      return BlocBuilder<UsersListSectionCubit, UsersListSectionState>(
        builder: (context, state) {
          if (state is UsersListSectionLoaded) {
            return BaseSectionWidget(
              title: widget.title,
              body: Column(
                children: state.users.map((e) {
                  if (e is Student) {
                    return StudentCard(student: e);
                  } else if (e is Teacher) {
                    return TeacherCard(teacher: e);
                  } else if (e is BaseUser) {
                    if (e.isTeacher!) {
                      return TeacherCard(teacher: e.toTeacher());
                    } else {
                      return StudentCard(student: e.toStudent());
                    }
                  }
                  return EntityCard(entity: e);
                }).toList(),
              ),
              hasShowMore: widget.hasShowMore,
              onShowMore: widget.onShowMore,
            );
          }
          return const SizedBox();
        },
      );
    } else if (T == List<Entity>) {
      return BlocBuilder<EntitiesSectionCubit, EntitiesSectionState>(
        builder: (context, state) {
          if (state is EntitiesSectionLoaded) {
            return BaseSectionWidget(
              title: widget.title,
              body: Column(
                children:
                    state.entities.map((e) => EntityCard(entity: e)).toList(),
              ),
              hasShowMore: widget.hasShowMore,
              onShowMore: widget.onShowMore,
            );
          }
          return const SizedBox();
        },
      );
    }
    return const SizedBox();
  }
}

class BaseSectionWidget extends StatelessWidget {
  const BaseSectionWidget({
    super.key,
    required this.title,
    required this.body,
    required this.hasShowMore,
    required this.onShowMore,
  });

  final String title;
  final Widget body;
  final bool hasShowMore;
  final Function()? onShowMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: AppColor.txtColor3,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        body,
        if (hasShowMore)
          GestureDetector(
            onTap: onShowMore,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  translate('Show more'),
                  style: TextStyle(color: AppColor.txtColor3),
                ),
                Icon(Icons.expand_more, color: AppColor.txtColor3),
              ],
            ),
          ),
        if (hasShowMore)
          const Divider(
            height: 0,
            thickness: 1,
            color: AppColor.lightGrey,
          ),
      ],
    );
  }
}
