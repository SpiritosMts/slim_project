

import 'dart:math';

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
SideTitles get leftTitles {
  return SideTitles(
  interval: 10,
  showTitles: true,

  getTitlesWidget: (value, meta) {
    String text = '';
    switch (value.toInt()) {
      case -50:
        text = '-50';
        break;
      case 0:
        text = '0';
        break;
      case 50:
        text = '50';
        break;
      case 100:
        text = '100';
        break;
    }
    if (value.toInt() % 10 == 0) {
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
Widget chartGraph({SideTitles? bottomTitles, String? dataType , List<FlSpot>? flSpots,String? dataName,List<double>? dataList,double? minVal,double? maxVal,double? width}){

  //print('## chart update');

 Color chartLineNormalColor = Colors.blue;
 Color chartLineDangerColor = Colors.red;
 Color touchVerticalLineColor = accentColor;
 Color valuePopColor = customColor1;

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
        //scrollDirection: Axis.horizontal,
        child: Container(
          height: 100.h /3,
          width: width,
          //SingleChildScrollView / scrollDirection: Axis.horizontal,
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
                        //true
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
                            final line = FlLine(color: touchVerticalLineColor, strokeWidth: 2, dashArray: [2, 5]);
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

                  backgroundColor: secondaryColor,
                  borderData: FlBorderData(
                      border: const Border(
                        //  bottom: BorderSide(),
                        //  left: BorderSide(),
                        //  top: BorderSide(),
                        // right: BorderSide(),
                      )),
                  gridData: FlGridData(show: false , horizontalInterval: 20, verticalInterval: 1,),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(sideTitles: bottomTitles??SideTitles(showTitles: true)),
                    leftTitles: AxisTitles(sideTitles: leftTitles),
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
Widget patientCard(ScUser user, List<dynamic> doctrPats, ctx,
    {bool openMsg = false}) {
  double width = MediaQuery.of(ctx).size.width;
  return GestureDetector(
    onTap: () {
      // dcCtr.selectUser(user);
      // if (openMsg) {
      //   Get.to(() => ChatRoom(),
      //       arguments: {'senderID': dcCtr.doctorSelectedUser.id});
      // } else {
      //   Get.to(() => PatientInfo());
      // }
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: width,
        height: 130,
        child: Stack(
          children: [
            Card(
              color: Color(0xff003A44),
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
            if (!doctrPats.contains(user.id))
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
                      patCtr.addPatient(user);
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
Widget doctorInfo(ScUser doctor, ctx) {
  double leftPad = 25;
  double txtIconPad = 15;
  double txtSize = 15;
  double width = MediaQuery.of(ctx).size.width;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: width * .95,
      height: 380,
      child: Card(
        color: Color(0xff003A44),
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
Widget patientInfo(ScUser patient, ctx) {
  double leftPad = 25;
  double txtIconPad = 15;
  double txtSize = 15;
  double width = MediaQuery.of(ctx).size.width;
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
              width: width * .95,
              height: 360,
              child: Card(
                color: Color(0xff003A44),
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
