// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
  upperMountain,
  middleMountain,
  lowerMountain,
  highlightMountain,
  light,
}

final _lightTheme = {
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
  _Element.light: Color(0xFFF1D8FF),
  _Element.background: Color(0xFFF3B24A),
  _Element.upperMountain: Color(0xFFB55913),
  _Element.middleMountain: Color(0xFF740A04),
  _Element.lowerMountain: Color(0xFF070000),
  _Element.highlightMountain: Color(0xFFE48F20)
};

final _darkTheme = {
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
  _Element.light: Color(0xFFFFFFC7),
  _Element.background: Color(0xFF6B73DF),
  _Element.upperMountain: Color(0xFF14217E),
  _Element.middleMountain: Color(0xFF14217E),
  _Element.lowerMountain: Color(0xFF000A40),
  _Element.highlightMountain: Color(0xFF4F51B2)
};

class Point {
  double x;
  double y;

  Point(double x, double y){
    this.x = x;
    this.y = y;
  }
}

final upperMountainHighlightPoints = [
  new Point(0.12, 0.17),
  new Point(0.33, 0.47),
  new Point(0.39, 0.52),
  new Point(0.55, 0.57),
  new Point(0.36, 0.64),
  new Point(0.2, 0.59),
  new Point(0.07, 0.4),
];

final upperMountainPoints = [
  new Point(0, 0.34),
  new Point(0.12, 0.17),
  new Point(0.33, 0.47),
  new Point(0.39, 0.52),
  new Point(0.55, 0.57),
  new Point(0.67, 0.55),
  new Point(0.78, 0.50),
  new Point(0.86, 0.47),
  new Point(0.95, 0.4),
  new Point(1, 0.39),
  new Point(1, 1),
  new Point(0, 1),
];

final middleMountainPoints = [
  new Point(0, 0.64),
  new Point(0.03, 0.56),
  new Point(0.2, 0.65),
  new Point(0.31, 0.67),
  new Point(0.45, 0.67),
  new Point(0.55, 0.63),
  new Point(0.62, 0.64),
  new Point(0.71, 0.67),
  new Point(0.7895, 0.7),
  new Point(0.84, 0.65),
  new Point(0.89, 0.64),
  new Point(0.94, 0.67),
  new Point(0.97, 0.65),
  new Point(1, 0.65),
  new Point(1, 1),
  new Point(0, 1),
];

final lowerMountainPoints = [
  new Point(0, 0.84),
  new Point(0.08, 0.81),
  new Point(0.16, 0.83),
  new Point(0.29, 0.81),
  new Point(0.40, 0.85),
  new Point(0.52, 0.79),
  new Point(0.60, 0.8),
  new Point(0.67, 0.72),
  new Point(0.72, 0.69),
  new Point(0.77, 0.68),
  new Point(0.81, 0.65),
  new Point(0.84, 0.69),
  new Point(0.88, 0.67),
  new Point(0.90, 0.66),
  new Point(0.94, 0.61),
  new Point(0.98, 0.62),
  new Point(1, 0.61),
  new Point(1, 1),
  new Point(0, 1),
];

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
//       _timer = Timer(
//         Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
//         _updateTime,
//       );
    });
  }

  @override
  Widget build(BuildContext context) {
    int hour = _dateTime.hour;
    double lightOffsetX;
    double lightOffsetY;
    double lightRadius;

    final colors = hour >= 6 && hour < 19
        ? _lightTheme
        : _darkTheme;

    if(hour >= 6 && hour < 13) {
      lightOffsetX = 0.1 + (0.8 * (hour - 6)) / 12;
      lightOffsetY = 0.25 - (0.07 * (hour - 6)) / 6;
      lightRadius = 30 - (10 * (hour - 6)) / 6;
    }
    else if(hour >= 13 && hour < 19) {
      lightOffsetX = 0.5 + (0.8 * (hour - 12)) / 12;
      lightOffsetY = 0.25 - (0.07 * (19 - hour)) / 6;
      lightRadius = 30 - (10 * (19 - hour)) / 6;
    }
    else if(hour >= 19 && hour < 24) {
      lightOffsetX = 0.1 + (0.8 * (hour - 19)) / 12;
      lightOffsetY = 0.25 - (0.07 * (hour - 19)) / 6;
      lightRadius = 30 - (10 * (hour - 19)) / 6;
    }
    else if(hour < 6) {
      lightOffsetX = 0.5 + (0.8 * (hour)) / 12;
      lightOffsetY = 0.25 - (0.07 * (6 - hour)) / 6;
      lightRadius = 30 - (10 * (6 - hour)) / 6;
    }

    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontSize: 48,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );


    final hourString =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minuteString = DateFormat('mm').format(_dateTime);

    return Container(
      color: colors[_Element.background],
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: CustomPaint(
              painter: LightSourcePainter(
                color: colors[_Element.light],
                lightOffsetX: lightOffsetX,
                lightOffsetY: lightOffsetY,
                lightRadius: lightRadius,
              ),
            ),
          ),
          SizedBox.expand(
            child: CustomPaint(
              painter: PointsPainter(
                color: colors[_Element.upperMountain],
                points: upperMountainPoints
              ),
            ),
          ),
          SizedBox.expand(
            child: CustomPaint(
              painter: PointsPainter(
                  color: colors[_Element.highlightMountain],
                  points: upperMountainHighlightPoints
              ),
            ),
          ),
          SizedBox.expand(
            child: CustomPaint(
              painter: PointsPainter(
                  color: colors[_Element.middleMountain],
                  points: middleMountainPoints
              ),
            ),
          ),
          SizedBox.expand(
            child: CustomPaint(
              painter: PointsPainter(
                  color: colors[_Element.lowerMountain],
                  points: lowerMountainPoints
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomRight,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text('$hourString : $minuteString', style: defaultStyle),
            ),
          )
        ],
      ),
    );
  }
}

class PointsPainter extends CustomPainter {
  Color color;
  List<Point> points;
  PointsPainter({Color color, List<Point> points}){
    this.color = color;
    this.points = points;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(size.width * this.points[0].x, size.height * this.points[0].y);
    for(int i = 1; i < this.points.length; i ++) {
      path.lineTo(size.width * this.points[i].x, size.height * this.points[i].y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class LightSourcePainter extends CustomPainter {
  Color color;
  double lightOffsetX;
  double lightOffsetY;
  double lightRadius;
  LightSourcePainter({Color color, double lightOffsetX, double lightOffsetY, double lightRadius}){
    this.color = color;
    this.lightOffsetX = lightOffsetX;
    this.lightOffsetY = lightOffsetY;
    this.lightRadius = lightRadius;
  }
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = this.color;
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(
      new Offset(size.width * this.lightOffsetX, size.height * this.lightOffsetY), this.lightRadius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}