
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/_doctor/patientsList/_patientsListCtr.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../manager/myVoids.dart';
import '../../manager/styles.dart';

class AllPatientsView extends StatefulWidget {
  @override
  State<AllPatientsView> createState() => _AllPatientsViewState();
}

class _AllPatientsViewState extends State<AllPatientsView> {
  final PatientsListCtr gc = Get.find<PatientsListCtr>();


  searchAppBar() {
    return AppBar(
      backgroundColor: appbarColor,
      automaticallyImplyLeading: false, // Hide the back button
      centerTitle: true,
      elevation: 10,
      title: GetBuilder<PatientsListCtr>(
        //id: 'appBar',
          builder: (_) {
            return gc.typing
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: SizedBox(
                height: 40,
                child: Container(
                  //margin: EdgeInsets.symmetric(vertical: 50),
                    decoration: BoxDecoration(
                      color: Color(0xff01333c),
                        borderRadius: BorderRadius.circular(10),
                    ),
                    //margin: EdgeInsets.all(20.0),
                    //alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 0.0),

                      ///TextFormField
                      child:TextFormField(

                        autocorrect: true,
                        cursorColor: Colors.white54,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white
                        ),
                        textAlign: TextAlign.start,
                        controller: gc.typeAheadController,
                        autofocus: true,
                        onChanged: (input){
                          gc.runFilterList(input);
                        },
                        decoration: InputDecoration(
                          //filled: true,

                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          fillColor: Colors.green,
                          hintStyle: const TextStyle(
                            color: Colors.white60,
                          ),


                          hintText: 'search for patient'.tr,

                          contentPadding: EdgeInsets.only(right: 10.0,left: 10.0, bottom: 10),
                        ),
                      ),
                    )),
              ),
            )
                : Text('Patients List');
          }),
      actions: <Widget>[
        GetBuilder<PatientsListCtr>(
          //id: 'appBar',
            builder: (_) {
              return !gc.typing
                  ? IconButton(
                padding: EdgeInsets.only(right: 15.0),
                icon: const Icon(Icons.search),
                onPressed: () {
                  gc.appBarTyping(true);
                },
              )
                  : IconButton(
                padding: EdgeInsets.only(right: 15.0),
                icon: const Icon(Icons.clear),
                onPressed: () {
                  gc.clearSelectedProduct();
                  setState(() {});
                },
              );
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: searchAppBar(),
      body: backGroundTemplate(
        child: GetBuilder<PatientsListCtr>(
          builder: (_) => (gc.foundUsersList.isNotEmpty)
              ? ListView.builder(
            //itemExtent: 130,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              shrinkWrap: true,
              itemCount: gc.foundUsersList.length,
              itemBuilder: (BuildContext context, int index) {
                //String key = gc.foundUsersMap.keys.elementAt(index);
                return patientCard(gc.foundUsersList[index],dcCtr.myPatientsMap.keys.toList());
              })
              : gc.shouldLoad? Center(
            child: CircularProgressIndicator(),
          ):Center(
            child: Text('no patients found', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
              textStyle:  TextStyle(
                  fontSize: 27  ,
                  color: Colors.white,
                  fontWeight: FontWeight.w700
              ),
            ))
          ),
        )
      )

    );
  }
}
