import 'package:flutter/material.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/_doctor/home/doctorHome_ctr.dart';
import 'package:smart_care/_doctor/home/patientChart.dart';
import 'package:smart_care/_doctor/notifications/notifications.dart';
import 'package:smart_care/_doctor/patientsList/allPatients.dart';
import 'package:smart_care/_doctor/patientsList/myPatients.dart';
import 'package:smart_care/_doctor/patientsList/patientInfo.dart';
import 'package:smart_care/_patient/advices/advices.dart';
import 'package:smart_care/chatSystem/chatList.dart';
import 'package:smart_care/manager/auth/profile_manage/settings.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/manager/styles.dart';

import '../../_patient/attachedDoctor/attachedDoctor.dart';
import '../../manager/myUi.dart';
import '../appointment/get_appois.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  final DoctorHomeCtr gc = Get.put<DoctorHomeCtr>(DoctorHomeCtr());

  final _bottomBarController = BottomBarWithSheetController(initialIndex: 0);

  @override
  void initState() {
    _bottomBarController.stream.listen((opened) {
      debugPrint('## Bottom bar ${opened ? 'opened' : 'closed'}');
    });
    super.initState();
  }


  Widget sheet(){

    return Center(
      child: Text('no appointments yet', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
        textStyle:  TextStyle(
            fontSize: 23  ,
            color: Colors.white,
            fontWeight: FontWeight.w700
        ),
      )),
    );
  }


  List<Widget> screens = [
    PatientChart(),
    AllPatientsView(),

    // appoin
    MyPatients(),//with chat
    Settings(),

    Notifications(),

  ];

  List<BottomBarWithSheetItem> itemsIcons =  [
    BottomBarWithSheetItem(icon: Icons.monitor_heart),
    BottomBarWithSheetItem(icon: Icons.search),
    BottomBarWithSheetItem(icon: Icons.groups),
    BottomBarWithSheetItem(icon: Icons.settings),
  ];
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<DoctorHomeCtr>(
      builder: (context) {
        return Scaffold(

          body: backGroundTemplate(
            child: IndexedStack(
              index: dcCtr.currentScreenIndex,
              children: screens
            ),
          ),
          bottomNavigationBar: BottomBarWithSheet(
            onSelectItem: (index) {
              dcCtr.selectScreen(index);
            },
            sheetChild: GetAppointments(),
            items: itemsIcons,
            controller: _bottomBarController,
            mainActionButtonTheme: MainActionButtonTheme(
              icon: Icon(Icons.library_books_sharp,color: Colors.white,)
            ),
            /// theme //
            bottomBarTheme: const BottomBarTheme(
              mainButtonPosition: MainButtonPosition.middle,
              heightClosed:65 ,

              selectedItemIconColor: Colors.white,
              //height: 50,
              itemIconSize: 25,
              decoration: BoxDecoration(
                color: appbarColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
              itemIconColor: Colors.white60,
              itemTextStyle: TextStyle(
                color: Colors.grey,
                fontSize: 10.0,
              ),
              selectedItemTextStyle: TextStyle(
                color: Colors.blue,
                fontSize: 10.0,
              ),
            ),

          ),
        );
      }
    );
  }
}
