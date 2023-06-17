import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/manager/styles.dart';
import 'package:smart_care/models/user.dart';


class AllUsers extends StatefulWidget {
  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> with TickerProviderStateMixin {

  List<DropdownMenuItem<String>>? emptyList;
  late TabController _tcontroller;
  final List<String> titleList = [
    "patients verified".tr,
    "doctors verified".tr,
    "doctors requests".tr,
  ];
  String currentTitle = '';

  @override
  void initState() {
    super.initState();

    currentTitle = titleList[0];
    _tcontroller = TabController(length:titleList.length , vsync: this);
    _tcontroller.addListener(changeTitle);
  }

  @override
  void dispose() {
    _tcontroller.dispose();
    super.dispose();
  }

  void changeTitle() {
    setState(() {
      // get index of active tab & change current appbar title
      currentTitle = titleList[_tcontroller.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: titleList.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:false,
          elevation: 10,
          backgroundColor: appbarColor,
          actions: [
            IconButton(
              onPressed: () {
               authCtr.signOut();

              },
              icon: Icon(Icons.logout,color: Colors.white70,),
            ),
          ],
          bottom: TabBar(
            unselectedLabelColor: Colors.white30,
            labelColor: Colors.white,
            controller: _tcontroller,
            isScrollable: false,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            tabs: [
              Tab(
                  icon: Icon(Icons.groups)
              ),
              Tab(
                  icon: Icon(Icons.medical_services)
              ),
              Tab(
                icon: Icon(Icons.library_add_sharp),
              ),
            ],
          ),
          title: Text(currentTitle),
          centerTitle: true,
        ),
        body: backGroundTemplate(
          child: TabBarView(
            controller: _tcontroller,
            children: [

              SafeArea(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(height: 20),

                      ///categories
                      StreamBuilder<QuerySnapshot>(
                        stream: usersColl.where('role', isEqualTo: 'patient').where('isAdmin', isEqualTo: false).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return  Center(
                              child: Container(),
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Center(child: Text('connection error'.tr));
                            } else if (snapshot.hasData) {

                              /// ///////////////////////////////////////////////////////

                              List users = snapshot.data!.docs;
                              return  (users.isNotEmpty)
                                  ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),

                                //itemExtent: 180,

                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                  shrinkWrap: true,
                                  itemCount: users.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    //String key = appointments.keys.elementAt(index);
                                    //print('## key: ${key}');
                                    //bool newAppoi = appointments[key]['new'];
                                    ScUser user =  ScUserFromMap(users[index]);
                                    return userCard(user);
                                  }
                              ):Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Text('no patients verified yet'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                                    textStyle:  TextStyle(
                                        fontSize: 23  ,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700
                                    ),
                                  )),
                                ),
                              );
                              /// ///////////////////////////////////////////////////////

                            } else {
                              return Text('empty data'.tr);
                            }
                          } else {
                            return Container();
                          }
                        },
                      ),

                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                      stream: usersColl.where('role', isEqualTo: 'doctor').where('accepted', isEqualTo: true).where('isAdmin', isEqualTo: false).snapshots(),
                      builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                          ) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return  Center(
                            child: Container(),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(child: Text('connection error'.tr));
                          } else if (snapshot.hasData) {

                            List users = snapshot.data!.docs;
                            return  (users.isNotEmpty)
                                ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),

                                //itemExtent: 180,
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                shrinkWrap: true,
                                itemCount: users.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //String key = appointments.keys.elementAt(index);
                                  //print('## key: ${key}');
                                  //bool newAppoi = appointments[key]['new'];
                                  ScUser user =  ScUserFromMap(users[index]);
                                  return userCard(user);
                                }
                            ):Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Text('no doctors verified yet'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                                  textStyle:  TextStyle(
                                      fontSize: 23  ,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700
                                  ),
                                )),
                              ),
                            );

                          } else {
                            return Text('empty data'.tr);
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ]),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                      stream: usersColl.where('role', isEqualTo: 'doctor').where('accepted', isEqualTo: false).where('isAdmin', isEqualTo: false).snapshots(),
                      builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                          ) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return  Center(
                            child: Container(),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return Center(child: Text('connection error'.tr));
                          } else if (snapshot.hasData) {

                            List users = snapshot.data!.docs;
                            return  (users.isNotEmpty)
                                ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),

                                //itemExtent: 180,
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                shrinkWrap: true,
                                itemCount: users.length,
                                itemBuilder: (BuildContext context, int index) {
                                  //String key = appointments.keys.elementAt(index);
                                  //print('## key: ${key}');
                                  //bool newAppoi = appointments[key]['new'];
                                  ScUser user =  ScUserFromMap(users[index]);
                                  return userCard(user);
                                }
                            ):Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Text('no doctors requests yet'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
                                  textStyle:  TextStyle(
                                      fontSize: 23  ,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700
                                  ),
                                )),
                              ),
                            );

                          } else {
                            return Text('empty data'.tr);
                          }
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ]),
                ),
              ),


            ],
          ),
        ),

      ),
    );
  }
}
