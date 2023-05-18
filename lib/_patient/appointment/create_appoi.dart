
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';

class CreateAppoi extends StatefulWidget {
  const CreateAppoi({Key? key}) : super(key: key);

  @override
  State<CreateAppoi> createState() => _CreateAppoiState();
}

class _CreateAppoiState extends State<CreateAppoi> {





  @override
  Widget build(BuildContext context) {
    return  Container(
      child: SingleChildScrollView(
        child: authCtr.cUser.doctorAttachedID != ''? Column(
          children: [
            SizedBox(height: 15,),
            Text('Want to meet the doctor ?'.tr, textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
              textStyle:  TextStyle(
                  fontSize: 23  ,
                  color: Colors.white,
                  fontWeight: FontWeight.w700
              ),
            )),

            SizedBox(height: 15,),

            Form(
              key: ptCtr.addAppoiKey,
              child: SizedBox(
                width: 90.w,
                child: customTextField(
                  controller: ptCtr.createAppoiCtr,
                  labelText: 'Topic'.tr,
                  hintText: 'meeting reason'.tr,
                  icon: Icons.library_books_sharp,
                  isPwd: false,
                  obscure: false,
                  onSuffClick: (){},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "topic can\'t be empty".tr;
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 15,),

            customButton(
              reversed: true,
              icon: Icon(Icons.send_rounded,  color: Colors.white,),
              btnWidth: 130,
              textBtn: 'Send',
              btnOnPress: (){
               ptCtr.sendAppoitment();
              }
            ),

          ],
        ):Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: Text('no attached doctor \nto send Appointment', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
              textStyle:  TextStyle(
                  fontSize: 23  ,
                  color: Colors.white,
                  fontWeight: FontWeight.w700
              ),
            )),
          ),
        ),
      ),
    );
  }
}
