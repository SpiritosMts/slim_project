

import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/chatSystem/chatRoom.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/models/user.dart';

import '../_doctor/notifications/map.dart';
import '../_patient/advices/oneAdvice.dart';
import 'firebaseVoids.dart';
import 'myLocale/myLocaleCtr.dart';
import 'styles.dart';





Widget notifCard(String ind, Map<String, dynamic> notifInfo,) {
  bool newNotif = notifInfo['new'];
  String usrName = notifInfo['usrName'];
  String bpmVal = notifInfo['bpm'];
  String time = notifInfo['time'];
  String day = notifInfo['day'];
  String month = notifInfo['month'];

  double lat = double.parse(notifInfo['lat']);
  double lng = double.parse(notifInfo['lng']);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Container(
      height:  120,
      child: Stack(

        children: [





          Card(
            color: cardColor,
            elevation: 50,
            shadowColor: Colors.black,
            //color: dialogsCol.withOpacity(0.5),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: newNotif ? Colors.green : Colors.white38,
                    width: 3),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(top: 17.0),
              // child:Row(
              //   children: [
              //
              //   ],
              // ),
              child: ListTile(
                dense: false,
                //isThreeLine: false,
                leading: MonthSquare(day,month),
                title: Text(usrName,
                  maxLines: 1,
                  style: TextStyle(
                      color: newNotif ? newCardCol : Colors.grey,
                      fontWeight: FontWeight.w500,
                    fontSize: 20

                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text("Heart rate: $bpmVal bpm",
                      style: TextStyle(
                        //color: cardColor.withOpacity(0.85),
                        color: newNotif? newCardCol: Colors.white.withOpacity(0.80),
                        fontSize: 15,

                      ),),
                    SizedBox(height: 4),
                    Text("Time: ${time}",style: TextStyle(
                        color: Colors.white.withOpacity(0.80),
                        fontSize: 15,
                        fontWeight: FontWeight.w400


                    ),),
                  ],
                ),
              ),
            ),
          ),
         // if(authCtr.cUser.role == 'doctor')
           Positioned(
            bottom: 40,
            right: (currLang =='ar')? null:25,//english
            left: (currLang =='ar')? 25:null,//arabic
            child: CircleAvatar(
              backgroundColor: Colors.blueGrey,
              radius: 20,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.pin_drop_sharp,size: 22),
                color: Colors.white,
                onPressed: () {
                  Get.to(() => MapMarker(), arguments: {
                    'pos': LatLng(lat, lng),
                    'patName': usrName,
                  });
                  openNotif(ind);
                },
              ),
            ),
          ),
           Positioned(
            bottom: 13,
             right: (currLang =='ar')? null:13,//english
             left: (currLang =='ar')? 13:null,//arabic
            child:   GestureDetector(

              child: Icon(
                size: 20,
                Icons.close,
                //weight: 50,
                color: Colors.red.withOpacity(0.65),
              ),
              onTap: () {

                deleteNotif(ind);

              },
            ),

           ),


        ],
      ),
    ),
  );
}



///adviceCard
Widget adviceCard(advice, {bool newAdvice = false}) { //doctor

  Color itemCol = newAdvice ? Colors.green : Colors.white38;

  String title=advice['title'];
  String desc=advice['description'];
  return GestureDetector(
    onTap: () async {

      Get.to(()=>OneAdvice(body: desc.tr,title: title.tr,));
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100.w,
        height: 140,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: itemCol,
                      width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 5, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          advice['image'],
                          width: 65,
                          color:itemCol,
                        ),
                        SizedBox(width: 13),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: SizedBox(

                                width: 51.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      title.tr,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white, fontSize: 15),
                                    ),
                                    SizedBox(height: 5),

                                    Text(
                                      '${desc.tr}}',
                                      maxLines: 3,
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: itemCol,
                                          fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 5),

                            // Text(
                            //   'Time: ${advice['time']}',
                            //   style: TextStyle(
                            //       color: Colors.white54, fontSize: 11),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    ),
  );
}



Widget appNameText(){
  return Text('smartCare', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
    textStyle:  TextStyle(
        fontSize: 33  ,
        color: Colors.white,
        fontWeight: FontWeight.w700
    ),
  ),);
}


Widget customTextField({Color?  color,TextInputType? textInputType ,String? hintText,String? labelText,TextEditingController? controller ,String? Function(String?)? validator,bool obscure = false,bool isPwd = false,Function()? onSuffClick,IconData? icon}){
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Container(

      child: TextFormField(


        controller: controller,
        keyboardType: textInputType ,
        textInputAction: TextInputAction.done,
        obscureText: obscure,        ///pwd

        style: TextStyle(color: Colors.white, fontSize: 14.5),
        validator: validator,
        decoration: InputDecoration(



          focusColor: color ?? Colors.white,
          fillColor: color ?? Colors.white,
          hoverColor: color ?? Colors.white,
            contentPadding: const EdgeInsets.only(bottom: 0,right: 20,top: 0),
            suffixIconConstraints:BoxConstraints(minWidth: 50) ,
            prefixIconConstraints: BoxConstraints(minWidth: 50),
            prefixIcon: Icon(
              icon,
              color: Colors.white70,
              size: 22,
            ),
            suffixIcon:isPwd? IconButton(    ///pwd

            icon: Icon(!obscure ? Icons.visibility : Icons.visibility_off,color: Colors.white70,),
                onPressed: onSuffClick
            ):null,
            border: InputBorder.none,
            hintText: hintText!,
            labelText: labelText!,
            labelStyle: TextStyle(color: Colors.white60, fontSize: 14.5),
            hintStyle: TextStyle(color: Colors.white30, fontSize: 14.5),

            errorStyle: TextStyle(color: Colors.redAccent.withOpacity(.9), fontSize: 12,letterSpacing: 1),

            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white38)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.white70)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.redAccent.withOpacity(.7))),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100), borderSide: BorderSide(color: Colors.redAccent)),


        ),

      ),
    ),
  );
}

backGroundTemplate({Widget? child}){
 return Container(
    //alignment: Alignment.topCenter,
    width: 100.w,
    height: 100.h,
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/Landing page – 1.png"),
        fit: BoxFit.cover,
      ),
    ),
    child: child,
  );
}

///patientsCard
Widget patientCard(ScUser user, List<dynamic> doctrPats) {
  return GestureDetector(
    onTap: () {
      //if(doctrPats.contains(user.id)) Get.to(() => PatientInfo());
    },
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100.w,
        height: 120,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white38, width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),

                    ///patient simple info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/patient.png',
                          width: 72,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///name
                            Text(
                              '${user.name}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(height: 5),

                            ///email
                            Text(
                              user.email!,
                              style:
                              TextStyle(color: Colors.white, fontSize: 11),
                            ),
                            SizedBox(height: 5),

                            ///ge,der
                            Text(
                              '${user.sex!} (${user.age})',
                              style:
                              TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            (!doctrPats.contains(user.id))?
              Positioned(
                bottom: 40,
                right: (currLang =='ar')? null:25,//english
                left: (currLang =='ar')? 25:null,//arabic
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {
                      addPatient(user);
                      dcCtr.updateCtr();
                    },
                  ),
                ),
              ):Positioned(
                bottom: 40,
              right: (currLang =='ar')? null:25,//english
              left: (currLang =='ar')? 25:null,//arabic
                              child: CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.message,size: 19),
                    color: Colors.white,
                    onPressed: () {
                      Get.to(() => ChatRoom(), arguments: {'user': user});
                    },
                  ),
                ),
              ),


            if(doctrPats.contains(user.id)) Positioned(
                bottom: 10,
                right: (currLang =='ar')? null:20,//english
                left: (currLang =='ar')? 20:null,//arabic
                child: GestureDetector(

                  child: Text(
                    'Remove'.tr,
                    //weight: 50,
                    style: TextStyle(
                      color: Colors.red.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  onTap: () {
                    showNoHeader(
                      txt: 'Are you sure you want to remove this patient ?'.tr,
                      icon: Icons.close,
                      btnOkColor: Colors.red,
                      btnOkText: 'Remove'.tr,
                    ).then((toAllow) {// if admin accept
                      if (toAllow) {
                        removePatient(user);
                        Future.delayed(const Duration(milliseconds: 500), () {
                          dcCtr.updateCtr();


                        });

                      }
                    });

                  },
                )
            ),
          ],
        ),
      ),
    ),
  );
}

///patientsCard
Widget userCard(ScUser user) {
  //double cardHei = user.role=='doctor'? 160: 130;
  double cardHei = 130;

  return GestureDetector(

    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 100.w,
        height: cardHei,
        child: Stack(
          children: [
            Card(
              color: cardColor,
              elevation: 50,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white38, width: 2),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),

                    ///patient simple info
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/patient.png',
                          width: 72,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///name
                            Text(
                              '${user.name}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),

                            ///email
                            Text(
                              user.email!,
                              style:
                              TextStyle(color: Colors.white, fontSize: 11),
                            ),
                            SizedBox(height: 5),


                            Text(
                              //'${user.sex!} (${user.age})',
                              '${user.sex!} (${user.age != '' ? user.age:user.speciality})',

                              style:
                              TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            SizedBox(height: 5),

                            (user.role == 'doctor')? Text(
                              'Tax: F6KH-ZFG564-6FKDZ',
                              style: TextStyle(color: Colors.white, fontSize: 13),
                            ): Text(
                              'Tel: ${user.number!}',
                              style:
                              TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            !user.accepted?
              Positioned(
                bottom: cardHei/3,
                right: (currLang =='ar')? null:25,//english
                left: (currLang =='ar')? 25:null,//arabic
                child: CircleAvatar(
                  backgroundColor: Colors.greenAccent.withOpacity(0.7),
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.check),
                    color: Colors.white,
                    onPressed: () {
                      showNoHeader(
                        txt: 'Are you sure you want to accept this user ?'.tr,
                        icon: Icons.check,
                        btnOkColor: Colors.green,
                        btnOkText: 'add'.tr,
                      ).then((toAllow) {// if admin accept
                        if (toAllow) {

                          acceptUser(user.id!);
                        }
                      });

                    },
                  ),
                ),
              ):Positioned(
                bottom: cardHei/3,
              right: (currLang =='ar')? null:25,//english
              left: (currLang =='ar')? 25:null,//arabic
                child: CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.6),
                  radius: 20,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.close,size: 19),
                    color: Colors.white,
                    onPressed: () {
                      showNoHeader(
                        txt: 'Are you sure you want to remove this user ?'.tr,
                        icon: Icons.close,
                        btnOkColor: Colors.red,
                        btnOkText: 'Remove'.tr,
                      ).then((toAllow) {// if admin accept
                        if (toAllow) {
                          deleteUser(user.id!);// delete user from firestore
                          deleteUserFromAuth(user.email, user.pwd);// delete from auth
                        }
                      });
                      },
                  ),
                ),
              ),


          ],
        ),
      ),
    ),
  );
}



Widget MonthSquare(String day , String month) {



  return Container(
    width: 70,
    height: 70,
    decoration: BoxDecoration(
      borderRadius:BorderRadius.circular(15) ,
      //color: Colors.white,
      // border: Border.all(
      //   color: Colors.white,
      //   width: 2,
      // ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          day,
          maxLines: 1,

          style: TextStyle(
            fontSize: 37,
            height: 0.5,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          month,
          maxLines: 1,
          style: TextStyle(
            fontSize: 13,
            height: 0.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );

}


Widget appoiCard(String key, Map<String, dynamic> appoiInfo,) {

  bool newAppoi = appoiInfo['new'];
  String patientName = appoiInfo['patientName'];
  String time = appoiInfo['time'];
  String day = appoiInfo['day'];
  String month = appoiInfo['month'];
  String topic = appoiInfo['topic'];
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Container(
      height: newAppoi ? 120:100,
      child: Stack(
        children: [
          Card(
            shadowColor: Colors.black,
            color: dialogsCol.withOpacity(0.5),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: newAppoi ? Colors.green : Colors.white38,
                    width: 3),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              // child:Row(
              //   children: [
              //
              //   ],
              // ),
              child: ListTile(
                dense: false,
                //isThreeLine: false,
                leading: MonthSquare(day,month),
                title: Text(patientName,style: TextStyle(
                  color: cardColor,
                    fontWeight: FontWeight.w500,
                  fontSize: 20

                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text("${'Topic'.tr}: ${topic}",
                      maxLines: 1,
                     // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        //color: cardColor.withOpacity(0.85),
                        color: Colors.white.withOpacity(0.80),
                        fontSize: 15,



                    ),),
                    SizedBox(height: 4),
                    Text("${'Time'.tr}: ${time}",style: TextStyle(
                      color: !newAppoi? Colors.white: Colors.white.withOpacity(0.80),
                      fontSize: 15,
                        fontWeight: !newAppoi? FontWeight.w800 :FontWeight.w400

                    ),),
                  ],
                ),
              ),
            ),
          ),
          newAppoi
              ? Positioned(
              bottom: 15,
              right: (currLang =='ar')? null:10,//english
              left: (currLang =='ar')? 10:null,//arabic
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  // child: Icon(
                  //   size: 20,
                  //   Icons.check,
                  //   //weight: 50,
                  //   color: cardColor,
                  // ),
                  child: Text(
                    'Accept'.tr,
                    //weight: 50,
                    style: TextStyle(
                color: primaryColorMat[800],
                    fontWeight: FontWeight.w500
                    ),
                  ),
                  onTap: () {
                    // showNoHeader(
                    //   txt: 'Are you sure you want to accept this user request ?',
                    //   icon: Icons.check,
                    //   btnOkColor: Colors.green,
                    //   btnOkText: 'Accept',
                    // ).then((toAllow) {// if admin accept
                    //   if (toAllow) {
                    //     acceptUser(user.id!);
                    //     getUsersData();//refresh
                    //   }
                    // });
                    acceptAppoi(key);

                  },
                ),
                SizedBox(width: 17),
                GestureDetector(
                  child: Text(
                    'Decline'.tr,
                    //weight: 50,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500
                    ),
                  ),


                  onTap: () {

                    declineAppoi(key);
                  },
                ),
                SizedBox(width: 10),

              ]))
              : Container()
        ],
      ),
    ),
  );
}


Widget customButton({ bool reversed =false, Function()? btnOnPress,Widget? icon , String textBtn = 'button', double btnWidth=200 ,Color? fillCol  ,Color? borderCol }){


 List<Widget> buttonItems =[
   icon!,


    SizedBox(width: 10),
   Text(
     textBtn,
     style: TextStyle(
       color: Colors.white,
       fontSize: 16,
     ),
   ),
    //Icon(Icons.send_rounded,  color: Colors.white,),

  ];

  return SizedBox(
    width: btnWidth,
    child: ElevatedButton(
      onPressed: btnOnPress!,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: reversed? buttonItems.reversed.toList():buttonItems,
      ),
      style: ElevatedButton.styleFrom(
        primary: fillCol ?? primaryColor.withOpacity(0.7)!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(
          color: borderCol ?? accentColor0! ,
          width: 2,
        ),
      ),
    ),
  );
}