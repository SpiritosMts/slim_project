
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/_patient/home/patientHome_ctr.dart';
import 'package:smart_care/manager/styles.dart';

import '../../chatSystem/chatRoom.dart';
import '../../manager/myUi.dart';
import '../../manager/myVoids.dart';

class AttachedDoctor extends StatefulWidget {
  const AttachedDoctor({Key? key}) : super(key: key);

  @override
  State<AttachedDoctor> createState() => _AttachedDoctorState();
}

class _AttachedDoctorState extends State<AttachedDoctor> {

  bool _isConnected = true;

  void _toggleConnection() {

    setState(() {
      _isConnected = !_isConnected;
    });
  }
  @override
  Widget build(BuildContext context) {


    double leftPad = 15;
    double txtIconPad = 15;
    double txtSize = 17;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("My Doctor"),
          centerTitle: true,
          backgroundColor: appbarColor,
          elevation: 10,
        ),
        body:backGroundTemplate(
          child: GetBuilder<PatientHomeCtr>(
            builder: (_) {
              return ptCtr.myDoctor.id != 'no-id'?  Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 15),

                          ///doctor info
                          Row(
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
                                    'Dr.${ptCtr.myDoctor.name}',
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  SizedBox(height: 5),

                                  ///email
                                  Text(
                                    ptCtr.myDoctor.email!,
                                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 30),

                          ///speciality
                          Row(
                            children: [
                              SizedBox(width: leftPad),
                              Icon(
                                Icons.medical_services,
                                size: 40,
                                color: Colors.white30,
                              ),
                              SizedBox(width: txtIconPad),
                              Text(
                                ptCtr.myDoctor.speciality!,
                                style: TextStyle(color: Colors.white, fontSize: txtSize),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          ///phone
                          Row(
                            children: [
                              SizedBox(width: leftPad),
                              Icon(
                                Icons.phone,
                                size: 40,
                                color: Colors.white30,
                              ),
                              SizedBox(width: txtIconPad),
                              Text(
                                ptCtr.myDoctor.number!,
                                style: TextStyle(color: Colors.white, fontSize: txtSize),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          ///address
                          Row(
                            children: [
                              SizedBox(width: leftPad),
                              Icon(
                                Icons.maps_home_work_sharp,
                                size: 40,
                                color: Colors.white30,
                              ),
                              SizedBox(width: txtIconPad),
                              Text(
                                ptCtr.myDoctor.address!,
                                style: TextStyle(color: Colors.white, fontSize: txtSize),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),

                          ///connected
                          GestureDetector(
                            onTap: _toggleConnection,

                            child: Row(
                              children: [
                                SizedBox(width: leftPad),
                                Icon(size: 40,
                                  _isConnected ? Icons.check_circle : Icons.error,
                                  color:  _isConnected ? Colors.greenAccent.withOpacity(0.7) : Colors.red.withOpacity(0.7),
                                ),
                                SizedBox(width: txtIconPad),
                                Text(
                                    _isConnected ? 'Available'.tr : 'Not Available'.tr,
                                  style: TextStyle(
                                      color :_isConnected ? Colors.greenAccent.withOpacity(0.7) : Colors.red.withOpacity(0.7),
                                      fontSize: txtSize),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal:20.0,vertical: 8),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child:           customButton(
                        btnOnPress: () async {
                          if(_isConnected) Get.to(()=>ChatRoom(),arguments: {'user': ptCtr.myDoctor});
                        },
                        textBtn: 'Chat'.tr,
                        btnWidth: 120,
                        icon: Icon(
                          Icons.chat,
                          color: Colors.white.withOpacity(0.7),
                          size: 19,
                        ),
                        reversed: false,
                        borderCol :_isConnected ? Colors.greenAccent.withOpacity(0.7) : Colors.red.withOpacity(0.7),
                        fillCol: primaryColor.withOpacity(0.9),
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal:20.0,vertical: 8),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: customButton(
                        btnOnPress: () async {
                          showNoHeader(txt: 'Are you sure you want to remove this doctor ?'.tr,btnOkText: 'Remove',icon: Icons.close).then((accept) {
                            if (accept) {
                              removePatient(authCtr.cUser);
                              //dcCtr.updateCtr();
                              ptCtr.updateCtr();
                              //authCtr.refreshCuser();///refresh-user

                            }
                          });
                          },
                        textBtn: 'Remove'.tr,
                        btnWidth: 120,
                        icon: Icon(
                          Icons.close,
                          color: Colors.white.withOpacity(0.7),
                          size: 19,
                        ),
                        reversed: false,
                        borderCol: Colors.red,
                        fillCol: primaryColor.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ):Center(
                child: Text('no attached doctor yet'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                  textStyle:  TextStyle(
                      fontSize: 23  ,
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                  ),
                )),
              );
            }
          )
        ),

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: ptCtr.myDoctor.id != 'no-id' ? Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: <Widget>[
        //       Container(
        //         height: 40.0,
        //         width: 100.0,
        //         child: FittedBox(
        //           child: FloatingActionButton.extended(
        //
        //
        //             onPressed: () {
        //               patListCtr.removePatient(authCtr.cUser);
        //             },
        //             heroTag: 'sfs-',
        //             backgroundColor: Colors.green,
        //             label: Text('Remove'),
        //           ),
        //         ),
        //       ),
        //       Container(
        //         height: 40.0,
        //         width: 130.0,
        //         child: FittedBox(
        //           child: FloatingActionButton.extended(
        //
        //             onPressed: () {
        //               Get.to(()=>ChatRoom(),arguments: {'user': ptCtr.myDoctor});
        //             },
        //             heroTag: '.df',
        //             backgroundColor: Colors.green,
        //             label: Text('Chat'),
        //           ),
        //         ),
        //       ),
        //
        //     ],
        //   ),
        // ):null
    );
  }
}
