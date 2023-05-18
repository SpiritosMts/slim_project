//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:smart_care/manager/auth/authCtr.dart';
// import 'package:smart_care/manager/myUi.dart';
// import 'package:smart_care/manager/myVoids.dart';
//
// import '../manager/styles.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class doctorChat extends StatefulWidget {
//   const doctorChat({Key? key}) : super(key: key);
//
//   @override
//   State<doctorChat> createState() => _doctorChatState();
// }
//
// class _doctorChatState extends State<doctorChat> {
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Open Chat with"),
//         centerTitle: true,
//         backgroundColor: appbarColor,
//         elevation: 10,
//       ),
//       body: backGroundTemplate(
//         child: GetBuilder<AuthController>(
//           builder: (_) {
//             return (dcCtr.myPatientsMap.isNotEmpty)
//               ? ListView.builder(
//               itemExtent: 130,
//               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//               shrinkWrap: true,
//               itemCount: dcCtr.myPatientsMap.length,
//               itemBuilder: (BuildContext context, int index) {
//                 String key = dcCtr.myPatientsMap.keys.elementAt(index);
//                 return patientCard(dcCtr.myPatientsMap[key]!,authCtr.cUser.patients);
//               }
//           ):dcCtr.loadingUsers?
//           Center(
//             child: CircularProgressIndicator(),
//           )
//               :Center(
//             child: Text('no patients found', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
//               textStyle:  TextStyle(
//                   fontSize: 27  ,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w700
//               ),
//             )),
//           );
//           },
//
//         ),
//       )
//
//     );
//   }
// }
