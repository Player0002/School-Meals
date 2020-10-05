import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_food/model/meals_model.dart';

class BarGraphImage extends StatefulWidget {
  final double height;
  final Key key;
  final MealsDataModel meal;
  BarGraphImage({this.height, this.key, this.meal}) : super(key: key);
  @override
  _BarGraphImageState createState() => _BarGraphImageState();
}

class _BarGraphImageState extends State<BarGraphImage>
    with SingleTickerProviderStateMixin {
  ui.Image image1;
  ui.Image image2;
  ui.Image image3;
  double tan = 2600, dan = 20, gi = 31;

  double fraction = 0;
  Animation<double> animation;
  AnimationController controller;
  @override
  void initState() {
    final datas = widget.meal.NTR;
    tan = double.parse(datas[0].split(" : ")[1]);
    dan = double.parse(datas[1].split(" : ")[1]);
    gi = double.parse(datas[2].split(" : ")[1]);
    _loadImage();
    controller = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          fraction = animation.value;
        });
      });
    super.initState();
  }

  _loadImage() async {
    ByteData bd = await rootBundle.load("assets/tan.png");
    ByteData danbd = await rootBundle.load("assets/dan.png");
    ByteData gibd = await rootBundle.load("assets/gi.png");

    final Uint8List bytes = Uint8List.view(bd.buffer);
    final Uint8List danby = Uint8List.view(danbd.buffer);
    final Uint8List giby = Uint8List.view(gibd.buffer);

    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.Codec codec2 = await ui.instantiateImageCodec(danby);
    final ui.Codec codec3 = await ui.instantiateImageCodec(giby);

    image1 = (await codec.getNextFrame()).image;
    image2 = (await codec2.getNextFrame()).image;
    image3 = (await codec3.getNextFrame()).image;

    setState(() {
      controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BarGraph(
          first: image1,
          second: image2,
          third: image3,
          tan: tan,
          dan: dan,
          gi: gi,
          height: widget.height,
          fraction: fraction),
    );
  }
}

class BarGraph extends CustomPainter {
  final maxTan = 460;
  final maxDan = 60;
  final maxGi = 72;

  final tan, dan, gi;
  final height;
  final ui.Image first;
  final ui.Image second, third;
  final double fraction;
  BarGraph(
      {this.fraction,
      this.height,
      this.first,
      this.second,
      this.third,
      this.tan,
      this.dan,
      this.gi});
  double rad(double angle) => pi / 180 * angle;

  @override
  void paint(Canvas canvas, Size size) {
    if (first == null || second == null || third == null) return;

    Offset center = Offset(size.width / 2, size.height / 2);
    final firstStick = Offset(size.width / 4, 0).translate(-10, 0);
    final secondStick = Offset(size.width / 2, 0);
    final thirdStick = Offset(size.width - size.width / 4, 0).translate(10, 0);
    Paint paint = Paint()
      ..color = Color(0xFFDFE5EB)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.square;
    Rect firstBar = Rect.fromPoints(
      firstStick.translate(-26, 0),
      firstStick.translate(26, height),
    );
    Rect secondBar = Rect.fromPoints(
      secondStick.translate(-26, 0),
      secondStick.translate(26, height),
    );
    Rect thirdBar = Rect.fromPoints(
      thirdStick.translate(-26, 0),
      thirdStick.translate(26, height),
    );
    canvas.drawRect(firstBar, paint);
    canvas.drawRect(secondBar, paint);
    canvas.drawRect(thirdBar, paint);
    // canvas.drawLine(secondStick, secondStick.translate(0, size.height), paint);
    // canvas.drawLine(thirdStick, thirdStick.translate(0, size.height), paint);

    canvas.drawImage(first, firstStick.translate(-25, height + 10), paint);
    canvas.drawImage(second, secondStick.translate(-25, height + 10), paint);
    canvas.drawImage(third, thirdStick.translate(-25, height + 10), paint);

    double tanCal = (height -
        ((tan > maxTan ? maxTan : tan) / maxTan) * (height * fraction));
    print(tanCal);
    double danCal = (height -
        ((dan > maxDan ? maxDan : dan) / maxDan) * (height * fraction));
    double giCal =
        (height - ((gi > maxGi ? maxGi : gi) / maxGi) * (height * fraction));
    bool tanOver = false;
    bool danOver = false;
    bool giOver = false;
    if (tanCal < 0) {
      tanCal = 0;
      tanOver = true;
    }
    if (danCal < 0) {
      danCal = 0;
      danOver = true;
    }
    if (giCal < 0) {
      giCal = 0;
      giOver = true;
    }
    Gradient firstGrad = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFF9B00), Color(0xFFFF6B00)],
        stops: [0.2, 0.8]);

    Rect valueFirst = Rect.fromPoints(
      firstStick.translate(-26, height),
      firstStick.translate(26, tanCal),
    );
    paint..shader = firstGrad.createShader(firstBar);
    canvas.drawRect(valueFirst, paint);

    Gradient secondGrad = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE13741), Color(0xFFF15741)],
        stops: [0.2, 0.8]);

    Rect valueSecond = Rect.fromPoints(
      secondStick.translate(-26, height),
      secondStick.translate(26, danCal),
    );
    paint..shader = secondGrad.createShader(secondBar);
    canvas.drawRect(valueSecond, paint);

    Gradient thirdGrad = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFFE11C), Color(0xFFFFC11C)],
        stops: [0.2, 0.8]);

    Rect valueThird = Rect.fromPoints(
      thirdStick.translate(-26, height),
      thirdStick.translate(26, giCal),
    );
    paint..shader = thirdGrad.createShader(thirdBar);
    canvas.drawRect(valueThird, paint);

    //canvas.drawRect(r, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
