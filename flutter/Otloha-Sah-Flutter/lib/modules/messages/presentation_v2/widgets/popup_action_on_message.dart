import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:otloha_sah_flutter/core/widgets/loader.dart';
import 'package:otloha_sah_flutter/modules/messages/business_logic_v2/cubit/rooms_cubit.dart';

import '../../../../core/utils/res/icons_app.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../business_logic_v2/cubit/message_details_cubit.dart';
import '../pages/chating_page.dart';
import '../pages/evaluation_page.dart';

class PopupActionOnMessage extends StatelessWidget {
  const PopupActionOnMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupView(
      child: BlocBuilder<MessageDetailsCubit, MessageDetailsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const MarkView(),
              RatingBar(
                initialRating: 0,
                itemCount: 5,
                onRatingUpdate: (rating) {
                  MessageDetailsCubit.get(context).setRate(rating);
                },
                itemSize: 50,
                ratingWidget: RatingWidget(
                  full: const Icon(
                    Icons.star,
                    color: Color(0xffFAC700),
                  ),
                  half: const Icon(
                    Icons.star_half,
                    color: Color(0xffFAC700),
                  ),
                  empty: const Icon(
                    Icons.star_border_outlined,
                    color: Color(0xffFAC700),
                  ),
                ),
              ),
              BlocConsumer<MessageDetailsCubit, MessageDetailsState>(
                listener: (context, state) {
                  if (state is ActionOnMessageFinishDoneState) {
                    // ChatCubit.get(context)
                    //     .setMessage(MessageDetailsCubit.get(context).messages);
                    Navigator.pop(context);
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatingPage(
                          room: MessageDetailsCubit.get(context).room!.copyWith(
                                recitation: MessageDetailsCubit.get(context)
                                    .room!
                                    .recitation!
                                    .copyWith(
                                        evaluatedAt: DateTime.now().toString()),
                              ),
                        ),
                      ),
                    );
                    RoomsCubit.get(context).getRooms(withLoading: false);
                  }
                },
                builder: (context, state) {
                  if (state is ActionOnMessagLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ButtonApp(
                    title: 'send_evaluation'.tr(),
                    onPress: () {
                      MessageDetailsCubit.get(context).finishEvaluation();
                    },
                  );
                },
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
        },
      ),
    );
  }
}

class PopupView extends StatelessWidget {
  const PopupView({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: AppColor.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          const TopViewWithBack(),
          BodyViewOfPopup(
            child: child,
          ),
        ],
      ),
    );
  }
}

class BodyViewOfPopup extends StatelessWidget {
  const BodyViewOfPopup({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppColor.background,
        ),
        child: child,
      ),
    );
  }
}

class TopViewWithBack extends StatelessWidget {
  const TopViewWithBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: GestureDetector(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            image: DecorationImage(
              image: Svg(
                AppSVG.back2,
                color: AppColor.white,
              ),
              fit: BoxFit.cover,
              opacity: .08,
              repeat: ImageRepeat.noRepeat,
              scale: 2,
            ),
            color: AppColor.darkBlue,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColor.txtColor2,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MarkView extends StatelessWidget {
  const MarkView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageDetailsCubit, MessageDetailsState>(
      builder: (context, state) {
        return CheckboxListTile(
          title: Text(
            'mark_as_remarkable'.tr(),
            style: TextStyle(
              color: AppColor.headTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          value: MessageDetailsCubit.get(context).isMark,
          onChanged: (val) {
            MessageDetailsCubit.get(context).changeIsMark(isMark: val ?? false);
          },
        );
      },
    );
  }
}

class ActionView extends StatelessWidget {
  const ActionView({
    Key? key,
    required this.title,
    this.isSelected,
    this.isLikeView = true,
  }) : super(key: key);

  final String title;
  final bool? isSelected;
  final bool isLikeView;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MessageDetailsCubit.get(context).changeIsAccept(isAccept: isLikeView);
      },
      child: Container(
        width: 70,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: (isSelected ?? false)
              ? Border.all(color: AppColor.headTextColor)
              : null,
          color: AppColor.gradient4,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isLikeView
                ? Image.asset(
                    AppIcons.likeIcon,
                    width: 30,
                    height: 30,
                    color: AppColor.headTextColor,
                  )
                : Icon(
                    Icons.highlight_off,
                    size: 30,
                    color: AppColor.headTextColor,
                  ),
            Text(
              title,
              style: TextStyle(
                color: AppColor.headTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: (isSelected ?? false)
                      ? AppColor.headTextColor
                      : AppColor.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmReport extends StatelessWidget {
  const ConfirmReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupView(
      child: Center(
        child: ButtonApp(
          title: 'confirm'.tr(),
          color: AppColor.txtColor5,
          radius: 10,
          onPress: () async {
            showLoader(context);
            await MessageDetailsCubit.get(context)
                .finishEvaluation(recitationResult: 'reported');
            hideLoader();
            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ChatingPage(
                  room: MessageDetailsCubit.get(context).room!.copyWith(
                        recitation: MessageDetailsCubit.get(context)
                            .room!
                            .recitation!
                            .copyWith(evaluatedAt: DateTime.now().toString()),
                      ),
                ),
              ),
            );
            // ignore: use_build_context_synchronously
            await RoomsCubit.get(context).getRooms(withLoading: false);
          },
        ),
      ),
    );
  }
}
