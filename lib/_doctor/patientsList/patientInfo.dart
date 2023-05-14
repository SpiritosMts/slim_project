
import 'package:flutter/material.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/styles.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../manager/myVoids.dart';


class PatientInfo extends StatefulWidget {

  @override
  State<PatientInfo> createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Patient Info"),

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
        child:patientInfo(dcCtr.doctorSelectedUser, context),
      ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton:authCtr.cUser.patients!.contains(dcCtr.doctorSelectedUser.id)? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: 40.0,
                width: 130.0,
                child: FittedBox(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      patCtr.removePatient(dcCtr.doctorSelectedUser);
                      },
                    heroTag: 'sfs-',
                    backgroundColor: Colors.green,
                    label: Text('Remove'),
                  ),
                ),
              ),
              Container(
                height: 40.0,
                width: 130.0,
                child: FittedBox(
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      print('## tryin to call: <${dcCtr.doctorSelectedUser.number}> ');
                      launchUrl(Uri.parse("tel://${dcCtr.doctorSelectedUser.number}"));
                    },
                    heroTag: '.df',
                    backgroundColor: Colors.green,
                    label: Text('  Call  '),
                  ),
                ),
              ),

            ],
          ),
        ):null,

    );
  }
}
