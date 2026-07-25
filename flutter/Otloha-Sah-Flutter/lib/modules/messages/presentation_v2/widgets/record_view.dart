import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/utils/themes/text_style.dart';
import '../../../audio/presentation/play_pause.dart';
import '../../business_logic_v2/cubit/record_cubit.dart';
import '../../business_logic_v2/cubit/record_state.dart';

class RecordingView extends StatefulWidget {
  const RecordingView({
    Key? key,
    required this.onStop,
    required this.hasCancel,
    this.onCancelRecord,
  }) : super(key: key);
  final Function onStop;
  final Function? onCancelRecord;
  final bool hasCancel;

  @override
  State<RecordingView> createState() => _RecordingViewState();
}

class _RecordingViewState extends State<RecordingView> {
  @override
  void initState() {
    RecordCubit.get(context).setOnStop(widget.onStop);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordCubit, RecordState>(
      builder: (context, state) {
        print('record state $state');
        if (state is RecordingState) {
          return GestureDetector(
            onTap: () async {
              await RecordCubit.get(context).stopRecord();
            },
            child: Column(
              children: [
                const Icon(
                  Icons.stop,
                  size: 20,
                  color: AppColor.txtColor5,
                ),
                Text(
                  RecordCubit.get(context).timer,
                  style: AppStyle().textStyle1.copyWith(
                        fontSize: 12,
                        color: AppColor.txtColor5,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        } else if (state is PauseRecordState ||
            state is PlayRecordedFileState ||
            state is PauseRecordedFileState) {
          return Row(
            children: [
              ActionAudioIcon(
                iconWidget: PlayPause(
                  isPlay: state is PlayRecordedFileState,
                  color: state is PlayRecordedFileState
                      ? AppColor.background
                      : AppColor.headTextColor,
                  size: 20,
                  playPauseAction: RecordCubit.get(context).playPauseAction,
                ),
                colorBack: state is PlayRecordedFileState
                    ? AppColor.headTextColor
                    : AppColor.background,
                colorText: state is PlayRecordedFileState
                    ? AppColor.background
                    : AppColor.headTextColor,
              ),
              ActionAudioIcon(
                icon: AppIcons.mic,
                colorBack: AppColor.headTextColor,
                colorText: AppColor.background,
                action: () {
                  if (state is! InitiateRecordingState) {
                    RecordCubit.get(context).startRecord(context);
                  }
                },
              ),
              if (widget.hasCancel)
                ActionAudioIcon(
                  iconWidget: Icon(
                    Icons.clear,
                    size: 16,
                    color: AppColor.headTextColor,
                  ),
                  colorBack: Colors.white,
                  colorText: AppColor.background,
                  action: () async {
                    widget.onCancelRecord?.call();
                    await RecordCubit.get(context).reset();
                  },
                ),
            ],
          );
        }

        return ActionAudioIcon(
          icon: AppIcons.mic,
          colorBack: AppColor.headTextColor,
          colorText: AppColor.background,
          action: () {
            RecordCubit.get(context).startRecord(context);
          },
        );
      },
    );
  }
}

class ActionAudioIcon extends StatelessWidget {
  const ActionAudioIcon({
    Key? key,
    this.icon,
    this.iconWidget,
    this.action,
    required this.colorText,
    required this.colorBack,
  }) : super(key: key);

  final String? icon;
  final Widget? iconWidget;
  final Color colorText;
  final Color colorBack;
  final Function()? action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        width: 28,
        height: 28,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: colorBack,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColor.headTextColor,
            width: 1,
          ),
        ),
        child: Center(
          child: iconWidget ??
              Image.asset(
                icon!,
                width: 16,
                height: 16,
                color: colorText,
              ),
        ),
      ),
    );
  }
}
