import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/manager/styles.dart';

import '../../myLocale/myLocaleCtr.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}
class _SettingsState extends State<Settings> {
  MyLocaleCtr langGc = Get.find<MyLocaleCtr>();
  //MyThemeCtr themeGc = Get.find<MyThemeCtr>();
  bool theme = false;
  bool darkMode = false;
  bool background = false;
  bool notification = false;

  //Color _activeSwitchColor = yellowColHex;
  Color _arrowColor = primaryColor;
  String lang = '';

  @override
  void initState() {
    super.initState();
    print('## initState Settings');

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

          child:Text(            'choose language'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
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
              height: 100.h / 2.5,
              width: 100.w  ,
              child: languageList(),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: appbarColor,
        title: Text('Settings'.tr),
        //bottom: appBarUnderline(),
      ),
      body: backGroundTemplate(
        child: SettingsList(

          lightTheme: const SettingsThemeData(
            dividerColor: hintYellowColHex,
            titleTextColor: yellowColHex,
            leadingIconsColor: yellowColHex,
            trailingTextColor: hintYellowColHex2,
            settingsListBackground: blueColHex,
            //settingsSectionBackground: Colors.lightBlueAccent,
            settingsTileTextColor: hintYellowColHex2,
            tileHighlightColor: hintYellowColHex,
          ),

          //shrinkWrap: true,

          //applicationType: ApplicationType.cupertino,
          contentPadding: EdgeInsets.all(11),

          sections: [
            ///common
            SettingsSection(
              //margin: EdgeInsetsDirectional.all(20),
             // title: Text('general settings'.tr),
              tiles: [
                SettingsTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _arrowColor,
                  ),
                  title: Text('Language'.tr),
                  value: Text(lang.tr),
                  leading: const Icon(Icons.language),
                  onPressed: (BuildContext context) {
                    showLanguageDialog(context);
                  },
                ),
                ///dark mode
                SettingsTile.switchTile(
                  //activeSwitchColor: _activeSwitchColor,
                  title: Text('Dark Mode'.tr),
                  leading: const Icon(Icons.dark_mode),
                  enabled: true,
                  initialValue: true,
                  onToggle: (val) {
                    setState(() {
                      //themeGc.onSwitch(val);
                    });
                  },
                ),

                ///other settings
                // SettingsTile.switchTile(
                //
                //     activeSwitchColor: _activeSwitchColor,
                //     title: Text('Custom theme'),
                //     leading: Icon(Icons.format_paint),
                //     enabled: true,
                //     initialValue: theme,
                //     onToggle: (value) {
                //       setState(() {
                //         theme = value;
                //       });
                //     },
                //     onPressed: (value) {}
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class CrossPlatformSettingsScreen extends StatefulWidget {
  const CrossPlatformSettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CrossPlatformSettingsScreen> createState() =>
      _CrossPlatformSettingsScreenState();
}

class _CrossPlatformSettingsScreenState
    extends State<CrossPlatformSettingsScreen> {
  bool useCustomTheme = false;

  DevicePlatform selectedPlatform = DevicePlatform.device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarColor,

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
                value: Text('English'.tr),
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
                title: Text('Enable custom theme'),
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
