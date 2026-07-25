import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otloha_sah_flutter/modules/profile/business_logic/register_as_teacher/register_as_teacher_cubit.dart';
import 'package:quran_widget_flutter/model/narration.dart';
import '../../../../core/utils/themes/color.dart';

class SelectedNarrationElement extends StatelessWidget {
  const SelectedNarrationElement({
    super.key,
    required this.name,
    required this.file,
    required this.narration,
  });

  final String name;
  final String? file;
  final Narration narration;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColor.txtGrayColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (file != null && file!.isNotEmpty)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      file!.split('/').last,
                      style: const TextStyle(
                        color: AppColor.txtGrey,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
            // GestureDetector(
            //   onTap: () {
            //     TeacherRegistrationCubit.cubit(context)
            //         .removeNarration(narration);
            //   },
            //   child: const Icon(
            //     Icons.cancel_outlined,
            //   ),
            // ),
            // SizedBox(
            //   width: 80,
            //   height: 30,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColor.lightGrey,
            //       elevation: 0,
            //     ),
            //     onPressed: () {},
            //     child: const Text(
            //       'Edit',
            //       style: TextStyle(color: AppColor.txtGrayColor),
            //     ),
            //   ),
            // ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
