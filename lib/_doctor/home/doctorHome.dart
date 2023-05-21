import 'package:flutter/material.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:smart_care/_doctor/home/doctorHome_ctr.dart';
import 'package:smart_care/_doctor/home/patientChart.dart';
import 'package:smart_care/_doctor/notifications/notifications.dart';
import 'package:smart_care/_doctor/patientsList/allPatients.dart';
import 'package:smart_care/_doctor/patientsList/myPatients.dart';
import 'package:smart_care/manager/auth/profile_manage/settings.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/manager/styles.dart';

import '../../manager/myUi.dart';
import '../appointment/get_appois.dart';

class DoctorHome extends StatefulWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  //final DoctorHomeCtr gc = Get.put<DoctorHomeCtr>(DoctorHomeCtr());
  //final DoctorHomeCtr gc = Get.find<DoctorHomeCtr>();


  @override
  void initState() {
    dcCtr.bottomBarController.stream.listen((opened) {
      debugPrint('## Bottom bar ${opened ? 'opened' : 'closed'}');
    });

    super.initState();
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
      builder: (gc) {
        return Scaffold(

          body: backGroundTemplate(
            child: IndexedStack(
              index: gc.currentScreenIndex,
              children: screens
            ),
          ),
          bottomNavigationBar: BottomBarWithSheet(
            onSelectItem: (index) {
              gc.selectScreen(index);
            },
            sheetChild: GetAppointments(),
            items: itemsIcons,
            controller: dcCtr.bottomBarController,
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
