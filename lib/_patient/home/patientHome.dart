import 'package:flutter/material.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/_doctor/notifications/notifications.dart';
import 'package:smart_care/_patient/appointment/create_appoi.dart';
import 'package:smart_care/_patient/attachedDoctor/attachedDoctor.dart';
import 'package:smart_care/_patient/home/myChart.dart';
import 'package:smart_care/manager/auth/profile_manage/settings.dart';
import 'package:smart_care/manager/styles.dart';

import '../../manager/myUi.dart';
import '../../manager/myVoids.dart';
import '../advices/advices.dart';
import 'patientHome_ctr.dart';

class PatientHome extends StatefulWidget {
  const PatientHome({Key? key}) : super(key: key);

  @override
  State<PatientHome> createState() => _PatientHomeState();
}

class _PatientHomeState extends State<PatientHome> {
  //final PatientHomeCtr gc = Get.put<PatientHomeCtr>(PatientHomeCtr());


  @override
  void initState() {
    ptCtr.bottomBarController.stream.listen((opened) {
      debugPrint('## Bottom bar ${opened ? 'opened' : 'closed'}');
    });
    super.initState();
  }





  List<Widget> screens = [
    MyChart(),
    Advices(),//some advices
    //
    /// appoin
    AttachedDoctor(),//
    Settings(),
    //
    Notifications(),

  ];
  List<BottomBarWithSheetItem> itemsIcons =  [
    BottomBarWithSheetItem(icon: Icons.monitor_heart),
    BottomBarWithSheetItem(icon: Icons.health_and_safety),
    BottomBarWithSheetItem(icon: Icons.person),
    BottomBarWithSheetItem(icon: Icons.settings),
  ];
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<PatientHomeCtr>(
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

            sheetChild: CreateAppoi(),
            items: itemsIcons,
            controller: ptCtr.bottomBarController,
            mainActionButtonTheme: MainActionButtonTheme(
                icon: Icon(Icons.library_books_sharp,color: Colors.white,)
            ),
            bottomBarTheme:  BottomBarTheme(
              heightOpened:80.h ,
              heightClosed:65 ,
              mainButtonPosition: MainButtonPosition.middle,
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
