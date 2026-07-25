import 'package:easy_localization/easy_localization.dart' as local;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:otloha_sah_flutter/data_source/models/tajweed/tajweed_level.dart';
import 'package:otloha_sah_flutter/modules/tajweed/business_logic/level_card_cubit/level_card_cubit.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/reserved_exams_listing.dart';
import 'package:otloha_sah_flutter/modules/tajweed/presentation/pages/time_slot_listing.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.level,
  });
  final TajweedLevel level;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          Center(
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff009EC0),
              ),
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/svg/card_background.svg',
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                        Color(0xff19a7c5), BlendMode.srcIn),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level.name.translate() ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        if (context.read<LevelCardCubit>().state
                            is LevelCardSelected)
                          Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 120,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, TimeSlotsListingPage.route);
                                  },
                                  clipBehavior: Clip.hardEdge,
                                  child: Text(
                                    local.tr('Take exam'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              SizedBox(
                                height: 30,
                                width: 120,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ReservedExamsListing.route);
                                  },
                                  clipBehavior: Clip.hardEdge,
                                  child: Text(
                                    local.tr('My Exams'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: Directionality.of(context) == TextDirection.ltr
                ? MediaQuery.of(context).size.width - 150
                : 0,
            right: Directionality.of(context) == TextDirection.ltr ? 0 : 260,
            child: Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff009EC0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff007089),
                      ),
                      child: Center(
                        child: Container(
                          height: 74,
                          width: 74,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff009EC0),
                          ),
                          child: CircularPercentIndicator(
                            radius: 37.0,
                            lineWidth: 10.0,
                            percent: level.completed / 100,
                            center: Text(
                              '${(level.completed).ceil()}%',
                              style: const TextStyle(
                                color: Color(0xffFAC700),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            progressColor: const Color(0xffFAC700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
