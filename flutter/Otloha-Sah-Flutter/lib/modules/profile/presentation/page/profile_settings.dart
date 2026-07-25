import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/pages/blocked_users_listing.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../auth_module/business_logic/auth_cubit.dart';
import 'settings/register_as_techer.dart';
import '../widget/settings_item.dart';
import '../../../settings/presentation/pages/settings/privacy_page.dart';
import '../../../settings/business_logic/settings/settings_cubit.dart';
import 'settings/update_email.dart';
import 'settings/update_phone.dart';
import 'settings/update_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'settings/change_password.dart';

class ProfileSettings extends StatelessWidget {
  ProfileSettings({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              tr('Profile Settings'),
            ),
          ),
          backgroundColor: const Color(0xfff8f8f8),
          body: SafeArea(
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SettingsItem(
                      title: tr('Update Profile'),
                      icon: Icons.person_outline,
                      action: () {
                        Get.to(() => const UpdateProfile());
                      },
                    ),
                    SettingsItem(
                      title: tr('Update Email'),
                      icon: Icons.email_outlined,
                      action: () {
                        Get.to(() => UpdateEmail());
                      },
                    ),
                    SettingsItem(
                      title: tr('Update Phone'),
                      icon: Icons.phone_outlined,
                      action: () {
                        Get.to(() => UpdatePhone());
                      },
                    ),
                    SettingsItem(
                      title: tr('Change Password'),
                      icon: Icons.shield_outlined,
                      action: () {
                        Get.to(() => ChangePassword());
                      },
                    ),
                    SettingsItem(
                      title: tr('privacy'),
                      icon: Icons.privacy_tip_outlined,
                      action: () {
                        Get.to(() => const PrivacyPage(group: 'privacy'));
                      },
                    ),
                    SettingsItem(
                      title: tr('Blocked users'),
                      icon: Icons.block,
                      action: () {
                        Get.to(() => const BlockedUsersListing());
                      },
                    ),
                    SettingsItem(
                      title: translate('Register As Teacher'),
                      action: () {
                        Get.to(const RegisterAsTeacher());
                      },
                      icon: Icons.person_add_alt_outlined,
                    ),
                    SettingsItem(
                      title: translate('delete_account'),
                      action: () async {
                        if (await confirm(
                          context,
                          title: Text(translate('are_you_sure')),
                          content: Text(translate(
                              'are_you_sure_you_want_to_delete_this_account')),
                          textOK: Text(translate('yes')),
                          textCancel: Text(translate('no')),
                        )) {
                          await AuthCubit.get(context).deleteAccount();
                        }
                      },
                      icon: Icons.delete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
