import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/chart_live_history/chart_live_history.dart';
import 'package:smart_care/manager/styles.dart';
import 'package:smart_care/models/user.dart';

import '../../manager/myUi.dart';
import '../../manager/myVoids.dart';
import 'doctorHome_ctr.dart';

class PatientChart extends StatefulWidget {
  const PatientChart({Key? key}) : super(key: key);

  @override
  State<PatientChart> createState() => _PatientChartState();
}

class _PatientChartState extends State<PatientChart> {

  final DoctorHomeCtr gc = Get.put<DoctorHomeCtr>(DoctorHomeCtr());

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
        automaticallyImplyLeading:false,
        elevation: 10,
        backgroundColor: appbarColor,
        title:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GetBuilder<DoctorHomeCtr>(
              id:'appBar',
              builder: (_) {
                // if(showLiveTime){
                // return  Text('${  DateFormat('HH:mm:ss').format(DateTime.now())}');
                // }
               return  Text('smartCare', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                textStyle:  TextStyle(
                fontSize: 23  ,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                ),
                ));
              }
          ),
        ),
        actions:<Widget>[
          GetBuilder<DoctorHomeCtr>(
              id:'appBar',
              builder: (g) {
                return dcCtr.myPatientsMap.isNotEmpty?  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: Container(),
                    dropdownColor: primaryColor,
                   // value:(gc.selectedServer!='' && dcCtr.myPatients.isNotEmpty)? dcCtr.myPatients[gc.selectedServer]!.name : 'no patients',
                    value:gc.selectedServer,
                    items:authCtr.cUser.patients.map((String id) {
                      // ScUser? pat = dcCtr.myPatients[id];
                       String patName = dcCtr.myPatientsMap[id]!.name!;
                      //printUser(pat);
                     // print('## selected pat_ID: <${id}>');
                      //print('## selected pat_name: <${patName}>');
                      return DropdownMenuItem<String>(
                        value: id,
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              patName,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      gc.changeServer(newValue);
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
    return GetBuilder<DoctorHomeCtr>(
        id: 'chart',
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: (gc.bpm_history.isNotEmpty) ?
            SingleChildScrollView(
              child: Column(
                //shrinkWrap: true,
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [


                  SizedBox(height: 20)
                ],
              ),
            ):Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
    );
  }
}
