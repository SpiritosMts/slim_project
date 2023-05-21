import 'dart:async';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:smart_care/_patient/home/patientHome_ctr.dart';
import 'package:smart_care/chart_live_history/chart_live_history_ctr.dart';
import 'package:smart_care/manager/styles.dart';
import 'package:badges/badges.dart' as badges;

import '../../alarm/alarm.dart';
import '../../manager/myUi.dart';
import '../../manager/myVoids.dart';
import '../alarm/ring_alarm.dart';

class LiveHisChart extends StatefulWidget {
  const LiveHisChart({Key? key}) : super(key: key);

  @override
  State<LiveHisChart> createState() => _LiveHisChartState();
}

class _LiveHisChartState extends State<LiveHisChart> {

  //final ChartsCtr gc = Get.find<ChartsCtr>();
  //final ChartsCtr gc = chCtr;


  // static StreamSubscription? subscription;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   subscription ??= Alarm.ringStream.stream.listen(
  //         (alarmSettings) => navigateToRingScreen(alarmSettings),
  //   );
  // }
  //
  // @override
  // void dispose() {
  //   subscription?.cancel();
  //   super.dispose();
  // }
  //
  // Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
  //   await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ExampleAlarmRingScreen(alarmSettings: alarmSettings),
  //       ));
  // }



  Widget prop({IconData? icon,String? title,String? value}){
    return    Row(
      children: [
        Icon(icon,color: Colors.white,size: 18,),
        SizedBox(width: 9),
        Text('${title!} :',style: TextStyle(color: Colors.white,fontSize: 19),),
        SizedBox(width: 13,),
        Text(value!,style: TextStyle(color: Colors.white,fontSize: 17),),
      ],
    );
  }



  /// /////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartsCtr>(
        builder: (gc) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: gc.selectedServer != ''?
              Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      //shrinkWrap: true,
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        chartGraph(
                            flSpots:  gc.generateSpots(gc.bpmDataPts),
                            dataList:  gc.bpmDataPts,//double
                            dataName:  'bpm',
                            dataType:  gc.bpm_data,
                            width: 100.w,
                            minVal:  getDoubleMinValue(gc.bpmDataPts).toInt() -30.0,
                            maxVal:  getDoubleMaxValue(gc.bpmDataPts).toInt() +30.0,
                            bottomTitles: gc.bottomTitles
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 15.0,top: 28),
                          child: Column(
                            children: [
                              prop(
                                icon: Icons.timer_outlined,
                                title: 'Time'.tr,
                                value: '${  DateFormat('HH:mm:ss').format(DateTime.now())}',
                              ),
                              SizedBox(height: 15,),

                              prop(
                                icon: Icons.upload,
                                title: 'Max Safe'.tr,
                                value: chCtr.maxSafeZone.toString(),
                              ),
                              SizedBox(height: 15,),

                              prop(
                                icon: Icons.download_rounded,
                                title: 'Min Safe'.tr,
                                value: chCtr.minSafeZone.toString(),
                              ),



                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        SizedBox(
                          height: 50.h,

                          child:   (gc.bpm_history.isNotEmpty)?
                          chartGraphHistory(
                            valueInterval: 20,
                            dataName: 'bpm',
                            dataList:  gc.bpm_history, // list { 'time':25, 'value':147 }
                            timeList: gc.bpm_times,//list [25,26 ..]
                            valList: gc.bpm_values,//list [147,144 ..]
                            minVal: getMinValue(gc.bpm_values) - 200.0,
                            maxVal: getMaxValue(gc.bpm_values) + 200.0,
                            width: gc.bpm_history.length / 50 < 1.0 ? 1.0 : gc.bpm_history.length / 50,
                          ):Center(
                            child: Text('no history data saved yet', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                              textStyle:  TextStyle(
                                  fontSize: 23  ,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700
                              ),
                            )),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,

                    child:   Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        height: 40,
                        child: FloatingActionButton.extended(
                          onPressed: gc.toggleConnection,
                          icon: Icon(size: 16,
                            gc.isConnected ? Icons.check_circle : Icons.error,
                            color: Colors.white,
                          ),
                          label: Text(
                            gc.isConnected ? 'Connected' : 'Disconnected',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          backgroundColor: gc.isConnected ? Colors.greenAccent.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5),
                        ),
                      ),
                    ),
                  )
                ],
              ): gc.chartLoading ?  Center(
             child: CircularProgressIndicator(),
           ): Center(
                child: Center(
                  child: Text('no patients attached', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                    textStyle:  TextStyle(
                        fontSize: 25  ,
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                    ),
                  )),
                ),
              )
          );
        }
    );
  }
}



SideTitles get topTitles => SideTitles(
  //interval: 1,
  showTitles: true,
  getTitlesWidget: (value, meta) {
    String text = '';
    switch (value.toInt()) {

    }

    return Text(
      text,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11),
    );
  },
);
SideTitles  leftTitles(int valueInterval) {
  return SideTitles(
    //interval: 10,
    showTitles: true,

    getTitlesWidget: (value, meta) {
      String text = '';
      switch (value.toInt()) {
      // case -50:
      //   text = '-50';
      //   break;
      // case 0:
      //   text = '0';
      //   break;
      // case 50:
      //   text = '50';
      //   break;
      // case 100:
      //   text = '100';
      //   break;
      }
      if (value.toInt() % valueInterval == 0) {
        text=value.toInt().toString();
      }
      return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Text(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11,color: chartValuesColor),
        ),
      );
    },
  );
}

SideTitles  bottomTimeTitles(int eachTime, List<String> timeList) { //gas_times
  return SideTitles(
    interval: 1,
    showTitles: true,
    getTitlesWidget: (value, meta) {
      int index = value.toInt(); // 0 , 1 ,2 ...
      String bottomText = '';


      //print('## ${value.toInt()}');

      //bool isDivisibleBy15 = ((value.toInt() % 13 == 0) );
      //bottomText = (value.toInt() ).toString();

      switch (value.toInt() % eachTime ) {

        case 0:
//        bottomText = DateFormat('HH:mm:ss').format(newDateTime);
          bottomText=timeList[index];

          break;
      // case 0:
      //   bottomText = DateFormat('mm:ss').format(newDateTime);
      //   break;

      }

      return Text(
        bottomText,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11,color: Colors.white),
      );
    },
  );
}

/// live_listen
Widget chartGraph({Color? bgCol,int valueInterval = 50, SideTitles? bottomTitles, String? dataType , List<FlSpot>? flSpots,String? dataName,List<double>? dataList,double? minVal,double? maxVal,double? width}){

  //print('## chart update');



  chCtr.checkDangerState();



  //print('## isInDanger = $isInDanger');

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           // Text(ptCtr.getStringStream as String,style: TextStyle(color: Colors.white),),
            RippleAnimation(
              child: Container(
                //color:Colors.green,
               width: 5,
               height: 5,
              ),
              color: !(chCtr.isInDanger)? chCtr.chartLineNormalColor : chCtr.chartLineDangerColor,
              delay: const Duration(milliseconds: 300),
              repeat: true,
              minRadius: 15,
              ripplesCount: 6,
              duration: const Duration(milliseconds: 6 * 300),
            ),
            SizedBox(width: 10),
            Text('${dataName} Live (${dataList!.last})', textAlign: TextAlign.left, style: TextStyle(fontSize: 24,color: Colors.white70),),
          ],
        ),
      ),
      SingleChildScrollView(
        child: Container(
          height: 100.h /3,
          width: width,
          child: Padding(
            padding: const EdgeInsets.only(right: 6.0,left: 0),
            child: Container(
              // color: Colors.grey[200],
              child: LineChart(
                swapAnimationDuration: Duration(milliseconds: 40),
                swapAnimationCurve: Curves.linear,
                LineChartData(

                  clipData: FlClipData.all(),
                  // no overflow
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: valuePopColor,
                        tooltipRoundedRadius: 20.0,
                        showOnTopOfTheChartBoxArea: false,
                        fitInsideHorizontally: true,
                        tooltipMargin: 50,
                        tooltipHorizontalOffset: 20,
                        fitInsideVertically: true,
                        tooltipPadding: EdgeInsets.all(8.0),
                        //maxContentWidth: 40,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            //gc.changeGazTappedValue(gc.dataPoints[touchedSpot.spotIndex].toString());
                            const textStyle = TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            );
                            return LineTooltipItem(
                              formatNumberAfterComma('${dataList![touchedSpot.spotIndex]}'),
                              textStyle,
                            );
                          },
                          ).toList();
                        },
                      ),
                      getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
                        return indicators.map(
                              (int index) {
                            final line = FlLine(color: Colors.white, strokeWidth: 2, dashArray: [2, 5]);
                            return TouchedSpotIndicatorData(
                              line,
                              FlDotData(show: false),
                            );
                          },
                        ).toList();
                      },
                      getTouchLineEnd: (_, __) => double.infinity),
                  //baselineY: 0,
                  minY:minVal,
                  maxY: maxVal,

                  ///rangeAnnotations
                  rangeAnnotations:RangeAnnotations(
                    // verticalRangeAnnotations:[
                    //   VerticalRangeAnnotation(x1: 1,x2: 2),
                    //   VerticalRangeAnnotation(x1: 3,x2: 4)
                    // ],
                      horizontalRangeAnnotations: [
                        HorizontalRangeAnnotation(y1: chCtr.maxSafeZone,y2: chCtr.maxSafeZone+0.2,color: Colors.redAccent),
                        HorizontalRangeAnnotation(y1: chCtr.minSafeZone,y2: chCtr.minSafeZone+0.2,color: Colors.redAccent),
                        // HorizontalRangeAnnotation(y1: 3,y2: 4),
                        // HorizontalRangeAnnotation(y1: 5,y2: 6),
                      ]
                  ) ,

                  backgroundColor: bgCol ?? secondaryColor.withOpacity(0.3), /// backgound
                  borderData: FlBorderData(
                      border: const Border(
                        //  bottom: BorderSide(),
                        //  left: BorderSide(),
                        //  top: BorderSide(),
                        // right: BorderSide(),
                      )),
                  gridData: FlGridData(show: false , horizontalInterval: 50, verticalInterval: 1,),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(sideTitles: bottomTitles??SideTitles(showTitles: true)),
                    leftTitles: AxisTitles(sideTitles: leftTitles(valueInterval)),
                    topTitles: AxisTitles(sideTitles: topTitles),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      ///fill
                      // belowBarData: BarAreaData(
                      //     color: Colors.blue,
                      //     //cutOffY: 0,
                      //     //ap aplyCutOffY: true,
                      //     spotsLine: BarAreaSpotsLine(
                      //       show: true,
                      //     ),
                      //     show: true
                      // ),
                      dotData: FlDotData(
                        show: false,
                      ),
                      show: true,
                      preventCurveOverShooting: false,
                      //showingIndicators:[0,5,6],
                      isCurved: true,
                      isStepLineChart: false,
                      isStrokeCapRound: false,
                      isStrokeJoinRound: false,

                      barWidth: 3.0,
                      curveSmoothness: 0.25,
                      preventCurveOvershootingThreshold: 10.0,
                      lineChartStepData: LineChartStepData(stepDirection: 0),
                      //shadow: Shadow(color: Colors.blue,offset: Offset(0,8)),
                      color: !(chCtr.isInDanger)? chCtr.chartLineNormalColor : chCtr.chartLineDangerColor,
                      spots: flSpots,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
/// history_listen
Widget chartGraphHistory({Color? bgCol, int valueInterval = 50, String? dataName,List? dataList,List<String>? timeList,List<String>? valList, double? minVal,double? maxVal, double? width}) {
  double minV = getMinValue(valList!);
  double maxV = getMaxValue(valList!);

  var ctr = chCtr;

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            IconButton(
              onPressed: ()async {
                await ctr.initHistoryValues('patients/${ctr.selectedServer}/bpm_history');  // shoiw delete dialog
              },
              icon: Icon(Icons.refresh,color: Colors.white,size: 20,),
            ),
            Text('History ',style: TextStyle(fontSize: 24,color: Colors.white70),),
            Text('(${minV.toString()}, ${maxV.toString()})',style: TextStyle(fontSize: 15,color: Colors.white70),),

            IconButton(
              onPressed: ()async {
                await ctr.deleteHisDialog(dataName!, dataList!);  // shoiw delete dialog
              },
              icon: Icon(Icons.close_fullscreen_outlined,color: Colors.white,size: 20,),
            )

          ],
        ),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 100.h /3,
          width: 100.h * width!,
          child: Padding(
            padding: const EdgeInsets.only(right: 6.0,left: 0),
            child: Container(
              //color: Colors.grey[200],
              child: LineChart(
                swapAnimationDuration: Duration(milliseconds: 40),
                swapAnimationCurve: Curves.linear,
                LineChartData(
                  clipData: FlClipData.all(),
                  // no overflow
                  lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {},
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: valuePopColor,
                        tooltipRoundedRadius: 20.0,
                        showOnTopOfTheChartBoxArea: false,
                        fitInsideHorizontally: true,
                        tooltipMargin: 50,
                        tooltipHorizontalOffset: 20,
                        fitInsideVertically: true,
                        tooltipPadding: EdgeInsets.all(8.0),
                        //maxContentWidth: 40,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            //gc.changeGazTappedValue(gc.dataPoints[touchedSpot.spotIndex].toString());
                            const textStyle = TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            );
                            return LineTooltipItem(
                              formatNumberAfterComma('${dataList![touchedSpot.spotIndex]}'),
                              textStyle,
                            );
                          },
                          ).toList();
                        },
                      ),
                      getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
                        return indicators.map((int index) {
                          final line = FlLine(color: Colors.white, strokeWidth: 2, dashArray: [2, 5]);
                          return TouchedSpotIndicatorData(
                            line,
                            FlDotData(show: false),
                          );
                        },
                        ).toList();
                      },
                      getTouchLineEnd: (_, __) => double.infinity),
                  baselineY: 0,
                  minY: minVal,
                  maxY: maxVal,

                  ///rangeAnnotations
                  rangeAnnotations: RangeAnnotations(
                    // verticalRangeAnnotations:[
                    //   VerticalRangeAnnotation(x1: 1,x2: 2),
                    //   VerticalRangeAnnotation(x1: 3,x2: 4)
                    // ],
                      horizontalRangeAnnotations: [
                        //HorizontalRangeAnnotation(y1: 89,y2: 90,color: Colors.redAccent),
                        // HorizontalRangeAnnotation(y1: 3,y2: 4),
                        // HorizontalRangeAnnotation(y1: 5,y2: 6),
                      ]),

                  backgroundColor: bgCol ?? secondaryColor.withOpacity(0.3), /// backgound
                  borderData: FlBorderData(
                      border: const Border(
                        // bottom: BorderSide(),
                        // left: BorderSide(),
                        // top: BorderSide(),
                        //right: BorderSide(),
                      )),
                  gridData: FlGridData(show: false, horizontalInterval: 50, verticalInterval: 1),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(sideTitles: bottomTimeTitles(ctr.eachTimeHis, timeList!)), // time line
                    leftTitles: AxisTitles(sideTitles: leftTitles(valueInterval)), // values line
                    topTitles: AxisTitles(sideTitles: topTitles),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      ///fill
                      // belowBarData: BarAreaData(
                      //     color: Colors.blue,
                      //     //cutOffY: 0,
                      //     //ap aplyCutOffY: true,
                      //     spotsLine: BarAreaSpotsLine(
                      //       show: true,
                      //     ),
                      //     show: true
                      // ),
                      dotData: FlDotData(
                        show: false,
                      ),
                      show: true,
                      preventCurveOverShooting: false,
                      //showingIndicators:[0,5,6],
                      isCurved: true,
                      isStepLineChart: false,
                      isStrokeCapRound: false,
                      isStrokeJoinRound: false,

                      barWidth: 3.0,
                      curveSmoothness: 0.02,
                      preventCurveOvershootingThreshold: 10.0,
                      lineChartStepData: LineChartStepData(stepDirection: 0),
                      //shadow: Shadow(color: Colors.blue,offset: Offset(0,8)),
                      color: Colors.white,
                      //spots: points.map((point) => FlSpot(point.x, point.y)).toList(),

                      spots: ctr.generateHistorySpots(dataList!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}


