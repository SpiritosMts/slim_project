import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/manager/styles.dart';

class VerifyScreen extends StatefulWidget {

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}
class _VerifyScreenState extends State<VerifyScreen> {

  late Timer timer;



  @override
  void initState() {
    authCurrUser!.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: refreshVerifInSec), (timer) {
      print('### verif timer refreshed;');
      authCtr.verifyUserEmail(timer);
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    print('### verif timer.cancel();');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //const SizedBox(height: 200),
          Center(
            child:  Container(

              //padding: EdgeInsets.all(40.0),
                //padding: EdgeInsets.only(right : 10.0,top: 30,bottom: 30),
                padding: EdgeInsets.all(0),
                child: Text('An email has been sent to'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      //height: 5,

                  ),

                )
            ),
          ),
          Center(
            child:  Container(
              //padding: EdgeInsets.all(40.0),
                //padding: EdgeInsets.only(right : 10.0,top: 30,bottom: 30),
                padding: EdgeInsets.all(30),
                child: Text('${authCurrUser!.email}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 18,
                      color: primaryColor
                      //height: 5,

                  ),

                )
            ),
          ),
          Center(
            child:  Container(
              //padding: EdgeInsets.all(40.0),
                //padding: EdgeInsets.only(right : 10.0,top: 30,bottom: 30),
                padding: EdgeInsets.all(0),
                child: Text('Please Verify'.tr,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                      //height: 5,

                  ),

                )
            ),
          ),

        ],
      ),
    );
  }


}