import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_care/manager/myUi.dart';

import '../../manager/myVoids.dart';
import '../../manager/styles.dart';
import '../home/patientHome_ctr.dart';

class OneAdvice extends StatefulWidget {
   String? title;
   String? body;

   OneAdvice({Key? key,this.title,this.body}) : super(key: key);

  @override
  State<OneAdvice> createState() => _OneAdviceState();
}

class _OneAdviceState extends State<OneAdvice> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          automaticallyImplyLeading:false,
          centerTitle: true,
          backgroundColor: appbarColor,
          elevation: 10,

        ),
        body: backGroundTemplate(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50),
            child: Text(widget.body!,style: TextStyle(
              fontSize: 21,
              color: Colors.white70

            ),),
          ),
        )


    );
  }
}
