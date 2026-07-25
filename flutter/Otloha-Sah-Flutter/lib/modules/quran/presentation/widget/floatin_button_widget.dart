import 'package:flutter/material.dart';
import '../../business_logic/cubit/ballview_cubit.dart';
import 'float_menu_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../core/utils/themes/color.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    BallViewCubit cubit = BallViewCubit.get(context);
    return BlocBuilder<BallViewCubit, BallViewState>(
      builder: (context, state) {
        if (state is BallViewMenu && !cubit.isOpen) {
          Future.microtask(() {
            Get.dialog(const FloatingMenu());
          }).then((value) {
            cubit.setIsOpen(false);
          });
          cubit.setIsOpen(true);
        }
        double op = 0;

        if (state is BallFullOpcity) {
          op = 1;
        }

        if (state is BallHafeOpcity) {
          op = .5;
        }

        if (state is BallHideOpcity) {
          op = 0;
        }

        return _viewBall(cubit, op);
      },
    );
  }

  Positioned _viewBall(BallViewCubit cubit, double op) {
    return Positioned(
      bottom: 50,
      right: 20,
      child: Opacity(
        opacity: op,
        child: GestureDetector(
          onTap: () async {
            cubit.viewMenu();
          },
          child: ball(),
        ),
      ),
    );
  }

  ball() {
    return const CircleAvatar(
      radius: 30,
      backgroundColor: AppColor.darkBlue,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: AppColor.lightBlue,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: AppColor.darkBlue,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: AppColor.lightBlue,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: AppColor.darkBlue,
            ),
          ),
        ),
      ),
    );
  }
}
