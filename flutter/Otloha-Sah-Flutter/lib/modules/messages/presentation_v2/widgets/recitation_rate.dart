import 'package:flutter/material.dart';

class RecitationRate extends StatelessWidget {
  const RecitationRate({Key? key, required this.rate}) : super(key: key);
  final String rate;
  @override
  Widget build(BuildContext context) {
    Color color;
    if (rate == '1') {
      color = Colors.red;
    } else if (rate == '2') {
      color = Colors.orange;
    } else if (rate == '3') {
      color = Colors.yellow;
    } else if (rate == '4') {
      color = Colors.green;
    } else {
      color = Colors.blue;
    }
    return Row(
      children: [
        Icon(Icons.star, color: color, size: 15,),
        Text(rate),
      ],
    );
  }
}
