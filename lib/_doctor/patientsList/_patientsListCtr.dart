
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_care/manager/dataBase.dart';
import 'package:smart_care/models/user.dart';

import '../../manager/myVoids.dart';

class PatientsListCtr extends GetxController {


  StreamSubscription? allPatsSubscription;

@override
void onInit() {
  super.onInit();
 // print('## init AllPatientsCtr');
  Future.delayed(const Duration(seconds: 0), () {
    //getUsersData(printDet: true);
    listenToAllPats();
    //streamingDoc(usersColl,authCtr.cUser.id!);
  });
}

  @override
  void onClose() {
    super.onClose();
    allPatsSubscription!.cancel();
  }


  Map<String, ScUser> userMap = {};
  List<ScUser> userList = [];
  List<ScUser> foundUsersList = [];
  final TextEditingController typeAheadController = TextEditingController();
  bool shouldLoad =true;
  bool typing = false;


void listenToAllPats() {


  allPatsSubscription = FirebaseFirestore.instance.collection('sc_users').where('role', isEqualTo: 'patient')
      .where('doctorAttachedID', isEqualTo: '')
      .snapshots()
      .listen((event) {

          List<DocumentSnapshot> usersData = event.docs;
          // Remove any existing users
          userMap.clear();

          //fill user map
          for (var _user in usersData) {
            //fill userMap
            userMap[_user.id] = ScUserFromMap(_user);
          }

          userList = userMap.entries.map( (entry) => entry.value).toList();
          foundUsersList = userList;
          shouldLoad=false;
           print('## < ${userMap.length} > users loaded from firestore');
          update();

        },
    onError: (error) => print("## allPats Listen failed: $error"),
  );




}


  getUsersData({bool printDet = false}) async {
    shouldLoad=true;

    if (printDet) print('## downloading users from fireBase...');
    List<DocumentSnapshot> usersData = await getDocumentsByColl(
        usersColl.where('role', isEqualTo: 'patient')//filter only patients
            .where('doctorAttachedID', isEqualTo: '')// patient that not attached to any doctor
    );

    // Remove any existing users
    userMap.clear();

    //fill user map
    for (var _user in usersData) {
      //fill userMap
      userMap[_user.id] = ScUserFromMap(_user);
    }

    userList = userMap.entries.map( (entry) => entry.value).toList();
    foundUsersList = userList;
    shouldLoad=false;
    if (printDet) print('## < ${userMap.length} > users loaded from firestore');
    update();

  }

  void runFilterList(String enteredKeyword) {
    List<ScUser>? results = [];

    if (enteredKeyword.isEmpty) {
      results = userList;
    } else {
      results = userList.where((user) => user.email!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    foundUsersList = results;
    update();

  }

  addPatient(ScUser patient) async {
    String patID = patient.id!;
    String dctrID = authCtr.cUser.id!;

    updateDoc(usersColl, patID, {'doctorAttachedID': dctrID});

    //add patient to doctor
    await addElementsToList([patID], 'patients', dctrID, 'sc_users').then((value) {
      showSnack("${patient.name} added to my patients list");

    });

    //add doctor to patient
    //authCtr.refreshCuser();///refresh-user
    //refresh curr user
    //authCtr.refreshCuser();
    //Get.back();
  }

  removePatient(ScUser patient) async {
    String patID = patient.id!;
    String dctrID = patient.doctorAttachedID!;
    updateDoc(usersColl, patID, {'doctorAttachedID': ''});

    //remove patient to doctor
    removeElementsFromList([patID], 'patients', dctrID, 'sc_users').then((value) {
      showSnack("${patient.name} removed from my patients list",color: Colors.redAccent.withOpacity(0.8));

    });

    //remove doctor to patient
    //refresh curr user
    //authCtr.refreshCuser();///refresh

    //Get.back();
  }


  clearSelectedProduct() async {
    typeAheadController.clear();
    runFilterList(typeAheadController.text);
    appBarTyping(false);
    update();
  }
  appBarTyping(typ) {
    typing = typ;
    update();
  }





}