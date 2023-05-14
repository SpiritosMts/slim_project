/// show loading (while verifying user account)

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/main.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/manager/styles.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _VerifySigningInState();
}

class _VerifySigningInState extends State<LoadingScreen> {
  // StreamSubscription<User?>? user;
  //BrUser cUser = BrUser();

  late bool canShowCnxFailed;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    canShowCnxFailed = true;

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkCnx();
    });
  }

  /// check connection state
  checkCnx() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      /// connected to internet
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('## connected');
        //await getPrivateData();

        //MyVoids().showTos('Connecté',color: Colors.green[500]);
        timer.cancel();
        authCtr.fetchUser();

        /// => next route < LOGIN (if no user logged in found)  / HOME (user found) >
      }

      /// failed to connect to internet
    } on SocketException catch (_) {
      print('## not connected');
      if (canShowCnxFailed) {
        showVerifyConnexion();

        if (this.mounted) {
          setState(() {
            canShowCnxFailed = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backGroundTemplate(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                ),

                /// Logo Image
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    width: 170,
                    height: 170,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // text
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(),
                    child: appNameText(),
                  ),
                ),
                // check your cnx
                !canShowCnxFailed
                    ? Column(
                        children: [
                          Text(
                            'please verify network'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: primaryColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(
                            height: 100.h * .1,
                          ),
                        ],
                      )
                    : Container(),

                ///loading
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: SizedBox(
                      width: 100.w * .3,
                      height: 100.w * .3,
                      child: const LoadingIndicator(
                        indicatorType: Indicator.circleStrokeSpin,
                        colors: [primaryColor],
                        strokeWidth: 6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
