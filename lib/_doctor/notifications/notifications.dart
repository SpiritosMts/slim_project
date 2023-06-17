
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/manager/styles.dart';

import '../../manager/myUi.dart';
import '../../manager/myVoids.dart';
import '../../models/user.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {

    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
       automaticallyImplyLeading: false,
       centerTitle: true,
        backgroundColor: appbarColor,
        elevation: 10,
      ),
      body: backGroundTemplate(
        child: StreamBuilder<QuerySnapshot>(
          stream: usersColl.where('id', isEqualTo: authCtr.cUser.id).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var usr = snapshot.data!.docs.first;
              Map<String,dynamic> notifications = usr.get('notifications');

              // if(authCtr.cUser.role == 'doctor'){
              //   dcCtr.notifNum = notifications.length;
              //   dcCtr.updateCtr();
              // }else{//patinet
              //   ptCtr.notifNum = notifications.length;
              //   ptCtr.updateCtr();
              // }

              return  (notifications.isNotEmpty)
                  ? ListView.builder(
                  itemExtent: 130,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shrinkWrap: true,

                  reverse: true,
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = notifications.keys.elementAt(index);
                    return notifCard(key, notifications[key]);
                  }
              ):Center(
                child: Text('no notifications found'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
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
      ),


    );
  }
}
