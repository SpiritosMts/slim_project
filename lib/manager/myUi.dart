

import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/_doctor/patientsList/patientInfo.dart';
import 'package:smart_care/chatSystem/chatRoom.dart';
import 'package:smart_care/manager/auth/authCtr.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/models/user.dart';

import '../_doctor/notifications/map.dart';
import '../_doctor/patientsList/_patientsListCtr.dart';
import '../main.dart';
import 'styles.dart';



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

 Color chartLineNormalColor = Colors.blue;
 Color chartLineDangerColor = Colors.red;

 bool isInDanger = false;
 //double randomNumber = (Random().nextDouble() * (95 - (70)) + (70));

 double maxSafeZone = (Random().nextDouble() * (95 - (70)) + (70));
 double minSafeZone = 60;

 double dataNum = double.parse(dataType!);
 if(dataNum< minSafeZone || dataNum>maxSafeZone){
   isInDanger=true;
 }else{
   isInDanger=false;
 }
 //print('## isInDanger = $isInDanger');

  return Column(
    children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                        HorizontalRangeAnnotation(y1: maxSafeZone,y2: maxSafeZone+0.2,color: Colors.redAccent),
                        HorizontalRangeAnnotation(y1: minSafeZone,y2: minSafeZone+0.2,color: Colors.redAccent),
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
                      color: !isInDanger? chartLineNormalColor:chartLineDangerColor,
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

  var ctr = ptCtr;

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



///appointmentsCard
Widget appointmentCard(String key, Map<String, dynamic> appoiInfo, ctx) {
  bool newAppoi = appoiInfo['new'];
  String patientName = appoiInfo['patientName'];
  String date = appoiInfo['date'];
  String topic = appoiInfo['topic'];

  double width = MediaQuery.of(ctx).size.width;
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      width: width,
      //height: 200,
      child: Card(
        color: cardColor,
        elevation: 50,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: newAppoi ? Colors.green : Colors.white38, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/RDV.png',
                    width: 72,
                    color: newAppoi ? Colors.green : Colors.white38,
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///name
                      Text(
                        patientName,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'topic: $topic',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),

                      SizedBox(height: 5),

                      ///ge,der

                      Text(
                        'time: $date',
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              if (newAppoi)
                Divider(
                  color: Colors.white70,
                ),
              if (newAppoi)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      onPressed: () {
                        declineAppoi(key);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.clear, color: Colors.red.withOpacity(0.7), size: 25),
                          Text(
                            " Decline",
                            style: TextStyle(color: Colors.red.withOpacity(0.7), fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.white70,
                      indent: 20,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      onPressed: () {
                        acceptAppoi(key);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check, color: Colors.green.withOpacity(0.8), size: 25),
                          Text(
                            " Accept",
                            style: TextStyle(color: Colors.green.withOpacity(0.8), fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    ),
  );
}

///notificationsCard
Widget notifCard(Map<String, dynamic> notifInfo, {bool newNotif = false,bool isDoctor = false}) { //doctor
  String userID = notifInfo['userID'];

  return GestureDetector(
    onTap: () async {
      if(isDoctor){
        ScUser user = await getUserByID(userID);
        Get.to(() => PatientInfo(),arguments: {'user': user});

      }
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100.w,
        height: 130,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: newNotif ? Colors.green : Colors.white38,
                      width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/notification.png',
                          width: 72,
                          color: newNotif ? Colors.green : Colors.white38,
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///name
                            Text(
                              notifInfo['userName'],
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(height: 5),

                            ///email
                            Text(
                              'Alert: ${notifInfo['alertType']} -> ${notifInfo['alertValue']}}',
                              style: TextStyle(
                                  color: newNotif ? Colors.green : Colors.white,
                                  fontSize: 13),
                            ),
                            SizedBox(height: 5),

                            ///ge,der
                            Text(
                              'Time: ${notifInfo['time']}',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 36,
              right: 25,
              child: CircleAvatar(
                backgroundColor: dialogsCol,
                radius: 20,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.map_rounded),
                  color: Colors.white,
                  onPressed: () {
                    Get.to(() => MapMarker(), arguments: {
                      'pos': LatLng(double.parse(notifInfo['lat']), double.parse(notifInfo['lng']))
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

///adviceCard
Widget adviceCard(advice, {bool newAdvice = false}) { //doctor

  Color itemCol = newAdvice ? Colors.green : Colors.white38;

  return GestureDetector(
    onTap: () async {
  
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100.w,
        height: 130,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: itemCol,
                      width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          advice['image'],
                          width: 65,
                          color:itemCol,
                        ),
                        SizedBox(width: 13),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: SizedBox(

                                width: 51.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      advice['title'],
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                    ),
                                    SizedBox(height: 5),

                                    Text(
                                      '${advice['description']}}',
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: itemCol,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 5),

                            // Text(
                            //   'Time: ${advice['time']}',
                            //   style: TextStyle(
                            //       color: Colors.white54, fontSize: 11),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    ),
  );
}



Widget appNameText(){
  return Text('smartCare', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
    textStyle:  TextStyle(
        fontSize: 33  ,
        color: Colors.white,
        fontWeight: FontWeight.w700
    ),
  ),);
}


Widget customTextField({TextInputType? textInputType ,String? hintText,String? labelText,TextEditingController? controller ,String? Function(String?)? validator,bool obscure = false,bool isPwd = false,Function()? onSuffClick,IconData? icon}){
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Container(

      child: TextFormField(

        controller: controller,
        keyboardType: textInputType ,
        textInputAction: TextInputAction.done,
        obscureText: obscure,        ///pwd

        style: TextStyle(color: Colors.white, fontSize: 14.5),
        validator: validator,
        decoration: InputDecoration(



            contentPadding: const EdgeInsets.only(bottom: 0,right: 20,top: 0),
            suffixIconConstraints:BoxConstraints(minWidth: 50) ,
            prefixIconConstraints: BoxConstraints(minWidth: 50),
            prefixIcon: Icon(
              icon,
              color: Colors.white70,
              size: 22,
            ),
            suffixIcon:isPwd? IconButton(    ///pwd

            icon: Icon(!obscure ? Icons.visibility : Icons.visibility_off,color: Colors.white70,),
                onPressed: onSuffClick
            ):null,
            border: InputBorder.none,
            hintText: hintText!,
            labelText: labelText!,
            labelStyle: TextStyle(color: Colors.white60, fontSize: 14.5),
            hintStyle: TextStyle(color: Colors.white30, fontSize: 14.5),

            errorStyle: TextStyle(color: Colors.redAccent.withOpacity(.9), fontSize: 12,letterSpacing: 1),

            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white38)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white70)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.redAccent.withOpacity(.7))),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.redAccent)),


        ),

      ),
    ),
  );
}

backGroundTemplate({Widget? child}){
 return Container(
    //alignment: Alignment.topCenter,
    width: 100.w,
    height: 100.h,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/Landing page – 1.png"),
        fit: BoxFit.cover,
      ),
    ),
    child: child,
  );
}

///patientsCard
Widget patientCard(ScUser user, List<dynamic> doctrPats) {
  return GestureDetector(
    onTap: () {
      if(doctrPats.contains(user.id)) Get.to(() => PatientInfo());
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100.w,
        height: 130,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white38, width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),

                    ///patient simple info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/patient.png',
                          width: 72,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///name
                            Text(
                              '${user.name}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(height: 5),

                            ///email
                            Text(
                              user.email!,
                              style:
                              TextStyle(color: Colors.white, fontSize: 11),
                            ),
                            SizedBox(height: 5),

                            ///ge,der
                            Text(
                              '${user.sex!} (${user.age})',
                              style:
                              TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            (!doctrPats.contains(user.id))?
              Positioned(
                bottom: 36,
                right: 25,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      patListCtr.addPatient(user);
                    },
                  ),
                ),
              ):Positioned(
                bottom: 36,
                right: 25,
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.message),
                    color: Colors.white,
                    onPressed: () {
                      Get.to(() => ChatRoom(), arguments: {'user': user});
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

///doctorInfo
Widget doctorInfo(ScUser doctor,) {
  double leftPad = 25;
  double txtIconPad = 15;
  double txtSize = 15;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 95.w,
      height: 380,
      child: Card(
        color: cardColor,
        elevation: 50,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white38, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),

              ///doctor info
              Row(
                children: [
                  Image.asset(
                    'assets/images/patient.png',
                    width: 72,
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///name
                      Text(
                        'Dr.${doctor.name}',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 5),

                      ///email
                      Text(
                        doctor.email!,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30),

              ///speciality
              Row(
                children: [
                  SizedBox(width: leftPad),
                  Icon(
                    Icons.work,
                    size: 40,
                    color: Colors.white30,
                  ),
                  SizedBox(width: txtIconPad),
                  Text(
                    doctor.speciality!,
                    style: TextStyle(color: Colors.white, fontSize: txtSize),
                  ),
                ],
              ),
              SizedBox(height: 15),

              ///phone
              Row(
                children: [
                  SizedBox(width: leftPad),
                  Icon(
                    Icons.phone,
                    size: 40,
                    color: Colors.white30,
                  ),
                  SizedBox(width: txtIconPad),
                  Text(
                    doctor.number!,
                    style: TextStyle(color: Colors.white, fontSize: txtSize),
                  ),
                ],
              ),
              SizedBox(height: 15),

              ///address
              Row(
                children: [
                  SizedBox(width: leftPad),
                  Icon(
                    Icons.maps_home_work_sharp,
                    size: 40,
                    color: Colors.white30,
                  ),
                  SizedBox(width: txtIconPad),
                  Text(
                    doctor.address!,
                    style: TextStyle(color: Colors.white, fontSize: txtSize),
                  ),
                ],
              ),
              SizedBox(height: 15),

              ///connected
              Row(
                children: [
                  SizedBox(width: leftPad),
                  Icon(
                    Icons.event_available,
                    size: 40,
                    color: Colors.white30,
                  ),
                  SizedBox(width: txtIconPad),
                  Text(
                    'available',
                    style: TextStyle(color: Colors.white, fontSize: txtSize),
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    ),
  );
}

///patientsInfo
Widget patientInfo(ScUser patient,) {
  double leftPad = 25;
  double txtIconPad = 15;
  double txtSize = 15;
  return StreamBuilder<QuerySnapshot>(
    stream: usersColl.where('id', isEqualTo: patient.id).snapshots(),
    builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
        ) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
          ],
        );
      } else if (snapshot.connectionState == ConnectionState.active ||
          snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return const Text('');
        } else if (snapshot.hasData) {
          var p = snapshot.data!.docs.first;
          Map<String, dynamic> health = p.get('health');

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 95.w,
              height: 360,
              child: Card(
                color: cardColor,
                elevation: 50,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white38, width: 2),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15),

                        ///patient info
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/person.png',
                              width: 72,
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ///name
                                Text(
                                  patient.name!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(height: 5),

                                ///email
                                Text(
                                  patient.email!,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 40),

                        ///heart
                        Row(
                          children: [
                            SizedBox(width: leftPad),
                            Image.asset(
                              "assets/images/logo.png",
                              width: 40,
                            ),
                            SizedBox(width: txtIconPad),
                            Text(
                              '${health['hear']} bpm',
                              style: TextStyle(
                                  color: Colors.white, fontSize: txtSize),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Text('');
        }
      } else {
        return Text('');
      }
    },
  );
}


Widget customButton({ bool reversed =false, Function()? btnOnPress,Widget? icon , String textBtn = 'button', double btnWidth=200 ,Color? fillCol  ,Color? borderCol }){


 List<Widget> buttonItems =[
   icon!,


    SizedBox(width: 10),
   Text(
     textBtn,
     style: TextStyle(
       color: Colors.white,
       fontSize: 16,
     ),
   ),
    //Icon(Icons.send_rounded,  color: Colors.white,),

  ];

  return SizedBox(
    width: btnWidth,
    child: ElevatedButton(
      onPressed: btnOnPress!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: reversed? buttonItems.reversed.toList():buttonItems,
      ),
      style: ElevatedButton.styleFrom(
        primary: fillCol ?? primaryColor.withOpacity(0.7)!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: borderCol ?? accentColor0! ,
          width: 2,
        ),
      ),
    ),
  );
}