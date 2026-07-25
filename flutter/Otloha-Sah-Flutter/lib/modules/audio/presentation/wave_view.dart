import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otloha_sah_flutter/core/resources/color_manager.dart';
import 'package:otloha_sah_flutter/core/utils/res/icons_app.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/data_source/models/record/record.dart';
import 'package:otloha_sah_flutter/modules/audio/business_logic/cubit/player_cubit.dart';
import 'package:otloha_sah_flutter/modules/audio/business_logic/playback_manager.dart';

import 'play_pause.dart';

class WaveViewPlayAudio extends StatefulWidget {
  final Function()? toggelPlay;
  final bool isPlay;
  final Record? record;
  final String wavePath;
  final double? right;
  final String? localFilePath;
  final Function()? onStop;

  const WaveViewPlayAudio({
    super.key,
    this.toggelPlay,
    required this.isPlay,
    this.record,
    required this.wavePath,
    this.localFilePath,
    this.right,
    this.onStop,
  });

  @override
  State<WaveViewPlayAudio> createState() => _WaveViewPlayAudioState();
}

class _WaveViewPlayAudioState extends State<WaveViewPlayAudio> {
  final playerController = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: BlocProvider(
        create: (context) => AudioPlayerCubit(
            widget.record,
            widget.localFilePath,
            context.read<PlaybackManagerCubit>(),
            playerController),
        child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
          builder: (context, state) {
            Widget button;
            if (state is AudioPlayerLoading ||
                state is AudioPlayerDownloading) {
              button = const CircularProgressIndicator();
            } else if (state is AudioPlayerError) {
              button = Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    child: const Icon(Icons.download),
                    onTap: () {
                      context.read<AudioPlayerCubit>().downloadFile();
                    },
                  ),
                ),
              );
            } else {
              button = PlayPause(
                isPlay: state is AudioPlayerPlaying,
                playPauseAction: () {
                  if (state is AudioPlayerPlaying) {
                    context.read<AudioPlayerCubit>().pause();
                  } else if (state is AudioPlayerReady ||
                      state is AudioPlayerStopped) {
                    context.read<AudioPlayerCubit>().play();
                  }
                  widget.toggelPlay?.call();
                },
              );
            }

            return Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 10),
                          child: button,
                        ),
                        if (state is AudioPlayerError)
                          Expanded(
                            flex: 20,
                            child: Image.asset(
                              AppIcons.wave,
                              height: 48,
                              color: AppColor.grey,
                            ),
                          )
                        else
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: PlayerWidget(player: playerController),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;

  const PlayerWidget({
    required this.player,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => widget.player;

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
          }),
        );
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        child: StreamBuilder<Duration>(
          stream: player.onPositionChanged,
          builder: (context, snapshot) {
            final durationState = snapshot.data;
            final progress = durationState ?? Duration.zero;
            final total = _duration ?? Duration.zero;
            return ProgressBar(
              progress: progress,
              total: total,
              onSeek: (duration) {
                player.seek(duration);
              },
              timeLabelTextStyle: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: ColorManager.lightGrey),
            );
          },
        ),
      ),
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }
}
