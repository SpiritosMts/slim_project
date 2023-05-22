import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smart_care/main.dart';
import 'package:smart_care/manager/auth/login.dart';
import 'package:smart_care/manager/myLocale/myLocaleCtr.dart';
import 'package:smart_care/manager/styles.dart';



class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  MyLocaleCtr langGc = Get.find<MyLocaleCtr>();

  void _onIntroEnd(context) {
    Get.offAll(Login());
    int introTimes = sharedPrefs!.getInt('intro') ?? 0;
    introTimes ++;
    sharedPrefs!.setInt('intro',introTimes);
    print('## introTimes_set_<$introTimes>');
  }

  // Widget _buildFullscreenImage() {
  //   return Image.asset(
  //     'assets/images/fullscreen.jpg',
  //     fit: BoxFit.cover,
  //     height: double.infinity,
  //     width: double.infinity,
  //     alignment: Alignment.center,
  //   );
  // }

  Widget _buildImage(String assetName, [double width = 200]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    var pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      //pageColor: appbarColor.withOpacity(0.2),
      imagePadding: EdgeInsets.zero,

    );

    return IntroductionScreen(

      key: introKey,
      globalBackgroundColor: introBackColor,
      allowImplicitScrolling: true,
      //autoScrollDuration: 3000,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: _buildImage('logo.png', 30),
          ),
        ),
      ),
      // globalFooter: SizedBox(
      //   width: double.infinity,
      //   height: 60,
      //   child: ElevatedButton(
      //     child: const Text(
      //       'Let\'s go right away!',
      //       style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      //     ),
      //     onPressed: () => _onIntroEnd(context),
      //   ),
      // ),
      pages: [
        ///translation
        PageViewModel(
          title: "Language".tr,
          body: "Select your preferred language".tr,
          image: Padding(
            padding: const EdgeInsets.only(top: 57.0),
            child: Image.asset('assets/images/translate.png', width: 160),
          ),
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 130,
                child: ElevatedButton(

                  onPressed: () {
                    langGc.changeLang('en');
                    setState(() {

                    });
                  },
                  style: ElevatedButton.styleFrom(

                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child:  Text(
                    'English'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                width: 130,

                child: ElevatedButton(
                  onPressed: () {
                    langGc.changeLang('ar');
                    setState(() {

                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child:  Text(
                    'Arabic'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 6,
            imageFlex: 6,
            safeArea: 80,
          ),
        ),

        PageViewModel(
            title: "Real-time Tracking".tr,
          body: "Stay informed about your heart health ,real-time heart rate monitoring at your fingertips.".tr,
          image: _buildImage('heart.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Secure Communication".tr,
          body:
          "connect with your assigned doctor through a secure and private chat system for personalized consultations and timely support.".tr,
          image: _buildImage('chat.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(//search
          title: "Intelligent Insights".tr,
          body:
          "Our advanced AI model intelligently adapts heart rate thresholds based on your activities and ensuring accurate health monitoring.".tr,
          image: _buildImage('ai.png'),
          decoration: pageDecoration,
        ),

        // PageViewModel(
        //   title: 'Let\'s Begin ... '.tr,
        //   bodyWidget: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children:  [
        //       Text("Click on".tr, style: bodyStyle),
        //       SizedBox(width: 7),
        //       SizedBox(
        //         width: 20,
        //         child: Image.asset(
        //                'assets/images/add.png',
        //         ),
        //       ),
        //       SizedBox(width: 7),
        //       Text("to add new category".tr, style: bodyStyle),
        //
        //     ],
        //   ),
        //   decoration: pageDecoration.copyWith(
        //     bodyFlex: 2,
        //     imageFlex: 4,
        //     bodyAlignment: Alignment.bottomCenter,
        //     imageAlignment: Alignment.topCenter,
        //   ),
        //   //image: _buildImage('transaction.png'),
        //
        //   image: Padding(
        //     padding: const EdgeInsets.only(top: 57.0),
        //     child: Image.asset('assets/images/operator.png', width: 200),
        //   ),
        //   reverse: true,
        // ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done:  Text('Done'.tr, style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

