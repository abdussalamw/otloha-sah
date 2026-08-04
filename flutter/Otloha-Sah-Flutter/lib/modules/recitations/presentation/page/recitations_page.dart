import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/pagination/view/pagination_view.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../../data_source/local/database/database_repository.dart';
import '../../../../data_source/user_services_data.dart';
import '../../../auth_module/presentation/pages/login_page.dart';
import '../../business_logic/cubit/popup_action_cubit.dart';
import '../../business_logic/cubit/popup_actions_state.dart';
import '../widget/recitation_item.dart';
import '../../../settings/presentation/widgets/search_bar_app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../core/exception_indicators/error_indicator.dart';
import '../../business_logic/cubit/userrecitation_cubit.dart';
import '../widget/popup_recitation.dart';

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
    return WillPopScope(
      onWillPop: () async {
        if (cubit.indexPlay != -2) {
          cubit.setIndexPlay(-2);
          return false;
        } else {
          // cubit?.reset();
          return true;
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColor.userNameColor),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: TextView(
              text: translate('my_records'),
              colorText: AppColor.txtColor3,
              weightText: FontWeight.bold,
            ),
            elevation: 0.0,
            backgroundColor: AppColor.transparent,
            bottom: TabBar(
              labelColor: AppColor.headTextColor,
              tabs: [
                Tab(text: translate('sent')),
                Tab(text: translate('unsent')),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                // _topView(),
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
            () =>
                Navigator.of(context).pushReplacementNamed(LoginPage.routeName),
          );
        }

        return _showSentData();

        if (state is UserRecitationFetched ||
            state is ChangeIndexState ||
            state is RemoveUserRecitationState) {
          return _showSentData();
        }
        if (state is UserRecitationError) {
          return Center(child: ErrorIndicator(error: state.error));
        }
        // if (state is UserRecitationLoading || state is UserRecitationInitial) {
        // }/
        return const Center(child: CircularProgressIndicator());
        // return ErrorIndicator(error: SomeThingWentWrong());
      },
    );
  }

  unsentRecitations() {
    return BlocBuilder<UserRecitationCubit, UserRecitationState>(
      builder: (context, state) {
        if (state is AuthErrorState) {
          Future.microtask(
            () =>
                Navigator.of(context).pushReplacementNamed(LoginPage.routeName),
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
          // print(state.error);
        }
        // if (state is UserRecitationLoading || state is UserRecitationInitial) {
        // }
        return const Center(child: CircularProgressIndicator());
        // return ErrorIndicator(error: SomeThingWentWrong());
      },
    );
  }

  _showSavedSent() {
    return cubit.userRecitatios.isEmpty
        ? Center(
            child: TextView(
              text: translate('no_records'),
              colorText: AppColor.txtColor3,
              weightText: FontWeight.bold,
            ),
          )
        : ListView.builder(
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
                      userId: UserDataServices.instance.getUserId()!,
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
                        print('local recitation $recitation');
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
                // wavePath: recitations.records?.first.wave,
                ayah: cubit.userRecitatios[index].name ?? '',

                // ayahInfo: _getAyahInfo(recitations),
                userName: UserDataServices.instance.getUserDataFast()?.fullname ?? '',
                // dateStr: (recitations.finishedAt != null)
                //     ? DateFormat('hh:mm dd MMM')
                //         .format(DateTime.parse(recitations.finishedAt ?? ''))
                //     : null,
                color: AppColor.transparent,
                isLocal: true,

                isPlay: cubit.indexPlay == index,
                toggelPlay: () {
                  cubit.setIndexPlay(index);
                },
                onPress: () {
                  //  Get.to(RecitationDetailsPage(recitationId: recitations.id ?? 0));
                },
                dateStr: cubit.userRecitatios[index].createdAt ?? '',
              );
            },
          );
  }

  _showUnsentData() {
    return cubit.localUserRecitations.isEmpty
        ? Center(
            child: TextView(
              text: translate('no_records'),
              colorText: AppColor.txtColor3,
              weightText: FontWeight.bold,
            ),
          )
        : ListView.builder(
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
                      userId: UserDataServices.instance.getUserId()!,
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
                // wavePath: recitations.records?.first.wave,
                ayah: cubit.localUserRecitations[index].name,
                // ayahInfo: _getAyahInfo(recitations),
                userName: UserDataServices.instance.getUserDataFast()?.fullname ?? '',
                // dateStr: (recitations.finishedAt != null)
                //     ? DateFormat('hh:mm dd MMM')
                //         .format(DateTime.parse(recitations.finishedAt ?? ''))
                //     : null,
                color: AppColor.transparent,
                isLocal: true,

                isPlay: cubit.indexPlay == index,
                toggelPlay: () {
                  cubit.setIndexPlay(index);
                },
                onPress: () {
                  //  Get.to(RecitationDetailsPage(recitationId: recitations.id ?? 0));
                },
                dateStr: '',
              );
            },
          );
  }

  _showSentData() {
    return BlocBuilder<PopupActionsCubit, PopupActionsState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
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

  Widget _topView() {
    return SearchBarApp(
      backIcon: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: translate('my_records'),
    );
  }

  Widget _getItem(Recitation recitations, int index, bool isLocal) {
    return RecitationItem(
      recitation: recitations,
      hasMenu: true,
      id: recitations.id,
      onLongPress: () => _onLongPressItem(index, recitations),
      isRead: false,
      // recordPath: recitations.localRecord ??
      //     (recitations.record != null ? recitations.record!.record : ''),
      // wavePath: recitations.records?.first.wave,
      ayah: recitations.name ?? '',
      ayahInfo: _getAyahInfo(recitations),
      userName: recitations.owner!.fullname,
      dateStr: (recitations.createdAt != null)
          ? DateFormat('hh:mm dd MMM')
              .format(DateTime.parse(recitations.createdAt ?? ''))
          : '',
      color: AppColor.transparent,
      isPlay: cubit.indexPlay == index,
      owner: recitations.owner,
      toggelPlay: () {
        cubit.setIndexPlay(index);
      },
      isLocal: isLocal,
      onPress: () {
        //  Get.to(RecitationDetailsPage(recitationId: recitations.id ?? 0));
      },
    );
  }

  _getAyahInfo(Recitation results) {
    //${translate('Sourah')}
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
    tr('from verse') +
        results.verseIds![0].toString() +
        tr('to verse') +
        results.verseIds![results.verseIds!.length - 1].toString();
  }

  @override
  bool get wantKeepAlive => true;
}
