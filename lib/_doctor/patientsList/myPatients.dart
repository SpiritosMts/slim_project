
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/_doctor/home/doctorHome_ctr.dart';
import 'package:smart_care/_doctor/patientsList/_patientsListCtr.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/styles.dart';

import '../../manager/myVoids.dart';
import 'allPatients.dart';
import 'package:badges/badges.dart' as badges;

class MyPatients extends StatefulWidget {
  const MyPatients({Key? key}) : super(key: key);

  @override
  State<MyPatients> createState() => _MyPatientsState();
}

class _MyPatientsState extends State<MyPatients> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("My Patients".tr),
        automaticallyImplyLeading:false,
        centerTitle: true,
        backgroundColor: appbarColor,
        elevation: 10,
        actions: [
          GetBuilder<DoctorHomeCtr>(
              builder: (gc) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: badges.Badge(
                    badgeStyle: badges.BadgeStyle(badgeColor: Colors.redAccent),
                    showBadge: gc.showNotifBadge,
                    position: badges.BadgePosition.custom(start: 25),
                    badgeContent: Text('1',style: TextStyle(color: Colors.white),),
                    child: IconButton(
                      onPressed: () {
                        gc.selectScreen(4);
                        gc.toggleNotif(false);

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
        child: GetBuilder<DoctorHomeCtr>(
          builder: (gc) {
            return (gc.myPatientsMap.isNotEmpty)
              ? ListView.builder(
              itemExtent: 130,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              shrinkWrap: true,
              itemCount: gc.myPatientsMap.length,
              itemBuilder: (BuildContext context, int index) {
                String key = gc.myPatientsMap.keys.elementAt(index);
                return patientCard(gc.myPatientsMap[key]!,dcCtr.myPatientsMap.keys.toList());
              }
          ):gc.loadingUsers?
          Center(
            child: CircularProgressIndicator(),
          )
              :Center(

              child:Text('you have no patients yet'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                textStyle:  TextStyle(
                    fontSize: 23  ,
                    color: Colors.white,
                    fontWeight: FontWeight.w700
                ),
              ))
          );
          },

        ),
      )
      // floatingActionButton: Container(
      //   alignment: AlignmentDirectional.bottomStart,
      //   height: 60.0,
      //   width: 130.0,
      //   child: FittedBox(
      //     child: FloatingActionButton.extended(
      //
      //       heroTag: 'd0',
      //
      //
      //       onPressed: () {
      //         Get.to(()=>AllPatientsView());
      //       },
      //       backgroundColor: Colors.green,
      //       label: Text('Add Patient'),
      //     ),
      //   ),
      // ),

    );
  }
}

