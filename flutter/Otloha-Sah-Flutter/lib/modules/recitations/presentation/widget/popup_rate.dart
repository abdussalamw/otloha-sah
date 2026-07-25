import 'package:flutter/material.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../../../data_source/remote/messages_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PopupRateRecitation extends StatelessWidget {
  PopupRateRecitation({Key? key, required this.recitationId}) : super(key: key);

  final int recitationId;

  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28), topRight: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextView(
            text: translate('Rate'),
            textAlign: TextAlign.start,
            colorText: AppColor.headTextColor,
          ),
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              this.rating = rating;
            },
          ),
          ListTile(
            onTap: () async {
              await ExceptionHandling.hanleToastException(
                () async {
                  return await GetMessages()
                      .sendRateRecitations(id: recitationId, rate: rating);
                },
                'doneMessage',
                false,
              );
              Get.back();
            },
            title: TextView(
              text: translate('Save'),
              textAlign: TextAlign.start,
              colorText: AppColor.headTextColor,
            ),
            leading: Icon(
              Icons.done,
              color: AppColor.headTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
