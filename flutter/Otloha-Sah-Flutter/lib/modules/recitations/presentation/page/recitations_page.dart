import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart' hide Trans;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';

import '../../../../core/design_system/tokens/app_colors.dart';
import '../../../../core/design_system/tokens/app_radius.dart';
import '../../../../core/design_system/tokens/app_shadows.dart';
import '../../../../core/design_system/tokens/app_spacing.dart';
import '../../../../core/design_system/tokens/app_typography.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/exception_indicators/error_indicator.dart';
import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../data_source/local/database/database_repository.dart';
import '../../../../data_source/user_services_data.dart';
import '../../../auth_module/presentation/pages/login_page.dart';
import '../../business_logic/cubit/popup_action_cubit.dart';
import '../../business_logic/cubit/popup_actions_state.dart';
import '../../business_logic/cubit/userrecitation_cubit.dart';
import '../widget/popup_recitation.dart';
import '../widget/recitation_item.dart';

class RecitationsPage extends StatefulWidget {
  const RecitationsPage({super.key});

  static const routeName = '/recitations';

  @override
  State<RecitationsPage> createState() => _RecitationsPageState();
}

class _RecitationsPageState extends State<RecitationsPage>
    with AutomaticKeepAliveClientMixin {
  late UserRecitationCubit cubit;

  PagingController pagingController =
      PagingController<int, Recitation>(firstPageKey: 1);

  @override
  void initState() {
    super.initState();

    cubit = UserRecitationCubit.get(context);
    cubit.fetchSentRecitation(1);
    cubit.setCon(pagingController);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        if (cubit.indexPlay != -2) {
          cubit.setIndexPlay(-2);
          return false;
        } else {
          return true;
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            elevation: 0.5,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              translate('my_records'),
              style: AppTypography.h3Bold(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            bottom: TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              labelStyle: AppTypography.buttonStyle().copyWith(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: translate('sent')),
                Tab(text: translate('unsent')),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                sentRecitations(),
                unsentRecitations(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sentRecitations() {
    return BlocBuilder<UserRecitationCubit, UserRecitationState>(
      builder: (context, state) {
        if (state is AuthErrorState) {
          Future.microtask(
            () => Navigator.of(context).pushReplacementNamed(LoginPage.routeName),
          );
        }

        return _showSentData();
      },
    );
  }

  unsentRecitations() {
    return BlocBuilder<UserRecitationCubit, UserRecitationState>(
      builder: (context, state) {
        if (state is AuthErrorState) {
          Future.microtask(
            () => Navigator.of(context).pushReplacementNamed(LoginPage.routeName),
          );
        }

        if (UserRecitationCubit.get(context).localUserRecitations.isNotEmpty) {
          return _showUnsentData();
        }
        if (UserRecitationCubit.get(context).localUserRecitations.isEmpty) {
          return Center(child: ErrorIndicator(error: EmptyListException()));
        }
        if (state is UserRecitationError) {
          if (state.error is NetworkConnectionException) {
            return _showUnsentData();
          }
          return Center(child: ErrorIndicator(error: state.error));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  _showSavedSent() {
    return cubit.userRecitatios.isEmpty
        ? Center(
            child: Text(
              translate('no_records'),
              style: AppTypography.bodyLarge().copyWith(fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.sm),
            itemCount: cubit.userRecitatios.length,
            itemBuilder: (context, index) {
              return RecitationItem(
                hasMenu: true,
                id: cubit.userRecitatios[index].id ?? 0,
                onLongPress: () {
                  Get.bottomSheet(
                    PopupRecitation(
                      isLocal: true,
                      isOwner: true,
                      isTeacher: false,
                      actions: const [
                        PopupActions.delete,
                        PopupActions.addToGeneral,
                        PopupActions.send,
                      ],
                      recitation: cubit.userRecitatios[index],
                      userId: UserDataServices.instance.getUserId() ?? 0,
                      isFinished: true,
                      showInGeneral: false,
                      delete: () async {
                        DatabaseRepository.instance.deleteUserRecitation(
                            cubit.userRecitatios[index].id!);
                        setState(() {
                          cubit.userRecitatios.removeAt(index);
                        });
                      },
                      onAddToGeneral: (recitation) {
                        if (recitation != null) {
                          setState(() {
                            cubit.userRecitatios.removeAt(index);
                          });
                          Navigator.pop(context);
                        }
                      },
                      onSendToTeacher: (recitation) {
                        if (recitation != null) {
                          setState(() {
                            cubit.userRecitatios.removeAt(index);
                          });
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                },
                isRead: false,
                recordPath: cubit.userRecitatios[index].localRecord ?? '',
                ayah: cubit.userRecitatios[index].name ?? '',
                userName: UserDataServices.instance.getUserDataFast()?.fullname ?? '',
                color: Colors.transparent,
                isLocal: true,
                isPlay: cubit.indexPlay == index,
                toggelPlay: () {
                  cubit.setIndexPlay(index);
                },
                onPress: () {},
                dateStr: cubit.userRecitatios[index].createdAt ?? '',
              );
            },
          );
  }

  _showUnsentData() {
    return cubit.localUserRecitations.isEmpty
        ? Center(
            child: Text(
              translate('no_records'),
              style: AppTypography.bodyLarge().copyWith(fontWeight: FontWeight.bold),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.sm),
            itemCount: cubit.localUserRecitations.length,
            itemBuilder: (context, index) {
              return RecitationItem(
                hasMenu: true,
                id: cubit.localUserRecitations[index].id ?? 0,
                onLongPress: () {
                  Get.bottomSheet(
                    PopupRecitation(
                      isLocal: true,
                      isOwner: true,
                      isTeacher: false,
                      actions: const [
                        PopupActions.delete,
                        PopupActions.addToGeneral,
                        PopupActions.send,
                      ],
                      userRecitation: cubit.localUserRecitations[index],
                      userId: UserDataServices.instance.getUserId() ?? 0,
                      isFinished: true,
                      showInGeneral: false,
                      delete: () async {
                        DatabaseRepository.instance.deleteUserRecitation(
                            cubit.localUserRecitations[index].id!);
                        setState(() {
                          cubit.localUserRecitations.removeAt(index);
                        });
                      },
                      onAddToGeneral: (recitation) {
                        if (recitation != null) {
                          setState(() {
                            cubit.localUserRecitations.removeAt(index);
                          });
                        }
                      },
                      onSendToTeacher: (recitation) {
                        if (recitation != null) {
                          setState(() {
                            cubit.localUserRecitations.removeAt(index);
                          });
                        }
                      },
                    ),
                  );
                },
                isRead: false,
                recordPath: cubit.localUserRecitations[index].record,
                ayah: cubit.localUserRecitations[index].name,
                userName: UserDataServices.instance.getUserDataFast()?.fullname ?? '',
                color: Colors.transparent,
                isLocal: true,
                isPlay: cubit.indexPlay == index,
                toggelPlay: () {
                  cubit.setIndexPlay(index);
                },
                onPress: () {},
                dateStr: '',
              );
            },
          );
  }

  _showSentData() {
    return BlocBuilder<PopupActionsCubit, PopupActionsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: cubit.isLocal
              ? _showSavedSent()
              : PaginationData<Recitation>(
                  getData: (nextLink) async {
                    return await cubit.getNextData(nextLink);
                  },
                  drowItem: (results, index) {
                    return _getItem(
                      results,
                      index,
                      false,
                    );
                  },
                  initData: cubit.userRecitatios,
                  pagingController: pagingController,
                ),
        );
      },
    );
  }

  Widget _getItem(Recitation recitations, int index, bool isLocal) {
    return RecitationItem(
      recitation: recitations,
      hasMenu: true,
      id: recitations.id,
      onLongPress: () => _onLongPressItem(index, recitations),
      isRead: false,
      ayah: recitations.name ?? '',
      ayahInfo: _getAyahInfo(recitations),
      userName: recitations.owner!.fullname,
      dateStr: (recitations.createdAt != null)
          ? DateFormat('hh:mm dd MMM')
              .format(DateTime.parse(recitations.createdAt ?? ''))
          : '',
      color: Colors.transparent,
      isPlay: cubit.indexPlay == index,
      owner: recitations.owner,
      toggelPlay: () {
        cubit.setIndexPlay(index);
      },
      isLocal: isLocal,
      onPress: () {},
    );
  }

  _getAyahInfo(Recitation results) {
    return '';
  }

  _onLongPressItem(index, Recitation results) {
    Get.bottomSheet(
      PopupRecitation(
        isLocal: false,
        isOwner: true,
        isTeacher: false,
        actions: const [
          PopupActions.delete,
          PopupActions.addToGeneral,
          PopupActions.send,
          PopupActions.markAsFinished,
          PopupActions.updateRecitation,
          PopupActions.markAsRemarkable,
        ],
        delete: () {
          cubit.deleteRecitation(index);
        },
        onAddToGeneral: (recitation) {
          if (recitation != null) {
            cubit.setRecitationChange(index, recitation as Recitation);
          }
        },
        onSendToTeacher: (recitation) {
          if (recitation != null) {
            cubit.setRecitationChange(index, recitation as Recitation);
          }
        },
        onSetRemakable: (recitation) {
          if (recitation != null) {
            cubit.setRecitationChange(index, recitation as Recitation);
          }
        },
        recitationId: results.id,
        userId: results.owner!.id,
        isFinished: results.finishedAt?.isNotEmpty ?? false,
        showInGeneral: results.showInGeneral ?? false,
        refrech: (value) async {
          cubit.updateDate(value, index);
        },
        recitation: results,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
