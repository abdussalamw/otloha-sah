import 'package:flutter/material.dart';
import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/themes/color.dart';
import '../../../../core/widgets/text_view.dart';
import '../../business_logic/narration/changenarration_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:quran_widget_flutter/model/narration.dart';

class ChangeNarrtionPopup extends StatelessWidget {
  const ChangeNarrtionPopup({Key? key, required this.narration})
      : super(key: key);

  final Narration narration;

  @override
  Widget build(BuildContext context) {
    ChangenarrationCubit.get(context).getChange(narration);
    return BlocConsumer<ChangenarrationCubit, ChangenarrationState>(
      listener: (context, state) {
        if (state is ChangenarrationSuccess) {
          Get.back();
        }
      },
      builder: (context, state) {
        return Center(
          child: Card(
            color: AppColor.white.withOpacity(.0),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getPrograss(),
                  const SizedBox(height: 32),
                  SizedBox(
                    child: TextView(
                      text: translate('change_narration'),
                      sizeText: 18,
                      colorText: AppColor.txtColor3,
                      weightText: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  getPrograss() {
    var progress = 0.0;
    return (progress > 0)
        ? CircularProgressIndicator(
            value: progress,
          )
        : const CircularProgressIndicator();
  }
}
