import 'package:flutter/material.dart';

class KhatmaCommingSoonPage extends StatelessWidget {
  const KhatmaCommingSoonPage({Key? key}) : super(key: key);

  static const String routeName = '/Khatma_comming_soon';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            'خدمة الختمة القرآنية تتيح للمستخدم إمكانية ختمة القرآن ومشاركتها مع الآخرين بأسلوب جديد .. سيتم اطلاقها قريباً ان شاء الله',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
