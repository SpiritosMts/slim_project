
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/manager/auth/register.dart';
import 'package:smart_care/manager/myUi.dart';

class SelectAccountType extends StatefulWidget {

  @override
  State<SelectAccountType> createState() => _SelectAccountTypeState();
}

class _SelectAccountTypeState extends State<SelectAccountType> {

  Map gglMap = Get.arguments;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backGroundTemplate(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(height: 25,),
          Container(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Column(children: [
                Image.asset(
                  "assets/images/Landing page – 2.png",
                  width: 38.w,
                ),
                SizedBox(height: 30),
              ])),
          Container(
            child:  appNameText()
          ),
          Container(
            margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
            child:  Text(
              "Please tell us who you are ?".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(240, 255, 255, 255),
                  fontWeight: FontWeight.w400),
            ),
          ),
          Column(
            children: [
              //DotorButton
              Container(
                width: 90.w,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Color(0x2800000),
                    elevation: 0.1,
                    side: const BorderSide(width: 1.5, color: Colors.white),
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () async {

                    Get.to(()=>Register(),arguments: {'isPatient': false,'gglMap':gglMap});
                  },
                  child:  Text(
                    "Doctor".tr,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              //PatientButton
              Container(
                width: 90.w,
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: OutlinedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Color(0x2800000),
                    elevation: 0.1,
                    side: const BorderSide(width: 1.5, color: Colors.white),
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Get.to(()=>Register(),arguments: {'isPatient': true,'gglMap':gglMap});
                  },
                  child:  Text(
                    "Patient".tr,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )
        ]),
      )
    );
  }
}
