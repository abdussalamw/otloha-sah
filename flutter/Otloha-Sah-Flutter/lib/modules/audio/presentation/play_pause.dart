import 'package:flutter/material.dart';
import '../../../core/utils/themes/color.dart';

class PlayPause extends StatelessWidget {
  const PlayPause({
    Key? key,
    this.playPauseAction,
    required this.isPlay,
    this.size,
    this.color,
  }) : super(key: key);

  final Function()? playPauseAction;
  final bool isPlay;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: playPauseAction,
      constraints: const BoxConstraints(),
      child: Icon(
        !isPlay ? Icons.play_arrow : Icons.pause,
        color: Colors.white,
        size: size ?? 30,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: AppColor.headTextColor,
      // padding: const EdgeInsets.all(3.0),
    );
  }
}
