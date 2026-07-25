import 'package:flutter/material.dart';

CustomPaint paintPoint(Offset offset1,Offset offset2,VoidCallback onPress , VoidCallback onLongPress) {
  return CustomPaint(
    child: GestureDetector(onTap: () {
      print('On Tap Done');
    },
      onLongPress: () {
        print('On Long Tap Done');
      },),
    /// size:  Size(100,20),
    painter: OpenPainter(offset2: offset2, offset1: offset1),
  );
}


class OpenPainter extends CustomPainter {
  final Offset offset1;
  final Offset offset2;

  // final Size size;

  OpenPainter( {required this.offset1,required this.offset2,});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.yellow.withOpacity(.5)
      ..style = PaintingStyle.stroke..strokeWidth=30;
    //canvas.drawRect(offset &  size, paint1);
    canvas.drawLine(offset1, offset2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}
