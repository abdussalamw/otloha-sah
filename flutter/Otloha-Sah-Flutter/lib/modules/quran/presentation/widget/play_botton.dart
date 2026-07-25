import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/constant/utils.dart';
import '../../../../core/utils/res/svg_app.dart';
import '../../../../core/utils/themes/color.dart';
import '../../business_logic/cubit/quran_cubit.dart';
import '../../business_logic/cubit/recitation_cubit.dart';

class RecordTool extends StatelessWidget {
  const RecordTool({super.key});

  final sizeIcon = 24.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecitationAddCubit, RecitationAddState>(
      builder: (context, state) {
        return BlocConsumer<QuranViewCubit, QuranViewState>(
          listener: (context, state) {
            // TO DO: implement listener
          },
          builder: (context, state) {
            var cubit = QuranViewCubit.get(context);
            var cubitAdd = RecitationAddCubit.get(context);
            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                width: MediaQuery.of(context).size.width / 1.3,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '${cubitAdd.recordDuration?.inMinutes.remainder(60).toString().padLeft(2, '0') ?? '00'}:${cubitAdd.recordDuration?.inSeconds.remainder(60).toString().padLeft(2, '0') ?? '00'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColor.lightYellow, fontSize: 20),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          AppSVG.mic,
                          color: AppColor.lightYellow,
                          //   size: 40,
                          width: sizeIcon, height: sizeIcon,
                        )),
                    GestureDetector(
                        onTap: () {
                          cubitAdd.stop(cubit.changeIsRecordedFile);
                        },
                        child: Icon(
                          Icons.stop,
                          color: AppColor.white,
                          size: sizeIcon,
                        )),
                    GestureDetector(
                        onTap: () {
                          cubitAdd.stop(() {});
                          cubit.changeIsOnTruePressed();
                        },
                        child: SvgPicture.asset(
                          AppSVG.deleteRecord,
                          color: AppColor.white,
                          width: sizeIcon,
                          height: sizeIcon,
                        )),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
