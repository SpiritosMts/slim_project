import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_circle_chart/flutter_circle_chart.dart';


class Chaa extends StatefulWidget {
  @override
  _ChaaState createState() => _ChaaState();
}

class _ChaaState extends State<Chaa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff4C2882),
      appBar: AppBar(
        title: Text('Flutter Circle Chart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleChart(

              chartType: CircleChartType.gradient,
              items: [
                CircleChartItemData(
                  color:Colors.orange,
                  value: 60,
                  name: '% Training',
                  description: 'Training',
                ),
                CircleChartItemData(
                  color: Colors.blueAccent,
                  value: 40,
                  name: '% Resting',
                  description: 'Resting',
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }
}

Color randomColor() {
  var g = math.Random.secure().nextInt(255);
  var b = math.Random.secure().nextInt(255);
  var r = math.Random.secure().nextInt(255);
  return Color.fromARGB(255, r, g, b);
}