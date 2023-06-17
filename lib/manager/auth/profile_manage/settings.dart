import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/manager/styles.dart';

import '../../firebaseVoids.dart';
import '../../myLocale/myLocaleCtr.dart';

// class Settings extends StatefulWidget {
//   @override
//   State<Settings> createState() => _SettingsState();
// }
// class _SettingsState extends State<Settings> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         centerTitle: true,
//         backgroundColor: appbarColor,
//         title: Text('Settings'.tr),
//         //bottom: appBarUnderline(),
//       ),
//       body: backGroundTemplate(
//         child: SettingsList(
//
//           lightTheme: const SettingsThemeData(
//             dividerColor: hintYellowColHex,
//             titleTextColor: yellowColHex,
//             leadingIconsColor: yellowColHex,
//             trailingTextColor: hintYellowColHex2,
//             settingsListBackground: blueColHex,
//             //settingsSectionBackground: Colors.lightBlueAccent,
//             settingsTileTextColor: hintYellowColHex2,
//             tileHighlightColor: hintYellowColHex,
//           ),
//
//           //shrinkWrap: true,
//
//           //applicationType: ApplicationType.cupertino,
//           contentPadding: EdgeInsets.all(11),
//
//           sections: [
//             ///common
//             SettingsSection(
//               //margin: EdgeInsetsDirectional.all(20),
//              // title: Text('general settings'.tr),
//               tiles: [
//                 SettingsTile(
//                   trailing: Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     color: _arrowColor,
//                   ),
//                   title: Text('Language'.tr),
//                   value: Text(lang.tr),
//                   leading: const Icon(Icons.language),
//                   onPressed: (BuildContext context) {
//                     showLanguageDialog(context);
//                   },
//                 ),
//                 ///dark mode
//                 SettingsTile.switchTile(
//                   //activeSwitchColor: _activeSwitchColor,
//                   title: Text('Dark Mode'.tr),
//                   leading: const Icon(Icons.dark_mode),
//                   enabled: true,
//                   initialValue: true,
//                   onToggle: (val) {
//                     setState(() {
//                       //themeGc.onSwitch(val);
//                     });
//                   },
//                 ),
//
//                 ///other settings
//                 // SettingsTile.switchTile(
//                 //
//                 //     activeSwitchColor: _activeSwitchColor,
//                 //     title: Text('Custom theme'),
//                 //     leading: Icon(Icons.format_paint),
//                 //     enabled: true,
//                 //     initialValue: theme,
//                 //     onToggle: (value) {
//                 //       setState(() {
//                 //         theme = value;
//                 //       });
//                 //     },
//                 //     onPressed: (value) {}
//                 // ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

class Settings extends StatefulWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  State<Settings> createState() =>
      _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool useCustomTheme = false;

  DevicePlatform selectedPlatform = DevicePlatform.device;
  MyLocaleCtr langGc = Get.find<MyLocaleCtr>();
  //MyThemeCtr themeGc = Get.find<MyThemeCtr>();
  bool theme = false;
  bool darkMode = false;
  bool background = false;
  bool notification = false;
  final emailFormKey = GlobalKey<FormState>();
  final nameFormKey = GlobalKey<FormState>();
  final pwdFormKey = GlobalKey<FormState>();
  final TextEditingController newEmailCtr =  TextEditingController();
  final TextEditingController newNameCtr =  TextEditingController();
  final TextEditingController newPwdCtr =  TextEditingController();

  //Color _activeSwitchColor = yellowColHex;
  Color _arrowColor = primaryColor;
  String lang = 'select language';

  @override
  void initState() {
    super.initState();
    //print('## initState Settings');

    switch (currLang) {
      case 'ar':
        lang = 'arabic';
        break;
      case 'fr':
        lang = 'french';
        break;
      default:
        lang = 'english';
    }
    Future.delayed(Duration.zero, () {
      setState(() {});
    });
  }

  languageList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 35.0),

          child:Text('choose language'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
            textStyle:  TextStyle(
                fontSize: 25  ,
                color: accentColor0,
                fontWeight: FontWeight.w700
            ),
          ),),
        ),
        ListTile(
          title: Text('english'.tr),
          textColor: accentColor,
          onTap: () {
            langGc.changeLang('en');
            setState(() {});
            lang = 'english';
            Get.back();
          },
        ),
        const Divider(
          color: accentColor,
          thickness: 1,
        ),
        ListTile(
          title: Text('arabic'.tr),
          textColor: accentColor,
          onTap: () {
            langGc.changeLang('ar');
            setState(() {});
            lang = 'arabic';
            Get.back();
          },
        ),
        const Divider(
          color: accentColor,
          thickness: 1,
        ),
        ListTile(
          title: Text('french'.tr),
          textColor: accentColor,
          onTap: () {
            langGc.changeLang('fr');
            setState(() {});
            lang = 'french';
            Get.back();
          },
        ),
      ],
    );
  }

  showLanguageDialog(ctx) {
    showDialog(
      barrierDismissible: true,
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: dialogsCol,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            return SizedBox(
              height: 100.h / 2,
              width: 100.w  ,
              child: languageList(),
            );
          },
        ),
      ),
    );
  }


  /// ####################################################"""

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,
        elevation: 10,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Settings'.tr),
      ),
      body: SettingsList(

        platform: selectedPlatform,
        // lightTheme: !useCustomTheme
        //     ? null
        //     : SettingsThemeData(
        //   dividerColor: Colors.red,
        //   tileDescriptionTextColor: Colors.yellow,
        //   leadingIconsColor: Colors.pink,
        //   settingsListBackground: primaryColor,
        //   settingsSectionBackground: Colors.green,
        //   settingsTileTextColor: Colors.tealAccent,
        //   tileHighlightColor: Colors.blue,
        //   titleTextColor: Colors.cyan,
        //   trailingTextColor: Colors.deepOrangeAccent,
        // ),
        // darkTheme: !useCustomTheme
        //     ? null
        //     : SettingsThemeData(
        //   dividerColor: Colors.red,
        //   tileDescriptionTextColor: Colors.yellow,
        //   leadingIconsColor: Colors.pink,
        //   settingsListBackground: primaryColor,
        //   settingsSectionBackground: Colors.green,
        //   settingsTileTextColor: Colors.tealAccent,
        //   tileHighlightColor: Colors.blue,
        //   titleTextColor: Colors.cyan,
        //   trailingTextColor: Colors.deepOrangeAccent,
        // ),
        sections: [
          SettingsSection(
            title: Text('Common'.tr,style: TextStyle(color: primaryColor),),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.language,color: settingIconColor,),
                title: Text('Language'.tr),
                value: Text(lang.tr),
                onPressed: (tap){
                  showLanguageDialog(context);
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.cloud_outlined,color: settingIconColor,),
                title: Text('Environment'.tr),
                value: Text('Production'.tr),
              ),
              SettingsTile.switchTile(
                onToggle: (value) {
                  setState(() {
                    useCustomTheme = value;
                  });
                },
                initialValue: useCustomTheme,
                leading: Icon(Icons.format_paint,color: settingIconColor,),
                title: Text('Enable custom theme'.tr),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Account'.tr,style: TextStyle(color: primaryColor),),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.phone,color: settingIconColor,),
                title: Text('Phone number'.tr),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.mail,color: settingIconColor,),
                title: Text('Email'.tr),
                enabled: true,
                onPressed: (val){
                  showChangeProp(
                      icon: Icon(Icons.email,size: 45,),
                      //title:'Change Name'.tr,
                      body: Column(
                        children: [
                          Text('Change Email'.tr,style: TextStyle(
                              fontSize: 22
                          ),),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Form(
                              key: emailFormKey,
                              child: customTextField
                                (
                                color: accentColor0,
                                controller: newEmailCtr,
                                labelText: 'Email'.tr,
                                hintText: 'Enter your email'.tr,
                                icon: Icons.email,
                                isPwd: false,
                                obscure: false,
                                onSuffClick: (){},
                                validator: (value) {
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
                            ),
                          ),
                          SizedBox(height: 20,),

                        ],
                      ),
                      btnOkPress: (){
                        if (emailFormKey.currentState!.validate()) {
                          changeUserEmail(newEmailCtr.text);
                          newEmailCtr.clear();
                          Get.back();
                        }
                      }
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.person,color: settingIconColor,),
                title: Text('Name'.tr),
                enabled: true,
                onPressed: (val){
                  showChangeProp(
                    icon: Icon(Icons.person,size: 45,),
                    //title:'Change Name'.tr,
                    body: Column(
                      children: [
                        Text('Change Name'.tr,style: TextStyle(
                          fontSize: 22
                        ),),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Form(
                            key: nameFormKey,
                            child: customTextField
                              (
                              color: accentColor0,
                            controller: newNameCtr,
                            labelText: 'Name'.tr,
                            hintText: 'Enter your name'.tr,
                            icon: Icons.person,
                            isPwd: false,
                            obscure: false,
                            onSuffClick: (){},
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "name can't be empty".tr;
                              }
                              else {
                                return null;
                              }
                            },
                  ),
                          ),
                        ),
                        SizedBox(height: 20,),

                      ],
                    ),
                    btnOkPress: (){
                      if (nameFormKey.currentState!.validate()) {
                        changeUserName(newNameCtr.text);
                        newNameCtr.clear();
                        Get.back();
                      }
                    }
                  );
                },
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.logout,color: settingIconColor,),
                title: Text('Sign out'.tr),
                onPressed: (val){
                  authCtr.signOut();
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('Security'.tr,style: TextStyle(color: primaryColor),),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (_) {},
                initialValue: true,
                leading: Icon(Icons.phonelink_lock,color: settingIconColor,),
                title: Text('Lock app in background'.tr),
              ),
              SettingsTile.switchTile(
                onToggle: (_) {},
                initialValue: true,
                leading: Icon(Icons.fingerprint,color: settingIconColor,),
                title: Text('Use fingerprint'.tr),
                description: Text(
                  'Allow application to access stored fingerprint IDs'.tr,
                ),
              ),
              SettingsTile.navigation(

                leading: Icon(Icons.lock,color: settingIconColor,),
                title: Text('Change password'.tr),
                onPressed: (val){
                  showChangeProp(
                      icon: Icon(Icons.lock,size: 45,),
                      //title:'Change Name'.tr,
                      body: Column(
                        children: [
                          Text('Change Password'.tr,style: TextStyle(
                              fontSize: 22
                          ),),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Form(
                              key: pwdFormKey,
                              child: customTextField
                                (
                                color: accentColor0,
                                controller: newPwdCtr,
                                labelText: 'Password'.tr,
                                hintText: 'Enter your password'.tr,
                                icon: Icons.lock,
                                isPwd: false,
                                obscure: false,
                                onSuffClick: (){},
                                validator: (value) {
                                  RegExp regex = RegExp(r'^.{6,}$');

                                  if (value!.isEmpty) {
                                    return "password can't be empty".tr;
                                  }
                                  if (!regex.hasMatch(value)) {
                                    return ('Enter a valid password of at least 6 characters'.tr);
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),

                        ],
                      ),
                      btnOkPress: (){
                        if (pwdFormKey.currentState!.validate()) {
                          changeUserEmail(newPwdCtr.text);
                          newPwdCtr.clear();
                          Get.back();
                        }
                      }
                  );
                },

              ),
              SettingsTile.switchTile(
                onToggle: (_) {},
                initialValue: true,
                leading: Icon(Icons.notifications_active,color: settingIconColor,),
                title: Text('Enable notifications'.tr),
              ),
            ],
          ),
          SettingsSection(
            title: Text('Misc'.tr,style: TextStyle(color: primaryColor),),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: Icon(Icons.description,color: settingIconColor,),
                title: Text('Terms of Service'.tr),
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.collections_bookmark,color: settingIconColor,),
                title: Text('Open source license'.tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
