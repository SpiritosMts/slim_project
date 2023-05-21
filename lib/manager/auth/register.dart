import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_care/manager/auth/login.dart';
import 'package:smart_care/manager/auth/verifyEmail.dart';
import 'package:smart_care/manager/firebaseVoids.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/manager/myUi.dart';

import '../myVoids.dart';
import '../styles.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool _isPwdObscure = true;


  final emailTec = TextEditingController();
  final passwordTec = TextEditingController();
  final nameTec = TextEditingController();

  final phoneTec = TextEditingController();
  final espCodeTec = TextEditingController();
  final specialityTec = TextEditingController();
  final addressTec = TextEditingController();
  final ageTec = TextEditingController();
  String sex = 'Male';


  GlobalKey<FormState> _registerFormkey = GlobalKey<FormState>();
  Map gglMap = Get.arguments['gglMap'];
  bool isPatient = Get.arguments['isPatient'];
  double spaceFields= 25;


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
         emailTec.text= gglMap['gglEmail'];
        nameTec.text= gglMap['gglName'];
        print('## gglEmail: ${gglMap['gglEmail']} / gglName: ${gglMap['gglName']}');
      });
      //streamingDoc(usersColl,authCtr.cUser.id!);
    });

  }

  signUp() async {
    if (_registerFormkey.currentState!.validate()) {
      showLoading(text: 'Connecting'.tr);

      Map<String,dynamic> addUserMap={
        'name': nameTec.text,
    'email': emailTec.text,
    'pwd': passwordTec.text,
    'joinDate': todayToString(),
    'verified': verifyAnyCreatedAccount? true:  false,

    'isAdmin': false,
    'accepted': false,
    'espCode': isPatient ?espCodeTec.text:'',
    'speciality': specialityTec.text,
    'age': ageTec.text,
    'address': addressTec.text,
    'number': phoneTec.text,
    'sex': sex,
    'role': isPatient ? 'patient' : 'doctor',

    'doctorAttachedID': '',//pat <no-doc>
    'health': {},//pat
    'appointments': {},//doc
    'notifications': {},//doc
    'patients': [],//doc

    };


      if(gglMap['gglEmail']!=''){
        /// add user to cloud
        addDocument(
          fieldsMap: addUserMap,
            collName: usersCollName,
          addID: true,
          addRealTime: true,
          docPathRealtime: 'patients',
          realtimeMap: {
            "bpm_once": 0,
          },
        ).then((value) {

          Get.back();//hide loading
          Future.delayed(const Duration(milliseconds: 3000), () async {
              await authCtr.getUserInfoByEmail(gglMap['gglEmail']).then((value) {
                authCtr.checkUserVerif(isGoogle: true);
              });
            });
          showSuccess(sucText: 'your account has been created successfully'.tr);
        }).catchError((error) => print("Failed to create new user<google> doc: $error"));
      }else{
        authCtr.signUp(emailTec.text, passwordTec.text, onSignUp: () {
          /// add user to cloud
          addDocument(fieldsMap: addUserMap, collName: usersCollName).then((value) {
            Get.back();//hide loading
            verifyAnyCreatedAccount? Get.offAll(() => VerifyScreen()):Get.offAll(() => Login()) ;


            showSuccess(sucText: 'your account has been created successfully'.tr);
          }).catchError((error) => print("Failed to create new user doc: $error"));
        });

      }

    }
  }




  // /////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final selectedGender = ['Male', 'Female'];
    String? _selectedGender = 'Male';
    return Scaffold(
      body: backGroundTemplate(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Form(
            key: _registerFormkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Container(
                    child:  Text(
                      'Register'.tr,
                      style: TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      isPatient ? 'Patient'.tr : 'Doctor'.tr,
                      style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 30,
                          color: Color.fromARGB(143, 255, 255, 255),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30,),

                  /// /////////////////////////////////

                  //name
                  customTextField(
                    controller: nameTec,
                    labelText: 'Name'.tr,
                    hintText: 'Enter your name'.tr,
                    icon: Icons.person,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "name can\'t be empty".tr;
                      }
                     else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: spaceFields),
                  customTextField(
                    controller: emailTec,
                    labelText: 'Email'.tr,
                    hintText: 'Enter your email'.tr,
                    icon: Icons.email,
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
                  SizedBox(height: spaceFields),
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
                  SizedBox(height: spaceFields),
                  isPatient? customTextField(
                    textInputType: TextInputType.number,
                    controller: ageTec,
                    labelText: 'Age'.tr,
                    hintText: 'Enter your age'.tr,
                    icon: Icons.perm_contact_calendar ,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return "speciality can\'t be empty".tr;
                      }
                   else {
                        return null;
                      }
                    },
                  ):customTextField(
                    controller: specialityTec   ,
                    labelText: 'Speciality'.tr,
                    hintText: 'Enter your speciality'.tr,
                    icon: Icons.medical_services,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return "speciality can\'t be empty".tr;
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: spaceFields),
                  customTextField(
                    controller: addressTec,
                    labelText: 'Address'.tr,
                    hintText: 'Enter your address'.tr,
                    icon: Icons.home,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "address can\'t be empty".tr;
                      }
                     else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: spaceFields),
                  customTextField(
                    textInputType: TextInputType.number,

                    controller: phoneTec,
                    labelText: 'Phone'.tr,
                    hintText: 'Enter your number'.tr,
                    icon: Icons.email,
                    isPwd: false,
                    obscure: false,
                    onSuffClick: (){},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "number can\'t be empty".tr;
                      }
                     else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: spaceFields),
                  customTextField(
                    textInputType: TextInputType.text,

                    controller: espCodeTec,
                    labelText: 'Code'.tr,
                    hintText: 'Enter your esp code'.tr,
                    icon: Icons.qr_code,
                    isPwd: false,
                    obscure: false,
                    onSuffClick: (){},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "code can\'t be empty".tr;
                      }
                     else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: spaceFields),


                  ///sex
                  Container(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Colors.white38, width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: DropdownButtonFormField<String>(
                            //borderRadius: BorderRadius.circular(40),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.white38, fontSize: 14.5),
                              prefixIconConstraints: BoxConstraints(minWidth: 45),
                              prefixIcon: Icon(
                                Icons.male,
                                color: Colors.white70,
                                size: 22,
                              ),
                            ),
                            dropdownColor: customColor,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),

                            style: TextStyle(color: Colors.white70),
                            value: _selectedGender,
                            items: selectedGender.map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text('$gender'),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => sex = val!),
                          ),
                        ),
                      ),
                    ),
                  ),



                  ///Button signUp
                  Container(
                    //color: Colors.red,
                    width: 90.w,
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff024855),
                        shadowColor: Color(0x2800000),
                        elevation: 0.1,
                        side: const BorderSide(width: 1.5, color: Colors.white),
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          ),
                        ),
                      ),
                      onPressed: () => signUp(),
                      child: const Text(
                        "Create account",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

}
