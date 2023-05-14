import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/manager/styles.dart';

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
  SideTitles get bottomTitles => SideTitles(
    interval: 1,
    showTitles: true,
    getTitlesWidget: (value, meta) {
      String bottomText = '';

      //print('## ${value.toInt()}');

      //bool isDivisibleBy15 = ((value.toInt() % 13 == 0) );
      DateTime newDateTime = gc.startDateTime.add(Duration(seconds: value.toInt()));
      //bottomText = DateFormat('mm:ss').format(newDateTime);
      //bottomText = (value.toInt() ).toString();

      switch (value.toInt() % 7 ) {

        case 0:
          bottomText = DateFormat('HH:mm:ss').format(newDateTime);
          break;

      }

      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          bottomText,
          maxLines: 1,

          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11,color:chartValuesColor),
        ),
      );

    },
  );

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
        automaticallyImplyLeading: false,

        backgroundColor: appbarColor,
        title:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GetBuilder<DoctorHomeCtr>(
              id:'appBar',
              builder: (_) {
                if(showLiveTime){
                return  Text('${  DateFormat('HH:mm:ss').format(DateTime.now())}');
                }
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
              builder: (_) {
                return dcCtr.myPatients.isNotEmpty?  Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: DropdownButton<String>(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    underline: Container(),
                    dropdownColor: primaryColor,
                   // value:(gc.selectedServer!='' && dcCtr.myPatients.isNotEmpty)? dcCtr.myPatients[gc.selectedServer]!.name : 'no patients',
                    value:gc.selectedServer,
                    items: dcCtr.myPatients.isNotEmpty? gc.servers.map((String value) {
                      String patName =dcCtr.myPatients[value]!.name!;
                      return DropdownMenuItem<String>(
                        value: value,
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
                    }).toList():null,
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
        child: GetBuilder<DoctorHomeCtr>(
            id: 'chart',
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: gc.selectedServer != null ? gc.selectedServer != ''?
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
                           minVal:  getDoubleMinValue(gc.bpmDataPts).toInt() -15.0,
                           maxVal:  getDoubleMaxValue(gc.bpmDataPts).toInt() +15.0,
                              bottomTitles: bottomTitles
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
                          )
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
                            backgroundColor: _isConnected ? Colors.green : Colors.red,
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
                ):Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
        ),
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
