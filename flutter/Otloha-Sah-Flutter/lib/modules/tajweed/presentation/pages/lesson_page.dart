import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:otloha_sah_flutter/core/network/api_base_helper.dart';
import 'package:otloha_sah_flutter/core/pagination/view/pagination_view.dart';
import 'package:otloha_sah_flutter/core/utils/themes/color.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_lesson.dart';
import 'package:otloha_sah_flutter/modules/audio/presentation/wave_view.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/lesson_cubit/lesson_cubit_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/widgets/tajweed_lesson_card.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.lesson});
  static const String routeName = 'lesson_page';
  final TajweedLesson lesson;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  @override
  void initState() {
    context.read<LessonCubit>().fetchLesson(widget.lesson.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title.translate() ?? 'Lesson'),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: BlocBuilder<LessonCubit, LessonCubitState>(
                builder: (context, state) {
                  if (state is LessonCubitLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LessonCubitError) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is LessonCubitSuccess) {
                    final lesson = state.lesson;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            child: BookmarkWidget(
                              icon: Icons.bookmark_border_outlined,
                              text: lesson.title.translate() ?? '',
                              iconSize: 30.0,
                            ),
                          ),
                          Html(data: lesson.content.translate() ?? ''),
                          ...lesson.videoUrls.map((video) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: BookmarkWidget(
                                    icon: Icons.bookmark_border_outlined,
                                    text: tr('Sample Video'),
                                    iconSize: 30.0,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                YouTubePlayerWidget(url: video['url'] ?? ''),
                                const SizedBox(height: 16),
                              ],
                            );
                          }),
                          SizedBox(
                            width: 200,
                            child: BookmarkWidget(
                              icon: Icons.bookmark_border_outlined,
                              text: tr('Example'),
                              iconSize: 30.0,
                            ),
                          ),
                          ...lesson.lessonExamples.map((example) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  example.title.translate() ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        example.verseText,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Hafs20',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // WaveViewPlayAudio(
                                      //   toggelPlay: () {},
                                      //   isPlay: false,
                                      //   record: example.record,
                                      //   wavePath: '',
                                      // ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('No data available'));
                },
              ),
            ),
          ];
        },
        body: PaginationData<TajweedLesson>(
          initData: const [],
          getData: (next) {
            return ApiBaseHelper().getHTTP(
              '/api/v1/tajweed/lessons/${widget.lesson.id}/sub-lessons/',
              dioTypes: DioTypes.authRequired,
            );
          },
          drowItem: (lesson, idx) => TajweedLessonCard(
            tajweedLesson: lesson,
          ),
          pagingController:
              PagingController<int, TajweedLesson>(firstPageKey: 1),
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  const VideoPlayerWidget({super.key, required this.url});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse('https://www.youtube.com/watch?v=fHRn7KPYeLY'))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const Center(child: CircularProgressIndicator()),
        const SizedBox(height: 8),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ],
    );
  }
}

class YouTubePlayerWidget extends StatefulWidget {
  final String url;

  const YouTubePlayerWidget({super.key, required this.url});

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: YoutubePlayerController.convertUrlToId(widget.url) ?? '',
      params: const YoutubePlayerParams(
        showControls: true,
        mute: false,
        showFullscreenButton: false,
        loop: false,
      ),
    );

    _controller.setFullScreenListener(
      (isFullScreen) {
        print('${isFullScreen ? 'Entered' : 'Exited'} Fullscreen.');
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      aspectRatio: 16 / 9,
    );
  }
}

class BookmarkWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color containerColor;
  final double iconSize;

  const BookmarkWidget({
    super.key,
    required this.icon,
    required this.text,
    this.containerColor = const Color(0xff8edef7), // Default color is blue
    this.iconSize = 24.0, // Default icon size is 24.0
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
          SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
