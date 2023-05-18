
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/styles.dart';
import 'package:smart_care/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../manager/myVoids.dart';


class PatientInfo extends StatefulWidget {

  @override
  State<PatientInfo> createState() => _PatientInfoState();
}

class _PatientInfoState extends State<PatientInfo> {

  ScUser user =ScUser();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     user = Get.arguments['user'];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About ${user.name}"),
        centerTitle: true,
        backgroundColor: appbarColor,
        elevation: 10,
      ),
      body: backGroundTemplate(
        child: patientInfo(user),
      ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton:authCtr.cUser.patients.contains(user.id)? Padding(
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
                      patListCtr.removePatient(user);
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
                      print('## tryin to call: <${user.number}> ');
                      launchUrl(Uri.parse("tel://${user.number}"));
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
