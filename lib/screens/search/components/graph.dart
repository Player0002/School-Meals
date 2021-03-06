import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_food/constants/constants.dart';
import 'package:school_food/provider/user_provider.dart';

class AnimatedKcalGraph extends StatefulWidget {
  final double value;
  final Key key;
  final bool isAll;
  final Gender humanGender;
  final double humanAge;
  AnimatedKcalGraph(
      {this.value, this.key, this.isAll, this.humanGender, this.humanAge})
      : super(key: key);
  @override
  _AnimatedKcalGraphState createState() => _AnimatedKcalGraphState();
}

class _AnimatedKcalGraphState extends State<AnimatedKcalGraph>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  double fraction = 0.0;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
    controller.forward();
    super.initState();
  }

  int getCal() {
    if (widget.humanAge <= 2)
      return 1000;
    else if (widget.humanAge <= 5)
      return 1400;
    else {
      if (widget.humanGender == Gender.MAN) {
        if (widget.humanAge <= 8)
          return 1700;
        else if (widget.humanAge <= 11)
          return 2100;
        else if (widget.humanAge <= 14)
          return 2500;
        else if (widget.humanAge <= 18)
          return 2700;
        else if (widget.humanAge <= 29)
          return 2600;
        else if (widget.humanAge <= 49)
          return 2400;
        else if (widget.humanAge <= 64)
          return 2200;
        else
          return 2000;
      } else {
        if (widget.humanAge <= 8)
          return 1500;
        else if (widget.humanAge <= 11)
          return 1800;
        else if (widget.humanAge <= 14)
          return 2000;
        else if (widget.humanAge <= 18)
          return 2000;
        else if (widget.humanAge <= 29)
          return 2100;
        else if (widget.humanAge <= 49)
          return 1900;
        else if (widget.humanAge <= 64)
          return 1800;
        else
          return 1600;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: KcalGrpah(
          fraction: fraction,
          value: widget.value,
          isAll: widget.isAll,
          maxCal: getCal().toDouble()),
    );
  }
}

class KcalGrpah extends CustomPainter {
  final double value;
  final double fraction;
  final bool isAll;
  final double maxCal;
  KcalGrpah({this.value, this.fraction, this.isAll, this.maxCal});
  double rad(double angle) => pi / 180 * angle;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFF8DA6D8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    double calculated = (value / maxCal) * 360;
    double ang = calculated > 360 ? 360 : calculated;
    double overAngle = calculated - 360;
    bool isOver = calculated > 360;
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2 - paint.strokeWidth / 2,
        size.height / 2 - paint.strokeWidth / 2);
    canvas.drawCircle(center, radius, paint);
    paint..strokeWidth = 11;
    paint..strokeCap = StrokeCap.round;
    paint..color = Color(0xFF4B75F2).withOpacity(0.3);
    Path p = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        rad(-90),
        rad(ang * fraction),
      );
    Path overedP = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        rad(-90),
        rad(overAngle * fraction),
      );
    canvas.drawPath(p, paint);
    paint..strokeWidth = 8;
    paint..color = Color(0xFF4B75F2);
    canvas.drawPath(p, paint);

    if (isOver) {
      Gradient grad = LinearGradient(
        colors: [
          Color(0xFF8B75F2),
          Color(0xFFFF75F2),
        ],
        stops: [0.2, 0.6],
        end: Alignment.bottomCenter,
        begin: Alignment.topCenter,
      );
      paint
        ..shader =
            grad.createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawPath(overedP, paint);
    }
    paint..shader = null;
    drawText(canvas, size, "${value.toInt()}\n");
  }

  void drawText(Canvas canvas, Size size, String text) {
    TextSpan sp = TextSpan(
      style: defaultFont.copyWith(
          fontWeight: FontWeight.w500, color: Color(0xFF4B75F2), fontSize: 46),
      text: text,
      children: [
        TextSpan(
          style: defaultFont.copyWith(
              fontSize: 24,
              color: Color(0xFFBFBFBF),
              fontWeight: FontWeight.w300),
          text: "Kcal\n",
          children: [
            TextSpan(
              text: isAll ? "전체 칼로리 입니다." : "개별 칼로리 입니다.",
              style: defaultFont.copyWith(
                color: Color(0xFFBFBFBF),
                fontSize: 12,
              ),
            )
          ],
        ),
      ],
    );
    TextPainter tp = TextPainter(
      text: sp,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    tp.layout();

    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;

    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
