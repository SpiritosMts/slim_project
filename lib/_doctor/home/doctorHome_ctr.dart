

import 'dart:async';
import 'dart:math';

import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_care/manager/firebaseVoids.dart';

import '../../main.dart';
import '../../manager/myVoids.dart';
import '../../manager/styles.dart';
import '../../models/user.dart';

class DoctorHomeCtr extends GetxController{
  static DoctorHomeCtr instance = Get.find();
  updateCtr(){
    update();
  }
  StreamSubscription<List>? myPatsSubscription;

  final bottomBarController = BottomBarWithSheetController(initialIndex: 0);

  int notifNum = 0;
  int currentScreenIndex = 0;

  Map<String,ScUser?> myPatientsMap = {};
  List<String> servers = [];
  double maxRange = 90;
  double minRange = 60;

  bool showNotifBadge = false;
  //String selectedServer ='';








  /// /////////////////////////////////////////::
  @override
  void onInit() {
    super.onInit();
    print('## init DoctorHomeCtr##');

    Future.delayed(const Duration(milliseconds: 200), () async {//time to start readin data
      if(authCtr.cUser.role == 'doctor' && authCtr.cUser.id != 'no-id'){
        //getMyPatientsFromIDs(authCtr.cUser.patients);
        listenToAttachedPats();
        servers = await getChildrenKeys('patients') as List<String>;
        print('## realtime-servers<${servers.length}>=>[ ${servers} ]');
        print('## my-patients-IDs<${authCtr.cUser.patients.length}>=>[${authCtr.cUser.patients}]=>(change cServer to first patient)');
        if (myPatientsMap.isNotEmpty) {
          chCtr.changeServer(myPatientsMap.keys.first);
        }else{
          chCtr.chartLoading = false;
          chCtr.updateCtr();
        }

        updateCtr();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    myPatsSubscription!.cancel();
  }

  void listenToAttachedPats() {

    // final docRef = FirebaseFirestore.instance.collection("sc_users").doc(authCtr.cUser.id);
    // docRef.snapshots().listen(
    //       (event) => print("## current data: ${event.data()!['doctorAttachedID']}"),
    //   onError: (error) => print("## Listen failed: $error"),
    // );
    myPatsSubscription = FirebaseFirestore.instance.collection('sc_users')
        .doc(authCtr.cUser.id)
        .snapshots()
        .map((snapshot) {
          return snapshot.get('patients') as List;
        }).listen((val) async {

      getMyPatientsFromIDs(val);
      updateCtr();

    });



  }

  selectScreen(int index){
    currentScreenIndex = index;
    print('## screen<$currentScreenIndex> selected');
    updateCtr();
  }
  void toggleNotif(value){
    showNotifBadge = value;
    update();
  }

  bool loadingUsers = false;
  void getMyPatientsFromIDs(List IDs) async {
   // loadingUsers=true;

    //print('## getting my_patients From IDS....');
    myPatientsMap.clear();
    if(IDs.isNotEmpty){
      for (var id in IDs) {
        final event = await usersColl.where('id', isEqualTo: id).get();
        var doc = event.docs.single;
        myPatientsMap[id] = ScUserFromMap(doc);
      }
    }

    print('## got my_patients From IDS <${myPatientsMap.length}>');

   // loadingUsers=false;

      if(myPatientsMap.isNotEmpty) chCtr.changeServer(myPatientsMap.keys.first);

    //updateCtr();
  }






}