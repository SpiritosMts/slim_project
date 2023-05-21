import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/chart_live_history/chart_live_history.dart';
import 'package:smart_care/manager/styles.dart';
import 'package:smart_care/models/user.dart';

import '../../chart_live_history/chart_live_history_ctr.dart';
import '../../manager/myUi.dart';
import '../../manager/myVoids.dart';
import 'doctorHome_ctr.dart';

class PatientChart extends StatefulWidget {
  const PatientChart({Key? key}) : super(key: key);

  @override
  State<PatientChart> createState() => _PatientChartState();
}

class _PatientChartState extends State<PatientChart> {

  //final DoctorHomeCtr gc = Get.put<DoctorHomeCtr>(DoctorHomeCtr());


  /// /////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        //centerTitle: gc.myPatients.isNotEmpty? false:true,
        automaticallyImplyLeading:false,
        elevation: 10,
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
          GetBuilder<DoctorHomeCtr>(
              //id:'appBar',
              builder: (gc) {
                return  gc.myPatientsMap.isNotEmpty?  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: Container(),
                    dropdownColor: primaryColor,
                   // value:(gc.selectedServer!='' && gc.myPatients.isNotEmpty)? gc.myPatients[gc.selectedServer]!.name : 'no patients',
                    value:chCtr.selectedServer,
                    //value:'name',
                    items:gc.myPatientsMap.keys.map((String id) {
                      // ScUser? pat = gc.myPatients[id];
                       String patName = gc.myPatientsMap[id]!.name!;
                      print('## (dropdown) pat-ID: $id');
                      //print('## pat-name: $patName');
                       //String patName = 'name';

                      return DropdownMenuItem<String>(
                        value: id ,
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              patName,
                              //patName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      gc.updateCtr();
                      Future.delayed(const Duration(milliseconds: 800), () {
                        chCtr.changeServer(newValue);

                      });

                    },
                  ),
                ):Container();
              }
          ),
        ],
      ),
      body: backGroundTemplate(
        child: LiveHisChart(),
      ),
    );
  }
}
