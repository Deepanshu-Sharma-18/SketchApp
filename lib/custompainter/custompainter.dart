import 'dart:ui';

import 'package:draw/custompainter/group.dart';
import 'package:flutter/widgets.dart';

class MyCustomPainter extends CustomPainter {
  final List<GroupColor?> OffsetList;
  final Color color;
  final int stroke;

  MyCustomPainter(this.OffsetList, this.color, this.stroke);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = color
      ..isAntiAlias = true
      ..strokeWidth = stroke.toDouble();

    for (int i = 0; i < OffsetList.length - 1; i++) {
      if (OffsetList[i] != null && OffsetList[i + 1] != null) {
        paint.color = OffsetList[i]!.color;
        paint.strokeWidth = OffsetList[i]!.stroke.toDouble();
        canvas.drawLine(
            OffsetList[i]!.offset, OffsetList[i + 1]!.offset, paint);
      }
      if (OffsetList[i] != null && OffsetList[i + 1] == null) {
        paint.color = OffsetList[i]!.color;
        paint.strokeWidth = OffsetList[i]!.stroke.toDouble();
        var pointslist = <Offset>[];
        pointslist.add(OffsetList[i]!.offset);
        canvas.drawPoints(PointMode.points, pointslist, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
