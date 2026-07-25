import 'package:flutter/material.dart';
import '../utils/themes/color.dart';

class Indicator extends StatelessWidget {
  final int size;
  final int current;

  const Indicator({super.key, required this.size, required this.current});

  @override
  Widget build(BuildContext context) {
    var list = Iterable<int>.generate(size).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list.map((item) => itemIndicator(item == current)).toList(),
    );
  }

  Widget itemIndicator(bool isActive) {
    return isActive
        ? Container(
            margin: const EdgeInsets.all(2),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColor.txtColor3,
              borderRadius: BorderRadius.circular(4),
            ),
          )
        : Container(
            margin: const EdgeInsets.all(2),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          );
  }
}
