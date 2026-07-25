import 'package:flutter/material.dart';
import 'package:otloha_sah_flutter/core/utils/constant/constants.dart';
import 'package:otloha_sah_flutter/core/widgets/warnings_and_alerts/alert_popup.dart';
import 'package:otloha_sah_flutter/data_source/cache_helper.dart';
import 'package:otloha_sah_flutter/modules/splash/business_logic/cubit/splash_cubit.dart';
import '../../../../../core/utils/constant/utils.dart';
import '../../../../../core/widgets/auth_navigator.dart';
import '../../../business_logic/cubit/home_cubit.dart';
import '../../widget/bottom_bar.dart';
import '../../widget/init_data.dart';
import '../../../../quran/business_logic/cubit/quran_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../settings/business_logic/themes/theme_cubit.dart';
import 'package:quran_widget_flutter/quran_widget_flutter.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      bool isFirstTime =
          CacheHelper.getData(key: Constants.firstTimeFlag) ?? true;
      if (isFirstTime && SplashCubit.isLogin) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertPopup(
              alertType: AlertType.seccess,
              title: translate('Welcome in Otloha Sah App'),
              message: translate(
                  'Congratulations, Now you can head to Corrected Recitations tab and begin to record chapter Al-Fatihah'),
              buttonText: translate('Start Learning'),
              onTap: () {
                HomeCubit.get(context).changeIndex(1);
                Navigator.pop(context);
              },
            );
          },
        );
        CacheHelper.saveData(key: Constants.firstTimeFlag, value: false);
      }
      HomeCubit.get(context).getUnseenCount();
    });
    Future.microtask(() => BlocProvider.of<HomeCubit>(context).changeIndex(
        (ModalRoute.of(context)!.settings.arguments as int?) ?? 0));
    Future.microtask(() => BlocProvider.of<HomeCubit>(context).getUserData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            var cubit = HomeCubit.get(context);
            return WillPopScope(
              onWillPop: () async {
                if (QuranViewCubit.get(context).pageType != PageType.quran) {
                  QuranViewCubit.get(context)
                      .changePageType(page: PageType.quran);
                  QuranViewCubit.get(context).changeFalseFloating();
                  return false;
                }
                if (_index > 0) {
                  cubit.changeIndex(0);
                  return false;
                } else if (!HomeCubit.get(context).isExit) {
                  HomeCubit.get(context).setExit(true);
                  Fluttertoast.showToast(
                    msg: translate('Please Back Again To Exit'),
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.grey.shade800,
                  );
                  return false;
                } else {
                  return true;
                }
              },
              child: AuthNavigator(
                child: Stack(
                  children: [
                    Scaffold(
                      body: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeChangeIndex) {
                            _index = state.index;
                          }
                          return SafeArea(
                              child:
                                  HomeMenuItems().homeMenuItems[_index].page);
                        },
                      ),
                      bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeChangeIndex) {
                            _index = state.index;
                          }

                          return BubbleBottomBarApp(
                            onItemTapped: (int? index) {
                              _changePage(index).then((value) {
                                Future.delayed(
                                  const Duration(milliseconds: 50),
                                  () {
                                    if (index == 1) {
                                      BlocProvider.of<QuranViewCubit>(context)
                                          .changePluginPageType(
                                              page: PageType.quran);
                                    }
                                  },
                                );
                              });
                            },
                            selectedIndex: _index,
                            items: HomeMenuItems().homeMenuItems,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future _changePage(index) async {
    BlocProvider.of<HomeCubit>(context).changeIndex(index ?? 0);
  }
}
