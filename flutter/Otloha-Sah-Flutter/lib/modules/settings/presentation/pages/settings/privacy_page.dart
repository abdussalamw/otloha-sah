import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/utils/themes/color.dart';
import '../../../business_logic/privacy_groups/privacy_groups_cubit.dart';
import '../../../business_logic/privacy_groups/privacy_groups_state.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({
    super.key,
    required this.group,
  });
  final String group;

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  @override
  void initState() {
    PrivacyGroupsCubit.get(context).getPrivacyGroups('privacy');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('privacy')),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: BlocBuilder<PrivacyGroupsCubit, PrivacyGroupsState>(
          builder: (context, state) {
            if (state is PrivacyGroupsLoaded) {
              return ListView.separated(
                itemCount: PrivacyGroupsCubit.get(context).privacyGroups.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(PrivacyGroupsCubit.get(context)
                            .privacyGroups[index]
                            .label[
                        EasyLocalization.of(context)!.locale.languageCode]!),
                    subtitle: Text(PrivacyGroupsCubit.get(context)
                            .privacyGroups[index]
                            .description[
                        EasyLocalization.of(context)!.locale.languageCode]!),
                    trailing: Switch(
                      activeColor: AppColor.txtColor3,
                      value: PrivacyGroupsCubit.get(context)
                          .privacyGroups[index]
                          .value,
                      onChanged: (value) {
                        PrivacyGroupsCubit.get(context).updatePrivacyGroup(
                            state.privacyGroups[index], index);
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    indent: 12,
                    endIndent: 12,
                  );
                },
              );
            } else if (state is PrivacyGroupsError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
