
import 'dart:async';
import 'dart:math';

import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../manager/myVoids.dart';
import '../../manager/styles.dart';
import '../../models/user.dart';

class PatientHomeCtr extends GetxController{
  static PatientHomeCtr instance = Get.find();
  updateCtr(){
    update();
  }
  StreamSubscription<String>? myDocSubscription;

  final bottomBarController = BottomBarWithSheetController(initialIndex: 0);

  // create_appoi ////
  final TextEditingController createAppoiCtr = TextEditingController();
  GlobalKey<FormState> addAppoiKey = GlobalKey<FormState>();
  DateTime? appoiDate;
  ////////////////////

  bool loadingHis = true;
  bool showNotifBadge = false;
  int notifNum = 0;
  String? selectedServer ;
  ScUser myDoctor = ScUser();
  List<Map<String,dynamic>> advices = [];



  int currentScreenIndex = 0;





  /// /////////////////////////////////////////::
  @override
  void onInit() {
    super.onInit();
    print('## init PatientHomeCtr ##');

    advices = [
      {
        'image':'assets/images/advice0.png',
        'title':'An Apple a Day',
        'description':'Savor the goodness of apples for a healthier you. Packed with fiber, vitamins, and antioxidants, apples contribute to overall well-being. Snack on this crunchy fruit to boost your immune system, support digestion, and promote heart health. Embrace the natural sweetness of apples and discover a delicious way to nourish your body.',
        'month':'',
        'day':'',
        'year':'',
      },
      {
        'image':'assets/images/advice1.png',
        'title':'Take Charge of Your Health',
        'description':'Nurture your heart with love and care. Stay active, eat well, manage stress, and prioritize regular check-ups. Your heart is the lifeline to your well-being, so make heart health a top priority. Embrace a heart-healthy lifestyle and enjoy a life full of vitality and happiness.',
        'month':'',
        'day':'',
        'year':'',
      },

      {
        'image':'assets/images/advice2.png',
        'title':'Prioritize Cardiovascular Health',
        'description':'Your heart is the engine that keeps you going. Show it some love by making heart-healthy choices. Engage in regular physical activity, such as brisk walking or cycling, to keep your heart strong. Opt for a balanced diet rich in fruits, vegetables, whole grains, and lean proteins. Minimize salt, sugar',
        'month':'',
        'day':'',
        'year':'',
      },
    ];

    Future.delayed(const Duration(milliseconds: 200), () async {//time to start readin data
      if(authCtr.cUser.role == 'patient' && authCtr.cUser.id != 'no-id'){
        print('## Loading my bpm and my doctor]');
        chCtr.changeServer(authCtr.cUser.id);/// stream my bpm
        listenToAttachedDoc();
        updateCtr();
      }else{
        print('## cant load my bpm and my doctor ]');

      }

    });
  }
  @override
  void onClose() {
    super.onClose();
     myDocSubscription!.cancel();
  }

  void listenToAttachedDoc() {

    // final docRef = FirebaseFirestore.instance.collection("sc_users").doc(authCtr.cUser.id);
    // docRef.snapshots().listen(
    //       (event) => print("## current data: ${event.data()!['doctorAttachedID']}"),
    //   onError: (error) => print("## Listen failed: $error"),
    // );
    myDocSubscription = FirebaseFirestore.instance.collection('sc_users')
          .doc(authCtr.cUser.id)
          .snapshots()
          .map((snapshot) => snapshot.get('doctorAttachedID') as String).listen((stringValue) async {

      //print('## myDoctor_ID : $stringValue');

      myDoctor = await getUserByID(stringValue); /// get my doctor
      updateCtr();

    });



  }

  String convertToBPM( int pulse){

    return '';
  }

  void toggleNotif(value){
    showNotifBadge = value;
    update();
  }

  void sendAppoitment(){

    if(appoiDate == null) {
      showSnack('You need to pick a date'.tr,color: Colors.redAccent.withOpacity(0.6));

      return;
    }

    if (addAppoiKey.currentState!.validate()) {
      usersColl.doc(authCtr.cUser.doctorAttachedID).get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map<String, dynamic> appointments = documentSnapshot.get('appointments');

          appointments[authCtr.cUser.id!] = {
            'topic': createAppoiCtr.text,
            'time': '${DateFormat("hh:mm a").format(appoiDate!)}',
            'day': '${appoiDate!.day.toString().padLeft(2, '0')}',
            'month': '${getMonthName(appoiDate!.month)}',
            'new': true,
            'patientName': authCtr.cUser.name,
          };

          //add raters again map to cloud
          await usersColl.doc(authCtr.cUser.doctorAttachedID).update({
            'appointments': appointments,
          }).then((value) async {
            //Get.back();

            ptCtr.createAppoiCtr.clear();
            ptCtr.appoiDate =null;
            ptCtr.bottomBarController.toggleSheet();
            ptCtr.updateCtr();

            print('## appointment requested');
            showSnack('appointment request has been sent'.tr);
          }).catchError((error) async {
            print('## appointment request error');
            showSnack('appointment request error'.tr);
          });
        }
      });
    }
  }


  /// #####################################################################################"



  selectScreen(int index){
      currentScreenIndex = index;
      print('## screen<$currentScreenIndex> selected');
      updateCtr();
  }







}