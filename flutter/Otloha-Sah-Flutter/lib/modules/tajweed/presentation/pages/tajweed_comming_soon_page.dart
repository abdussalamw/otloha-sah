import 'package:flutter/material.dart';

class TajweedCommingSoonPage extends StatelessWidget {
  const TajweedCommingSoonPage({super.key});

  static const String routeName = '/tajweed_comming_soon';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'خدمة التجويد تتيح للمستخدم الاستفادة من الدروس المتخصصة بعلم التجويد ت .. سيتم اطلاقها قريباً إن شاء الله',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
