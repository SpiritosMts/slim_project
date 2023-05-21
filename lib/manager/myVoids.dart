

import 'dart:io';
import 'dart:math' as math;
import 'dart:math';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/_doctor/notifications/awesomeNotif.dart';
import 'package:smart_care/_doctor/patientsList/_patientsListCtr.dart';
import 'package:smart_care/_patient/home/patientHome_ctr.dart';
import 'package:smart_care/chart_live_history/chart_live_history_ctr.dart';
import 'package:smart_care/manager/auth/authCtr.dart';
import 'package:smart_care/manager/auth/login.dart';
import 'package:smart_care/manager/auth/verifyEmail.dart';
import 'package:smart_care/models/user.dart';

import '../_doctor/home/doctorHome_ctr.dart';
import '../alarm/ring_alarm.dart';
import '../main.dart';
import 'dataBase.dart';
import 'styles.dart';

AuthController authCtr = AuthController.instance;

ChartsCtr get chCtr => Get.find<ChartsCtr>();
DoctorHomeCtr get dcCtr => Get.find<DoctorHomeCtr>();
PatientHomeCtr get ptCtr => Get.find<PatientHomeCtr>();

PatientsListCtr get patListCtr => Get.find<PatientsListCtr>();

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseDatabase? get fbDatabase => FirebaseDatabase.instance;
User? get authCurrUser => FirebaseAuth.instance.currentUser;
var usersColl = FirebaseFirestore.instance.collection('sc_users');
String usersCollName = 'sc_users';
GoogleSignIn googleSign = GoogleSignIn();
FirebaseDatabase? get database => FirebaseDatabase.instance;

var roomsColl = FirebaseFirestore.instance.collection('sc_rooms');
FirebaseAuth get fbAuth => FirebaseAuth.instance;

int refreshVerifInSec =5;
int introShowTimes =1;
bool verifyAnyCreatedAccount =true;
bool showLiveTime =false;


bool isCtrInitialized<T extends GetxController>() {
  return Get.isRegistered<T>();
}

// String getUserNameByID(userID){
//   String userName = 'unknown';
//   for (var patID in authCtr.cUser.patients!) {
//     if (patID == userID) {
//       return patient['name'];
//     }
//   }
//     return userName;
//
// }

String formatNumberAfterComma(String number) {
  //final string = number.toString();
  if(number.contains('.')){
    final decimalIndex = number.indexOf('.');
    final end = min(decimalIndex + 3, number.length);
    return number.substring(0, end);
  }else{
    return number;
  }

}
double getDoubleMinValue(List<double> values) {
  return values.reduce((currentMin, value) => value < currentMin ? value : currentMin);
}
double getDoubleMaxValue(List<double> values) {
  return values.reduce((currentMax, value) => value > currentMax ? value : currentMax);
}

// String getMinValue(List<String> values) {
//   return values.reduce((currentMin, value) {
//     return (value.compareTo(currentMin) < 0) ? value : currentMin;
//   });
// }

double getMinValue(List<String> values) {
  List<double> doubleList = values.map((str) => double.parse(str)).toList();
  double minValue = doubleList.reduce((currentMin, value) => value < currentMin ? value : currentMin);
  return minValue;
}

double getMaxValue(List<String> values) {
  List<double> doubleList = values.map((str) => double.parse(str)).toList();
  double maxValue = doubleList.reduce((currentMax, value) => value > currentMax ? value : currentMax);
  return maxValue;
}
fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}
fieldUnfocusAll() {
  FocusManager.instance.primaryFocus?.unfocus();
}
double replaceWithClosestHalf(double value) {
  int intValue = value.toInt();
  double decimalPart = value - intValue;

  if (decimalPart < 0.25) {
    return intValue.toDouble();
  } else if (decimalPart >= 0.25 && decimalPart < 0.75) {
    return intValue.toDouble() + 0.5;
  } else {
    return intValue.toDouble() + 1.0;
  }
}
showTos(txt, {Color color = Colors.black87,bool withPrint = false}) async {
  Fluttertoast.showToast(
      msg: txt,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
  if(withPrint) print(txt);
}

Future<bool> canConnectToInternet() async {
  bool canConnect = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    /// connected to internet
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //is connected
      canConnect = true;
    }
    /// failed to connect to internet
  } on SocketException catch (_) {
    // not connected

  }
  return canConnect;
}
double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = math.cos;
  var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * math.asin(math.sqrt(a));
}


showSnack(txt,{Color? color}) {
  Get.snackbar(
    txt,
    '',
    messageText: Container(),
    colorText: Colors.white,
    backgroundColor:color?? Colors.greenAccent.withOpacity(0.70),
    snackPosition: SnackPosition.BOTTOM,
  );
}

String getMonthName(int monthNumber) {
  final dateTime = DateTime(2023, monthNumber);
  final monthFormat = DateFormat.MMMM();
  return monthFormat.format(dateTime);
}


String todayToString({bool showHours = false}) {
  //final formattedStr = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':' nn]);
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  if (showHours) {
    dateFormat = DateFormat("yyyy-MM-dd hh:mm");
  }
  return dateFormat.format(DateTime.now());
}




void showGetSnackbar(String title,String desc,{Color? color}){
  Get.snackbar(

    title,
    desc,
    duration: Duration(seconds: 2),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor:color?? Colors.redAccent.withOpacity(0.8),
    colorText: Colors.white,
  );
}


showVerifyConnexion(){
  AwesomeDialog(
    dialogBackgroundColor: dialogsCol,
    autoDismiss: true,
    dismissOnTouchOutside: true,
    animType: AnimType.SCALE,
    headerAnimationLoop: false,
    dialogType: DialogType.INFO,
    btnOkColor: Colors.blueAccent,
    // btnOkColor: yellowColHex

    //showCloseIcon: true,
    padding: EdgeInsets.symmetric(vertical: 15.0),

    title: 'Failed to Connect'.tr,
    desc: 'please verify network'.tr,

    btnOkOnPress: () {

    },
    onDismissCallback: (type) {
      print('Dialog Dissmiss from callback $type');
    },
    //btnOkIcon: Icons.check_circle,
    context: navigatorKey.currentContext!,

  ).show();
}

showLoading({required String text}) {

  return AwesomeDialog(
    dialogBackgroundColor: dialogsCol,

    dismissOnBackKeyPress: true,
    //change later to false
    autoDismiss: true,
    customHeader: Transform.scale(
      scale: .7,
      child: const LoadingIndicator(
        indicatorType: Indicator.ballClipRotate,
        colors: [loadingCol],
        strokeWidth: 10,
      ),
    ),

    context: navigatorKey.currentContext!,
    dismissOnTouchOutside: false,
    animType: AnimType.scale,
    headerAnimationLoop: false,
    dialogType: DialogType.NO_HEADER,

    //padding: EdgeInsets.all(8),
    descTextStyle: GoogleFonts.almarai(
      textStyle: const TextStyle(

          height: 1.5
      ),
    ),
    title: text,
    desc: 'Please wait'.tr,
  ).show();
}
showFailed({String? faiText}) {
  return AwesomeDialog(
      dialogBackgroundColor: dialogsCol,

      autoDismiss: true,
      context: navigatorKey.currentContext!,
      dismissOnTouchOutside: false,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      dialogType: DialogType.ERROR,
      //showCloseIcon: true,
      title: 'Failure'.tr,
      btnOkText: 'Ok'.tr,
      descTextStyle: GoogleFonts.almarai(
        height: 1.8,
        textStyle: const TextStyle(fontSize: 14),
      ),
      desc: faiText,
      btnOkOnPress: () {},
      btnOkColor: Colors.red,
      btnOkIcon: Icons.check_circle,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      }).show();
  ;
}
showSuccess({String? sucText, Function()? btnOkPress}) {
  return AwesomeDialog(
    dialogBackgroundColor: dialogsCol,

    autoDismiss: true,
    context: navigatorKey.currentContext!,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    animType: AnimType.leftSlide,
    dialogType: DialogType.success,
    //showCloseIcon: true,
    //title: 'Success'.tr,

    descTextStyle: GoogleFonts.almarai(
      height: 1.8,
      textStyle: const TextStyle(fontSize: 14),
    ),
    desc: sucText,
    btnOkText: 'Ok'.tr,

    btnOkOnPress: () {
      btnOkPress!();
    },
    // onDissmissCallback: (type) {
    //   debugPrint('## Dialog Dissmiss from callback $type');
    // },
    //btnOkIcon: Icons.check_circle,
  ).show();
}

showWarning({String? txt, Function()? btnOkPress}) {
  return AwesomeDialog(
    dialogBackgroundColor: dialogsCol,

    autoDismiss: true,
    context: navigatorKey.currentContext!,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    animType: AnimType.scale,
    dialogType: DialogType.warning,
    //showCloseIcon: true,
    //title: 'Success'.tr,

    descTextStyle: GoogleFonts.almarai(
      height: 1.8,
      textStyle: const TextStyle(fontSize: 14),
    ),
    btnOkColor: Color(0xFFFEB800),
    desc: txt,
    btnOkText: 'Ok'.tr,

    btnOkOnPress: () {
      btnOkPress!();
    },
    // onDissmissCallback: (type) {
    //   debugPrint('## Dialog Dissmiss from callback $type');
    // },
    //btnOkIcon: Icons.check_circle,
  ).show();
}

showAlarm({int? alarmID,String? name}) {
  return AwesomeDialog(
    dialogBackgroundColor: dialogsCol,
    autoDismiss: true,
    context: navigatorKey.currentContext!,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: true,
    dismissOnTouchOutside: false,
    animType: AnimType.scale,
    dialogType: DialogType.warning,
    //showCloseIcon: true,
    //title: 'Success'.tr,

    descTextStyle: GoogleFonts.almarai(
      height: 1.8,
      textStyle: const TextStyle(fontSize: 14),
    ),
    btnOkColor: Color(0xFFFEB800),
    //desc: 'You are in danger',
    btnOkText: 'Stop'.tr,

    body: AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText('${authCtr.cUser.role == 'patient' ? 'You are': '${name} is'} in danger'.tr,
            textStyle: GoogleFonts.indieFlower(
              textStyle:  TextStyle(
                  fontSize: 21,
                  color: accentColor0,
                  fontWeight: FontWeight.w800
              ),
            ),
            speed: const Duration(
              milliseconds: 80,
            )),
      ],
      isRepeatingAnimation: true,
      totalRepeatCount: 40,
    ),
    btnOkOnPress: () {
      Alarm.stop(alarmID!).then((_) {
        Get.back();
      });
    },

  ).show();
}


showShouldVerify({bool isLoadingScreen =false}) {
  return AwesomeDialog(
    dialogBackgroundColor: dialogsCol,

    autoDismiss: true,
    context: navigatorKey.currentContext!,

    showCloseIcon: true,
    dismissOnTouchOutside: true,
    animType: AnimType.SCALE,
    headerAnimationLoop: false,
    dialogType: DialogType.INFO,
    title: 'Verification'.tr,
    desc: 'Your email is not verified\nVerify now?'.tr,
    btnOkText: 'Verify'.tr,
    btnCancelText: 'Cancel'.tr,
    btnOkColor: Colors.blue,
    btnOkIcon: Icons.send,
    btnOkOnPress: () {
      Get.to(() => VerifyScreen());
    },
    // btnCancelOnPress: (){
    //   authCtr.signOut();
    //
    //
    //   Get.offAll(() => LoginScreen());
    //
    // },
    onDismissCallback: (_){
      if(isLoadingScreen){
        authCtr.signOut();
        Get.offAll(() => Login());
      }

    },
    padding: EdgeInsets.symmetric(vertical: 20.0),
  ).show();
}




Future<bool> showNoHeader({String? txt,String? btnOkText='delete',Color btnOkColor=Colors.red,IconData? icon=Icons.delete}) async {
  bool shouldDelete = false;

  await AwesomeDialog(
    context: navigatorKey.currentContext!,
    dialogBackgroundColor: dialogsCol,
    autoDismiss: true,
    isDense: true,
    dismissOnTouchOutside: true,
    showCloseIcon: false,
    headerAnimationLoop: false,
    dialogType: DialogType.noHeader,
    animType: AnimType.scale,
    btnCancelIcon: Icons.arrow_back_ios_sharp,
    btnCancelColor: Colors.grey,
    btnOkIcon: icon ?? Icons.delete,
    btnOkColor: btnOkColor,
    buttonsTextStyle: TextStyle(fontSize: 17.sp),
    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
    // texts
    title: 'Verification'.tr,
    desc: txt ?? 'Are you sure you want to delete this image'.tr,
    btnCancelText: 'cancel'.tr,
    btnOkText: btnOkText!.tr ,

    // buttons functions
    btnOkOnPress: () {
      shouldDelete = true;
    },
    btnCancelOnPress: () {
      shouldDelete = false;
    },




  ).show();
  return shouldDelete;
}


void declineAppoi(appoiID) {
  usersColl.doc(authCtr.cUser.id)
      .get()
      .then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> appointments = documentSnapshot.get('appointments');

      appointments.remove(appoiID);

      await usersColl.doc(authCtr.cUser.id).update({
        'appointments': appointments,
      }).then((value) async {
        print('## appointment declined');
        showSnack('appointment declined',color:Colors.black54);
      }).catchError((error) async {
        showSnack('appointment declining error',color: Colors.redAccent.withOpacity(0.8));
      });
    }
  });
}

void acceptAppoi(appoiID) {
  usersColl
      .doc(authCtr.cUser.id)
      .get()
      .then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> appointments = documentSnapshot.get('appointments');

      appointments[appoiID]['new'] = false;

      await usersColl.doc(authCtr.cUser.id).update({
        'appointments': appointments,
      }).then((value) async {
        print('## appointment accepted');
        showSnack('appointment accepted');
      }).catchError((error) async {
        showSnack('appointment accepting error',color:Colors.redAccent.withOpacity(0.8));
      });
    }
  });
}
void openNotif(notifID) {
  usersColl
      .doc(authCtr.cUser.id)
      .get()
      .then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> notifications = documentSnapshot.get('notifications');

      notifications[notifID]['new'] = false;

      await usersColl.doc(authCtr.cUser.id).update({
        'notifications': notifications,
      }).then((value) async {
        //showSnack('appointment accepted');
      }).catchError((error) async {
        //showSnack('appointment accepting error',color:Colors.redAccent.withOpacity(0.8));
      });
    }
  });
}
void deleteNotif(notifID) {
  usersColl.doc(authCtr.cUser.id)
      .get()
      .then((DocumentSnapshot documentSnapshot) async {
    if (documentSnapshot.exists) {
      Map<String, dynamic> notifications = documentSnapshot.get('notifications');


      notifications.remove(notifID);

      await usersColl.doc(authCtr.cUser.id).update({
        'notifications': notifications,
      }).then((value) async {
        print('## notif deleted');
        //showSnack('appointment declined',color:Colors.black54);
      }).catchError((error) async {
        print('## notif delete failed');

        //showSnack('appointment declining error',color: Colors.redAccent.withOpacity(0.8));
      });
    }
  });
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
