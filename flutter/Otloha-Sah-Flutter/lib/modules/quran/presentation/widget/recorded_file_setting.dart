import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/alert_dialog_full_screen.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../data_source/user_services_data.dart';
import '../../../recitations/business_logic/cubit/popup_action_cubit.dart';
import '../../../recitations/presentation/widget/popup_recitation.dart';
import '../../business_logic/cubit/quran_cubit.dart';
import '../../business_logic/cubit/recitation_cubit.dart';

class RecordedFileTool extends StatefulWidget {
  const RecordedFileTool({super.key});

  @override
  State<RecordedFileTool> createState() => _RecordedFileToolState();
}

class _RecordedFileToolState extends State<RecordedFileTool> {
  final sizeIcon = 24.0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuranViewCubit, QuranViewState>(
      listener: (context, state) {
        // TO DO: implement listener
      },
      builder: (context, state) {
        var cubit = QuranViewCubit.get(context);
        var cubitRecitation = RecitationAddCubit.get(context);
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            width: MediaQuery.of(context).size.width / 1.3,
            alignment: Alignment.center,
            height: 45,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 5.0)
              ],
              gradient: toolBarGradient,
              color: Colors.deepPurple.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BlocConsumer<RecitationAddCubit, RecitationAddState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        cubitRecitation.onPlayAudio();
                      },
                      child: Image.asset(
                        cubitRecitation.isPlaying
                            ? AppIcons.pauseIcon
                            : AppIcons.playIcon,
                        color: AppColor.white,
                        height: sizeIcon,
                        width: sizeIcon,
                      ),
                    );
                  },
                ),
                GestureDetector(
                    onTap: () async {
                      await cubitRecitation.init(
                          context, cubit.changeIsRecordedFile);
                      cubit.changeIsRecorded();

                      // if (await RecordServiceApp.isHasPermission(context)) {
                      //   await cubitRecitation.init(context);
                      //   cubit.changeIsRecorded();
                      //   cubitRecitation.start(cubit.changeIsRecordedFile);
                      // }
                    },
                    child: Icon(
                      Icons.mic_none,
                      color: AppColor.white,
                      size: sizeIcon,
                    )),
                GestureDetector(
                  onTap: () async {
                    showLoader(context);
                    cubit.showLoader();
                    await cubitRecitation.saveRecitation();

                    cubit.changeIsOnTruePressed();

                    hideLoader();
                    await Get.dialog(const AlertDialogFullScreen());

                    // Get.to(RecitationDetailsPage(recitationId: recitation));
                  },
                  child: SvgPicture.asset(
                    AppSVG.save,
                    color: AppColor.white,
                    width: sizeIcon,
                    height: sizeIcon,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    cubitRecitation.stop(() {});
                    cubit.changeIsOnTruePressed();

                    cubit.changeIsOnFalsePressed();
                  },
                  child: SvgPicture.asset(
                    AppSVG.deleteRecord,
                    color: AppColor.white,
                    width: sizeIcon,
                    height: sizeIcon,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var popUpCubit =
                        BlocProvider.of<PopupActionsCubit>(context);
                    dynamic userRecitation;

                    try {
                      // showLoader(context);
                      // cubit.showLoader();
                      userRecitation = await cubitRecitation.saveRecitation();

                      Get.bottomSheet(
                        PopupRecitation(
                          isOwner: true,
                          isTeacher: UserDataServices.instance.isATeacher,
                          isLocal: false,
                          actions: const [
                            // PopupActions.delete,
                            PopupActions.addToGeneral,
                            PopupActions.send,
                            PopupActions.markAsFinished,
                            // PopupActions.updateRecitation,
                          ],
                          recitationId: userRecitation.id,
                          userRecitation: userRecitation,
                          userId:
                              UserDataServices.instance.getUserDataFast()!.id,
                          isFinished: true,
                          showInGeneral: false,
                          onAddToGeneral: (recitation) async {
                            // setState(() {});
                          },
                          onSendToTeacher: (recitation) {
                            Get.back();
                          },
                          delete: () async {
                            await popUpCubit.deleteRecitations(
                                id: userRecitation.id!, isLocal: false);
                          },
                        ),
                      );
                      // await TeacherSendCubit.get(context).sendTeacher(id);

                      cubit.changeIsOnTruePressed();
                      Get.dialog(const AlertDialogFullScreen());
                    } on InvalidData catch (e) {
                      Fluttertoast.showToast(
                        msg: e.errors!['non_field_errors'][0],
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                    // catch (e) {
                    //   print(e);
                    //   Fluttertoast.showToast(
                    //     msg: 'error occured',
                    //     backgroundColor: Colors.red,
                    //     textColor: Colors.white,
                    //   );
                    // }
                  },
                  child: Image.asset(
                    AppIcons.shareIcon,
                    color: AppColor.white,
                    width: sizeIcon,
                    height: sizeIcon,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
