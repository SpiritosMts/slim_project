import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/manager/auth/register.dart';
import 'package:smart_care/manager/auth/registerSelectType.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';

import '../styles.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController forgotEmailCtr =  TextEditingController();




  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFF75b0b5),
      child: Scaffold(
        body: backGroundTemplate(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),

                  Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  /// animated_text
                  SizedBox(
                    height: 40,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Forgot Your password ?'.tr,
                            textStyle: GoogleFonts.indieFlower(
                                textStyle:  TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800
                                ),
                            ),
                            speed: const Duration(
                              milliseconds: 80,
                            )),
                      ],
                      onTap: () {
                        //debugPrint("Welcome back!");
                      },
                      isRepeatingAnimation: true,
                      totalRepeatCount: 40,
                    ),
                  ),
                  SizedBox(
                    height: 7.h,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                    ),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: [

                          customTextField(
                            controller: forgotEmailCtr,
                            labelText: 'Email'.tr,
                            hintText: 'Enter your email'.tr,
                            icon: Icons.email,
                            isPwd: false,
                            obscure: false,
                            onSuffClick: (){},
                            validator: (value) {
                              RegExp regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
                              if (value!.isEmpty) {
                                return "email can't be empty".tr;
                              }
                              if (!EmailValidator.validate(value!)) {
                                return ("Enter a valid email".tr);
                              } else {
                                return null;
                              }
                            },
                          ),



                          SizedBox(
                            height: 30,
                          ),
                          customButton(
                            btnOnPress: () async {
                              if (formkey.currentState!.validate()) {
                                authCtr.ResetPss(forgotEmailCtr.text);
                              }
                              },
                            textBtn: 'Send'.tr,
                            btnWidth: 110,
                            icon: Icon(
                              Icons.login,
                              color: Colors.white.withOpacity(0.7),
                              size: 19,
                            ),
                            reversed: true,
                            borderCol: customColor1,
                            fillCol: appbarColor.withOpacity(0.5),
                          ),

                          SizedBox(
                            height: 14,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
