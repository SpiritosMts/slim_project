
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/_doctor/patientsList/_patientsListCtr.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/styles.dart';

import '../../manager/myVoids.dart';
import 'allPatients.dart';

class MyPatients extends StatefulWidget {
  const MyPatients({Key? key}) : super(key: key);

  @override
  State<MyPatients> createState() => _MyPatientsState();
}

class _MyPatientsState extends State<MyPatients> {
  final PatientsListCtr gc = Get.find<PatientsListCtr>();


  @override
  Widget build(BuildContext context) {


    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Patients"),
        automaticallyImplyLeading:false,
       centerTitle: true,
        backgroundColor: appbarColor,
        elevation: 10,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Landing page – 1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: GetBuilder<PatientsListCtr>(
          builder: (_)=>(dcCtr.myPatients.isNotEmpty)
              ? ListView.builder(
              itemExtent: 130,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              shrinkWrap: true,
              itemCount: dcCtr.myPatients.length,
              itemBuilder: (BuildContext context, int index) {
                String key = dcCtr.myPatients.keys.elementAt(index);
                return patientCard(dcCtr.myPatients[key]!,authCtr.cUser.patients!,context);
              }
          ):dcCtr.loadingUsers?
          Center(
            child: CircularProgressIndicator(),
          )
              :Center(

            child:Text('you have no patients yet', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
              textStyle:  TextStyle(
                  fontSize: 23  ,
                  color: Colors.white,
                  fontWeight: FontWeight.w700
              ),
            ))
          ),

        ),
      ),
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
