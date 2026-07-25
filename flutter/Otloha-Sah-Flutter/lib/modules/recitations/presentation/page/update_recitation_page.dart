import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:otloha_sah_flutter/data_source/models/recitations/recitation.dart';

import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../../core/widgets/tool_bar_app.dart';
import '../../../audio/presentation/wave_view.dart';
import '../../business_logic/cubit/updaterecitation_cubit.dart';
import '../../business_logic/cubit/userrecitation_cubit.dart';

class UpdateRecitationPage extends StatelessWidget {
  final Recitation recitation;
  const UpdateRecitationPage({
    Key? key,
    required this.recitation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdateRecitationCubit(recitation),
      child: const UpdateRecitationPageProvider(),
    );
  }
}

class UpdateRecitationPageProvider extends StatelessWidget {
  const UpdateRecitationPageProvider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = UpdateRecitationCubit.get(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _topView(context),
            BlocBuilder<UpdateRecitationCubit, UpdateRecitationState>(
              builder: (context, state) {
                if (state is UserRecitationLoading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _viewAyah(cubit.ayah),
                      _waveView(cubit.recitation, cubit),
                      // _viewRecords(cubit),
                    ],
                  ),
                );
              },
            ),
            const Spacer(),
            _audioRecorder(context, cubit)
          ],
        ),
      ),
    );
  }

  _waveView(Recitation? recitation, UpdateRecitationCubit cubit) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: WaveViewPlayAudio(
          record: recitation!.record!,
          wavePath: '',
          toggelPlay: () {
            if (cubit.isRecitationRecordPlaying) {
              cubit.pauseRecitationRecord();
            } else {
              cubit.playRecitationRecord();
            }
          },
          isPlay: cubit.isRecitationRecordPlaying,
          onStop: () {
            cubit.pauseRecitationRecord();
          },
        ),
      ),
    );
  }

  _viewAyah(String? ayah) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.white,
        ),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        child: TextView(
          padding: EdgeInsets.zero,
          text: ayah ?? '',
          sizeText: 18,
          weightText: FontWeight.w900,
          colorText: AppColor.headTextColor,
          textAlign: TextAlign.start,
          fontFamily: 'Hafs17',
        ),
      ),
    );
  }

  Widget _topView(context) {
    return BlocBuilder<UpdateRecitationCubit, UpdateRecitationState>(
      builder: (context, state) {
        return ToolBarApp(
          backIcon: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          title: translate('UpdateRecitation'),
          actionIcon: IconButton(
            onPressed: UpdateRecitationCubit.get(context).recordPath == null
                ? null
                : () async {
                    await UpdateRecitationCubit.get(context)
                        .updateRecitation(context);
                    UserRecitationCubit.get(context).fetchSentRecitation(1);
                  },
            icon: const Icon(Icons.done),
          ),
        );
      },
    );
  }

  _audioRecorder(context, UpdateRecitationCubit cubit) {
    return BlocBuilder<UpdateRecitationCubit, UpdateRecitationState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cubit.recordPath == null)
              MaterialButton(
                color: AppColor.headTextColor,
                onPressed: () {
                  cubit.start(context);
                },
                child: const Icon(Icons.mic, color: AppColor.white),
              ),
            if (cubit.recordPath != null && cubit.isRecording)
              MaterialButton(
                color: AppColor.headTextColor,
                onPressed: () {
                  cubit.stop();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stop, color: AppColor.white),
                    const SizedBox(width: 8),
                    TextView(
                      text: state is ChangeDurationState
                          ? '${state.duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${state.duration.inSeconds.remainder(60).toString().padLeft(2, '0')}'
                          : '',
                      colorText: AppColor.white,
                    ),
                  ],
                ),
              ),
            if (cubit.recordPath != null && !cubit.isRecording)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    color: AppColor.headTextColor,
                    onPressed: () {
                      cubit.start(context);
                    },
                    child: const Icon(Icons.mic, color: AppColor.white),
                  ),
                  const SizedBox(width: 8),
                  MaterialButton(
                    color: AppColor.headTextColor,
                    onPressed: () {
                      cubit.isPlay ? cubit.onPauseAudio() : cubit.onPlayAudio();
                    },
                    child: Icon(cubit.isPlay ? Icons.pause : Icons.play_arrow,
                        color: AppColor.white),
                  ),
                ],
              ),
          ],
        );
      },
    );
  }

  // _viewRecords(UpdateRecitationCubit cubit) {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       padding: const EdgeInsets.symmetric(horizontal: 8),
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         return Card(
  //           child: ListTile(
  //             trailing: IconButton(
  //               onPressed: () {
  //                 cubit.deleteRecord(index);
  //               },
  //               icon: const Icon(Icons.delete),
  //             ),
  //             title: WaveViewPlayAudio(
  //               toggelPlay: () {
  //                 cubit.setPlaying(index);
  //               },
  //               isPlay: index == cubit.isPlaying,
  //               recordPath: cubit.recitationsUpdate[index].record,
  //               wavePath: cubit.recitationsUpdate[index].wave,
  //               isLocal: true,
  //             ),
  //           ),
  //         );
  //       },
  //       itemCount: cubit.recitationsUpdate.length);
  // }
}
