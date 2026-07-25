import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_lesson.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/lesson_page.dart';

class TajweedLessonCard extends StatelessWidget {
  const TajweedLessonCard({
    super.key,
    required this.tajweedLesson,
  });
  final TajweedLesson tajweedLesson;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          LessonPage.routeName,
          arguments: tajweedLesson,
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 15),
        color: const Color(0xfff0fbff),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: const Color(0xff009EC0),
                ),
                child: SvgPicture.asset(
                  height: 24,
                  width: 24,
                  'assets/svg/tajweed_card_icon.svg',
                  fit: BoxFit.none,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tajweedLesson.title.translate() ?? '',
                        style: const TextStyle(
                          fontSize: 18.0,
                          height: 0.9,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      LinearProgressIndicator(
                        value: tajweedLesson.completedLessons /
                                    tajweedLesson.numberOfChildren ==
                                0
                            ? 1.0
                            : tajweedLesson.numberOfChildren.toDouble(),
                        color: const Color(0xFFFAC700),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(1)),
                      ),
                      Text(
                        '${tr('You need')} ${tajweedLesson.numberOfChildren - tajweedLesson.completedLessons} ${tr('parts to pass')}',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
