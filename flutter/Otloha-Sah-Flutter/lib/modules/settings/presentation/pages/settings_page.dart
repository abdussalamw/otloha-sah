import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/widgets/loader.dart';
import 'package:otloha_sah_flutter/modules/settings/presentation/pages/settings/contact_us_page.dart';
import 'package:otloha_sah_flutter/modules/users/presentation/pages/honor_board.dart';
import '../../../../data_source/models/setting_model/setting.dart';
import '../../../profile/presentation/widget/settings_item.dart';
import '../../business_logic/themes/theme_cubit.dart';
import 'settings/about_us_page.dart';
import 'settings/how_it_works_page.dart';
import '../../../splash/business_logic/cubit/splash_cubit.dart';
import '../../../../data_source/models/setting_model/init_data.dart';
import '../../../auth_module/business_logic/auth_cubit.dart';
import '../../../auth_module/presentation/pages/onboard_page.dart';
import '../../../profile/presentation/page/profile_settings.dart';
import '../widgets/item_setting.dart';
import '../widgets/item_setting_sub.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../../core/widgets/tool_bar_app.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  static const routeName = '/settings';

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              shrinkWrap: true,
              children: [
                _topView(context),
                _titleSection(tr('Main Section')),
                _viewSettings(context, SettingsMenusData().settings),
                const Divider(),
                _titleSection(tr('Recitations')),
                _viewSettings(context, SettingsMenusData().downloadRecitations),
                const Divider(),
                _titleSection(tr('Tajweed')),
                _viewSettings(context, SettingsMenusData().downloadTajweed),
                const Divider(),
                _titleSection(tr('Tafsir')),
                _viewSettings(context, SettingsMenusData().downloadTafsir),
                const Divider(),
                _titleSection(tr('QuranTranslationLanguage')),
                _viewSettings(context, SettingsMenusData().downloadQTL),
                const Divider(),
                _userInfoData(),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  _viewSettings(BuildContext context, List<Settings> list) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 150,
          childAspectRatio: 2 / 2.5,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return ItemSetting(
            settings: list[index],
            change: _change,
          );
        },
      ),
    );
  }

  BlocConsumer<AuthCubit, AuthState> _userInfoData() {
    return BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
      if (state is LogOutSuccessState) {
        hideLoader();
        var cubit = AuthCubit.get(context);

        cubit.changeIsLogin().then((value) {
          Get.to(() => const OnBoardPage());
        });
      } else if (state is LogOutLoadingState) {
        showLoader(context);
      }
    }, builder: (context, state) {
      var authCubit = AuthCubit.get(context);
      return (SplashCubit.isLogin)
          ? ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _titleSection(tr('Settings')),
                SettingsItem(
                  title: tr('change_theme'),
                  icon: Icons.color_lens,
                  action: () {
                    ThemeCubit.get(context).changeTheme();
                  },
                ),
                SettingsItem(
                  title: tr('Profile Settings'),
                  icon: Icons.settings_outlined,
                  action: () {
                    Get.to(() => ProfileSettings());
                  },
                ),
                SettingsItem(
                  title: tr('About Us'),
                  icon: Icons.info_outline,
                  action: () {
                    Get.to(() => const AboutUsPage());
                  },
                ),
                SettingsItem(
                  title: tr('Honor Board'),
                  icon: Icons.military_tech,
                  action: () {
                    Get.to(() => const HonorBoardPage(type: 'student'));
                  },
                ),
                SettingsItem(
                  title: tr('Best Teachers'),
                  icon: Icons.military_tech,
                  action: () {
                    Get.to(() => const HonorBoardPage(type: 'teacher'));
                  },
                ),
                SettingsItem(
                  title: tr('How it works'),
                  icon: Icons.question_mark,
                  action: () {
                    Get.to(() => const HowItWorksPage());
                  },
                ),
                SettingsItem(
                  title: tr('Contact us'),
                  icon: Icons.phone,
                  action: () {
                    Get.to(() => const ContactUsPage());
                  },
                ),
                SettingsItem(
                  title: tr('Log Out'),
                  icon: Icons.logout,
                  action: () {
                    authCubit.userLogOut();
                  },
                ),
              ],
            )
          : _viewItemProfile(
              title: 'Login',
              icon: Icons.login,
              action: () {
                Get.to(const OnBoardPage());
              },
            );
    });
  }

  ListTile _viewItemProfile({
    required String title,
    required IconData icon,
    required Function() action,
  }) {
    return ListTile(
      onTap: action,
      title: TextView(
        text: tr(title),
        textAlign: TextAlign.start,
        colorText: AppColor.txtColor3,
        sizeText: 17,
        weightText: FontWeight.bold,
      ),
      leading: Icon(
        icon,
        color: AppColor.txtColor3,
        size: 20,
      ),
    );
  }

  SizedBox _titleSection(String title) {
    return SizedBox(
      width: double.infinity,
      child: TextView(
        text: tr(title),
        colorText: AppColor.txtColor3,
        sizeText: 14,
        weightText: FontWeight.w700,
        padding: const EdgeInsets.all(4),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _topView(BuildContext context) {
    return ToolBarApp(
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('Settings'),
    );
  }

  _change() {
    setState(() {
      SettingsMenusData().settings;
      SettingsMenusData().downloadRecitations;
      SettingsMenusData().downloadTafsir;
      SettingsMenusData().downloadTajweed;
      SettingsMenusData().downloadQTL;
    });
  }

  setting(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: SettingsMenusData().settings.length,
      itemBuilder: (context, index) {
        return ItemSubSetting(settings: SettingsMenusData().settings[index]);
      },
    );
  }
}
