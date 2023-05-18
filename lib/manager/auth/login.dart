import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/manager/auth/forgotPwd.dart';
import 'package:smart_care/manager/auth/register.dart';
import 'package:smart_care/manager/auth/registerSelectType.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';

import '../styles.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailTec = TextEditingController();
  final TextEditingController passwordTec = TextEditingController();
  bool _isPwdObscure = true;

  login() async {
    if (_loginFormKey.currentState!.validate()) {
      showLoading(text: 'Connecting'.tr);

      authCtr.signIn(emailTec.text, passwordTec.text, onSignIn: () async {
        await authCtr.getUserInfoByEmail(emailTec.text).then((value) {
          Get.back();
          authCtr.checkUserVerif();
        });
      });
      //authCtr.saveEnteredEmail(emailController.text);
    }
  }

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

                  /// logo Image
                  Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  /// animated_text
                  SizedBox(
                    height: 40,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText('Your health is a priority'.tr,
                            textStyle: GoogleFonts.indieFlower(
                                textStyle:  TextStyle(
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800
                                ),
                            ),
                            speed: const Duration(
                              milliseconds: 200,
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
                      key: _loginFormKey,
                      child: Column(
                        children: [

                          customTextField(
                            controller: emailTec,
                            labelText: 'Email'.tr,
                            hintText: 'Enter your email'.tr,
                            icon: Icons.email,
                            isPwd: false,
                            obscure: false,
                            onSuffClick: (){},
                            validator: (value) {
                              RegExp regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
                              if (value!.isEmpty) {
                                return "email can\'t be empty".tr;
                              }
                              if (!regex.hasMatch(value)) {
                                return ("Enter a valid email".tr);
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(height: 25),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              customTextField(
                                controller: passwordTec,
                                labelText: 'Password'.tr,
                                hintText: 'Enter your password'.tr,
                                icon: Icons.lock,
                                isPwd: true,
                                obscure: _isPwdObscure,
                                onSuffClick: (){
                                  setState(() {
                                    _isPwdObscure = !_isPwdObscure;
                                  });
                                },
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');
                                  if (value!.isEmpty) {
                                    return 'password can\'t be empty'.tr;
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ('Enter a valid password of at least 6 characters'.tr);
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              GestureDetector(
                                onTap: (){
                                  Get.to(()=>ForgotPassword());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                                  child: Text('forgot password ?'.tr,style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w400,
                                  ),),
                                ),
                              ),
                            ],
                          ),


                          SizedBox(
                            height: 30,
                          ),

                          /// google_signIn + signIn btn
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              customButton(
                                btnOnPress: () async {
                                  await authCtr.signInWithGoogle();
                                  },
                                textBtn: 'Google',
                                btnWidth: 110,
                                icon: Icon(
                                  Ionicons.logo_google,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 17,
                                ),
                                borderCol: customColor1,
                                fillCol: appbarColor.withOpacity(0.5),
                              ),
                              SizedBox(width: 10,),
                              customButton(
                                btnOnPress: () async {
                                  login();
                                },
                                textBtn: 'Login',
                                btnWidth: 110,
                                icon: Icon(
                                  Icons.login,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 19,
                                ),
                                borderCol: customColor1,
                                fillCol: appbarColor.withOpacity(0.5),
                              ),

                            ],
                          ),

                          SizedBox(
                            height: 14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('you have no account?'.tr,style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),),
                              TextButton(
                                onPressed: (() {
                                  Get.to(() => SelectAccountType(), arguments: {'gglName': '', 'gglEmail': ''});
                                }),
                                child: Text(
                                  'Sign Up'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
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
