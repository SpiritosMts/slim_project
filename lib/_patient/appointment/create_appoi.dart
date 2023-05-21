
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/main.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:smart_care/manager/styles.dart';

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
        child: ptCtr.myDoctor.id != 'no-id'? Column(
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

            Row(
              children: [
                SizedBox(
                  width: 80.w,

                  child: Form(
                    key: ptCtr.addAppoiKey,
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
                IconButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(

                        navigatorKey.currentContext!,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2024, 6, 7),
                        onChanged: (date) {
                          print('## change: $date');
                        },

                        onConfirm: (date) {
                          //gDate = ('${date.hour}:${date.minute} ${date.day}/${date.month}/${date.year}');
                          //DateFormat dateFormat = DateFormat("hh:mm");
                          //ptCtr.appoiDate = DateFormat("hh:mm").format(date);
                          ptCtr.appoiDate = date;
                          print('## confirm_date: ${ptCtr.appoiDate!.day.toString().padLeft(2, '0')} / ${getMonthName(ptCtr.appoiDate!.month)} / ${DateFormat("hh:mm a").format(date)}');

                        },
                        theme: DatePickerTheme(
                          backgroundColor: dialogsCol,
                        ),
                        currentTime: DateTime.now(), locale: LocaleType.en
                    );

                  },
                  icon: Icon(Icons.edit_calendar_rounded,color: Colors.white,),
                ),

              ],
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
