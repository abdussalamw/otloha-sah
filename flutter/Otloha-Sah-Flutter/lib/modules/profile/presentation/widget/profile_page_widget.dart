import 'package:otloha_sah_flutter/data_source/models/translation/translatable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';
import 'package:otloha_sah_flutter/data_source/models/user/user.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/widgets/cached_image.dart';
import '../../../../core/widgets/warnings_and_alerts/warning.dart';
import '../../../../data_source/models/progress/statistics_model.dart';
import '../../../../data_source/remote/progress_service.dart';
import '../../../home/business_logic/cubit/home_cubit.dart';
import '../../business_logic/profile_pic_cubit/profile_page_cubit.dart';
import '../page/profile_settings.dart';
import '../../../recitations/presentation/widget/recitation_item.dart';
import '../../../splash/business_logic/cubit/splash_cubit.dart';
import 'package:quran_widget_flutter/data_source/cache/cache_repository.dart';
import '../../../../core/utils/themes/color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      // width: double.infinity,
      child: Column(
        children: [
          if (SplashCubit.missedNarrationCertification != null && user == null)
            GestureDetector(
              onTap: () {
                HomeCubit.get(context).changeIndex(1);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: AppColor.warningColor,
                    borderRadius: BorderRadius.circular(10)),
                child: WarningMessage(
                    text:
                        '${translate('you did not reach the minimum number of recitations required for Narration')} ${SplashCubit.missedNarrationCertification?.name.translate() ?? ''}'),
              ),
            ),
          ProfileHeader(
            profileImage: user == null
                ? ProfilePageCubit.get(context)
                        .currentUserProfile!
                        .profileImage ??
                    ''
                : user!.profileImage ?? '',
            user: user,
          ),
          ProfileBody(
            user: user ?? ProfilePageCubit.get(context).currentUserProfile!,
          ),
          // SizedBox(
          //   height: 50,
          //   child: AppBar(
          //     elevation: 0,
          //     backgroundColor: Colors.transparent,
          //     titleTextStyle: TextStyle(color: AppColor.headTextColor),
          //     bottom: TabBar(
          //       labelColor: AppColor.headTextColor,
          //       tabs: [
          //         Tab(text: translate('accepted')),
          //         Tab(text: translate('special')),
          //         Tab(text: translate('rejected')),
          //       ],
          //     ),
          //   ),
          // ),
          ProfilePageCubit.get(context).isRecitationsLocked
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock,
                        size: 100,
                        color: AppColor.headTextColor,
                      ),
                      Center(
                        child: Text(
                          translate('recitations_locked'),
                          style: TextStyle(
                            color: AppColor.headTextColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const ProfileFooter()
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.profileImage, this.user});
  final String profileImage;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CachedImage(url: profileImage, raduis: 45),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (user == null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => ProfileSettings());
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.resolveWith<
                                      OutlinedBorder>(
                                  (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) => AppColor.white),
                              side: MaterialStateProperty.resolveWith<BorderSide>(
                                  (states) => BorderSide(
                                      color: AppColor.headTextColor))),
                          child: Text(
                            translate('edit_profile'),
                            style: const TextStyle(
                                color: AppColor.grey,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (user == null)
                  FutureBuilder<StatisticsModel>(
                    future: ProgressService().getStatistics(
                        QuranCacheRepository.narrationSelectedId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {}
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            statistics(snapshot.data?.acceptedRecitations ?? 0,
                                tr('accepted')),
                            statistics(snapshot.data?.pendingRecitations ?? 0,
                                tr('pending')),
                            statistics(snapshot.data?.rejectedRecitations ?? 0,
                                tr('rejected')),
                          ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  statistics(int amount, String title) => Column(
        children: [
          Text(
            amount.toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.headTextColor),
          ),
          Text(
            translate(title),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.headTextColor),
          ),
        ],
      );
}

class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('ID') + ': ' + user.id!.toString(),
            style: TextStyle(
              color: AppColor.headTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user.username,
            style: TextStyle(
              color: AppColor.headTextColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.person),
              Text(SplashCubit.teacher?.teacherProfile?.fullName ?? ''),
            ],
          ),

          const SizedBox(height: 4),

          if (user.bio != null && user.bio!.isNotEmpty) Text(user.bio ?? ''),
          Row(
            children: [
              const Icon(Icons.attach_file),
              Text(
                user.email,
                style: const TextStyle(color: Colors.blueAccent),
              )
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // if ()
              iconedData(Icons.calendar_month, user.birthdate ?? ''),
              iconedData(Icons.equalizer, user.level!),
              iconedData(Icons.phone, user.phone ?? ''),
            ],
          )
        ],
      ),
    );
  }

  iconedData(IconData icon, String text) => Container(
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColor.txtColor4,
            ),
            Text(
              text,
              style: const TextStyle(color: AppColor.txtColor4),
            ),
          ],
        ),
      );
}

class ProfileFooter extends StatefulWidget {
  const ProfileFooter({super.key, this.user});
  final User? user;

  @override
  State<ProfileFooter> createState() => _ProfileFooterState();
}

class _ProfileFooterState extends State<ProfileFooter> {
  int playedIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<Recitation> recitations =
        ProfilePageCubit.get(context).recitations ?? [];
    return Expanded(
        child: recitations.isEmpty
            ? Center(
                child: Text(
                  translate('no_recitations'),
                  style: TextStyle(
                    color: AppColor.headTextColor,
                    fontSize: 20,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: recitations.length,
                itemBuilder: (context, index) => RecitationItem(
                  recitation: recitations[index],
                  hasMenu: true,
                  id: recitations[index].id ?? 0,
                  // onLongPress: () => _onLongPressItem(index, recitations),
                  isRead: false,
                  // recordPath: recitations[index].record != null
                  //     ? recitations[index].record!.record
                  //     : '',
                  // wavePath: recitations.records?.first.wave,
                  ayah: recitations[index].name ?? '',
                  // ayahInfo: _getAyahInfo(recitations),
                  userName: recitations[index].owner!.fullname,
                  dateStr: (recitations[index].createdAt != null)
                      ? DateFormat('hh:mm dd MMM').format(
                          DateTime.parse(recitations[index].createdAt ?? ''))
                      : '',
                  color: AppColor.transparent,
                  isPlay: playedIndex == index,
                  toggelPlay: () {
                    setState(() {
                      playedIndex = index;
                    });
                  },
                  owner: recitations[index].owner,
                  onPress: () {
                    //  Get.to(RecitationDetailsPage(recitationId: recitations.id ?? 0));
                  },
                ),
              ));
  }

  commingSoon(context) => Center(
        child: Text(
          tr('comming_soon'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
}
