import 'package:alarm/alarm.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/_patient/home/patientHome_ctr.dart';
import 'package:smart_care/manager/styles.dart';
import 'package:badges/badges.dart' as badges;

import '../../alarm/alarm.dart';
import '../../manager/myUi.dart';
import '../../manager/myVoids.dart';

class MyChart extends StatefulWidget {
  const MyChart({Key? key}) : super(key: key);

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {

  final PatientHomeCtr gc = Get.put<PatientHomeCtr>(PatientHomeCtr());

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

  bool _isConnected = true;

  void _toggleConnection() {
    // final alarmSettings = AlarmSettings(
    //   id: 42,
    //   dateTime: DateTime.now(),
    //   assetAudioPath: 'assets/sounds/alarm.mp3',
    // );
    // Alarm.set(alarmSettings: alarmSettings);
    //
    setState(() {
      _isConnected = !_isConnected;
    });
  }

  /// /////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        //centerTitle: dcCtr.myPatients.isNotEmpty? false:true,
        automaticallyImplyLeading: false,

        backgroundColor: appbarColor,
        title:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('smartCare', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
            textStyle:  TextStyle(
                fontSize: 23  ,
                color: Colors.white,
                fontWeight: FontWeight.w700
            ),
          )),
        ),
        actions:<Widget>[
          GetBuilder<PatientHomeCtr>(
              id: 'appBar',

              builder: (_) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: badges.Badge(
                  badgeStyle: badges.BadgeStyle(badgeColor: Colors.redAccent),
                  showBadge: gc.notifNum >0 ?true:false,
                  position: badges.BadgePosition.custom(start: 25),
                  badgeContent: Text(gc.notifNum.toString()),
                  child: IconButton(
                    onPressed: () {
                      ptCtr.selectScreen(4);
                    },
                    icon: Icon(Icons.notifications,color: Colors.white,),
                  ),
                ),
              );
            }
          )

        ],
      ),
      body: backGroundTemplate(
        child: GetBuilder<PatientHomeCtr>(
            id: 'chart',
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: !gc.chartLoading?
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
                                  value: dcCtr.maxRange.toString(),
                                ),
                                SizedBox(height: 15,),

                                prop(
                                  icon: Icons.download_rounded,
                                  title: 'Min Safe'.tr,
                                  value: dcCtr.minRange.toString(),
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
                            onPressed: _toggleConnection,
                            icon: Icon(size: 16,
                              _isConnected ? Icons.check_circle : Icons.error,
                              color: Colors.white,
                            ),
                            label: Text(
                              _isConnected ? 'Connected' : 'Disconnected',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            backgroundColor: _isConnected ? Colors.greenAccent.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5),
                          ),
                        ),
                      ),
                    )
                  ],
                ):Center(
                  child: Text(
                    'no server selected',
                    style: TextStyle(
                        fontSize: 17
                    ),
                  ),
                )
              );
            }
        ),
      ),
    );
  }
}
