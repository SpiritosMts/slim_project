import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/_doctor/home/doctorHome_ctr.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';

class GetAppointments extends StatefulWidget {
  const GetAppointments({Key? key}) : super(key: key);

  @override
  State<GetAppointments> createState() => _GetAppointmentsState();
}

class _GetAppointmentsState extends State<GetAppointments> {
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<DoctorHomeCtr>(
      builder: (_) {
        return Container(
          child:  StreamBuilder<QuerySnapshot>(
            stream: usersColl.where('id', isEqualTo: authCtr.cUser.id).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,) {
              if (snapshot.hasData) {
                var doctr = snapshot.data!.docs.first;
                Map<String,dynamic> appointments = doctr.get('appointments');
                print('## appointments: ${appointments}');
                // bool hasOneReq = false;
                // for(var appoi in appointments.values){
                //   if(appoi['new']==true){
                //     hasOneReq=true;
                //   }
                // }
                return  (appointments.isNotEmpty)
                    ? ListView.builder(
                     //itemExtent: 180,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    shrinkWrap: true,
                    itemCount: appointments.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = appointments.keys.elementAt(index);
                      //print('## key: ${key}');
                      //bool newAppoi = appointments[key]['new'];
                      return appoiCard(key,appointments[key]!);
                    }
                ):Center(
                  child: Text('no appointments found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                    textStyle:  TextStyle(
                        fontSize: 23  ,
                        color: Colors.white,
                        fontWeight: FontWeight.w700
                    ),
                  )),
                );
              } else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        );
      }
    );
  }
}

