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
import '../../chart_live_history/chart_live_history.dart';
import '../../manager/myUi.dart';
import '../../manager/myVoids.dart';

class MyChart extends StatefulWidget {
  const MyChart({Key? key}) : super(key: key);

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {

  //final PatientHomeCtr gc = Get.put<PatientHomeCtr>(PatientHomeCtr());
  //final PatientHomeCtr gc = Get.find<PatientHomeCtr>();



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
              builder: (gc) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: badges.Badge(
                  badgeStyle: badges.BadgeStyle(badgeColor: Colors.redAccent),
                  //showBadge: gc.notifNum >0 ?true:false,
                  showBadge: gc.showNotifBadge,
                  position: badges.BadgePosition.custom(start: 25),
                  badgeContent: Text('1',style: TextStyle(color: Colors.white),),
                  child: IconButton(
                    onPressed: () {
                      gc.toggleNotif(false);
                      gc.selectScreen(4);

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
        child: LiveHisChart(),
      ),
    );
  }
}
