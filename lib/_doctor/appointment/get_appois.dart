import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetAppointments extends StatefulWidget {
  const GetAppointments({Key? key}) : super(key: key);

  @override
  State<GetAppointments> createState() => _GetAppointmentsState();
}

class _GetAppointmentsState extends State<GetAppointments> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Center(
        child: Text('no appointments yet', textAlign: TextAlign.center, style: GoogleFonts.indieFlower(
          textStyle:  TextStyle(
              fontSize: 23  ,
              color: Colors.white,
              fontWeight: FontWeight.w700
          ),
        )),
      ),
    );
  }
}
