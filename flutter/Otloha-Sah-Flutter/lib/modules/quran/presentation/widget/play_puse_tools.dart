import 'package:flutter/material.dart';
import 'package:quran_widget_flutter/audio/service/audio_service.dart';
import 'package:quran_widget_flutter/audio/service/player_service.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/svg_app.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/themes/color.dart';
import '../../business_logic/cubit/quran_cubit.dart';
import '../../business_logic/cubit/quranplayer_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayPauseTools extends StatefulWidget {
  const PlayPauseTools({Key? key}) : super(key: key);

  @override
  State<PlayPauseTools> createState() => _PlayPauseToolsState();
}

class _PlayPauseToolsState extends State<PlayPauseTools> {
  @override
  void initState() {
    //BlocProvider.of<QuranPlayerCubit>(context).initRecitationVerses(5);
    super.initState();
  }

  @override
  void dispose() {
    PlayerServiceApp.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuranPlayerCubit, QuranPlayerState>(
        listener: (context, state) {},
        builder: (context, state) {
          print('mode');
          var cubit = QuranPlayerCubit.get(context);
          var cubitView = QuranViewCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: 250,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => cubit.onPrevious(),
                        child: const Icon(
                          Icons.skip_next,
                          color: AppColor.white,
                          size: 30,
                        ),
                      ),
                      (state is InitialLoadingPlayerState)
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: AppColor.white,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                if (!cubit.isPlaying) {
                                  cubit.playVerses();
                                } else {
                                  cubit.pausePlayer();
                                }
                              },
                              child: SvgPicture.asset(
                                  !cubit.isPlaying ? AppSVG.play : AppSVG.pause,
                                  color: AppColor.white,
                                  width: 30)),
                      GestureDetector(
                        onTap: () {
                          cubit.stopPlayer();
                          cubitView.changeIsOnFalsePressed();
                        },
                        child: SvgPicture.asset(
                          AppSVG.deleteRecord,
                          color: AppColor.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => cubit.onNext(),
                        child: const Icon(
                          Icons.skip_previous,
                          color: AppColor.white,
                          size: 30,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => cubit.setRepeatMode(),
                        child: Icon(
                          cubit.audioServiceRepeatMode ==
                                  AudioServiceRepeatMode.none
                              ? Icons.repeat
                              : cubit.audioServiceRepeatMode ==
                                      AudioServiceRepeatMode.one
                                  ? Icons.repeat_one
                                  : Icons.repeat,
                          color: cubit.audioServiceRepeatMode ==
                                  AudioServiceRepeatMode.none
                              ? AppColor.white
                              : AppColor.lightYellow,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }
}
