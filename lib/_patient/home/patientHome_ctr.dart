
import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../manager/myVoids.dart';
import '../../manager/styles.dart';
import '../../models/user.dart';

class PatientHomeCtr extends GetxController{
  static PatientHomeCtr instance = Get.find();
  updateCtr(){
    update(['appBar']);
    update(['chart']);
  }


  // create_appoi ////
  final TextEditingController createAppoiCtr = TextEditingController();
  GlobalKey<FormState> addAppoiKey = GlobalKey<FormState>();
  String appoiDate = '';
  ////////////////////

  bool loadingHis = true;
  int notifNum = 0;
  String? selectedServer ;
  ScUser myDoctor = ScUser();
  List<Map<String,dynamic>> advices = [];



  int currentScreenIndex = 0;





  /// /////////////////////////////////////////::
  @override
  void onInit() {
    super.onInit();
    advices = [
      {
        'image':'assets/images/advice0.png',
        'title':'An Apple a Day',
        'description':'Savor the goodness of apples for a healthier you. Packed with fiber, vitamins, and antioxidants, apples contribute to overall well-being',
        'month':'',
        'day':'',
        'year':'',
      },
      {
        'image':'assets/images/advice1.png',
        'title':'Take Charge of Your Health',
        'description':'Nurture your heart with love and care. Stay active, eat well, manage stress, and prioritize regular check-ups',
        'month':'',
        'day':'',
        'year':'',
      },

      {
        'image':'assets/images/advice2.png',
        'title':'Prioritize Cardiovascular Health',
        'description':'Your heart is the engine that keeps you going. Show it some love by making heart-healthy choices. Engage in regular physical activity',
        'month':'',
        'day':'',
        'year':'',
      },
    ];

    Future.delayed(const Duration(milliseconds: 500), () async {//time to start readin data
      periodicFunction();
      changeServer(authCtr.cUser.id);/// start streamData
    });
  }



  String convertToBPM( int pulse){

    return '';
  }

  void sendAppoitment(){

    if (addAppoiKey.currentState!.validate()) {
      usersColl.doc(authCtr.cUser.doctorAttachedID).get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map<String, dynamic> appointments = documentSnapshot.get('appointments');

          appointments[authCtr.cUser.id!] = {
            'topic': createAppoiCtr.text,
            'date': appoiDate,
            'new': true,
            'patientName': authCtr.cUser.name,
          };

          //add raters again map to cloud
          await usersColl.doc(authCtr.cUser.doctorAttachedID).update({
            'appointments': appointments,
          }).then((value) async {
            Get.back();

            print('## appointment requested');
            showSnack('appointment request has been sent'.tr);
          }).catchError((error) async {
            print('## appointment request error');
            showSnack('appointment request error'.tr);
          });
        }
      });
    }
  }


  /// #####################################################################################"



  selectScreen(int index){
      currentScreenIndex = index;
      print('## screen<$currentScreenIndex> selected');
      update();
  }

  bool chartLoading = true;
  changeServer(server) async {
    chartLoading = true;
    selectedServer = '';
    //if (servers.isEmpty) return;
    selectedServer = server;
    print('## selected server = ${selectedServer}');
    if(streamData != null) await streamData!.cancel();
    realTimeListen();
    initHistoryValues('patients/$selectedServer/bpm_history');

    chartLoading = false;
    updateCtr();
  }









  /// //////////: LIVE ///////////////////////////
  StreamSubscription<DatabaseEvent>? streamData;
  String bpm_data = '0.0';
  int xIndexs = 0;
  List<double> bpmDataPts = [
    60.0, 70.0, 80.0, 90.0, 100.0,60.0, 70.0, 80.0, 90.0, 100.0,60.0, 70.0, 80.0, 90.0, 100.0,60.0,
  ]; // initial data points
  DateTime  startDateTime =  DateTime.now().subtract(Duration(seconds:16));//16 = bpmDataPts.length
  int b=0;
  List<double>  normalPersonBpm =[60.0, 70.0, 80.0, 90.0, 100.0];//repeat list each time it ends


  SideTitles get bottomTitles {
    return SideTitles(
    interval: 1,
    showTitles: true,
    getTitlesWidget: (value, meta) {
      String bottomText = '';

      //print('## ${value.toInt()}');

      //bool isDivisibleBy15 = ((value.toInt() % 13 == 0) );
      DateTime newDateTime = startDateTime.add(Duration(seconds: value.toInt()));
      //bottomText = DateFormat('mm:ss').format(newDateTime);
      //bottomText = (value.toInt() ).toString();

      switch (value.toInt() % 7 ) {

        case 0:
          bottomText = DateFormat('HH:mm:ss').format(newDateTime);
          break;

      }

      return Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(
          bottomText,
          maxLines: 1,

          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11,color:chartValuesColor),
        ),
      );

    },
  );
  }
  updateDataPoints(double newData) {
    // update data points and rebuild chart
    bpmDataPts.removeAt(0); // remove oldest data point
    bpmDataPts.add(newData); // add new data point
  }
  List<FlSpot> generateSpots(dataPts) {
    //print('## generate spots...');
    List<FlSpot> spots = [];
    for (int i = 0 + xIndexs; i < dataPts.length + xIndexs; i++) {
      //bool isLast = i % spots.length == 0;
      spots.add(
          FlSpot(
            //isLast? bottomTitleTime :i.toDouble(),//X
              i.toDouble(),//X
              dataPts[i - xIndexs]
          )//Y
      );
    }
    xIndexs++;
    return spots;
  }
  periodicFunction() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {

      //print('## type value : ${bpm_data.runtimeType}');
      updateDataPoints(double.parse(bpm_data));///from fb
      //updateDataPoints(normalPersonBpm[b]);///from bpm_static_list
      if(b<normalPersonBpm.length-1) {
        b++;
      }else{b=0;}

      update(['chart']);
      update(['appBar']);

    });
  }
  realTimeListen() async {
    //print('## realTimeListen...');
    //DatabaseReference serverData = database!.ref('Leoni/LTN4/$server');
    DatabaseReference serverData = database!.ref('patients/$selectedServer');
    streamData = serverData.onValue.listen((DatabaseEvent event) {

      // /////////////


      int bpmInt = event.snapshot.child('bpm_once').value as int;

      bpm_data = bpmInt.toString();
      double settedDouble  =0.0;
      //print('## LAST-bpm-value:$bpm_data');
      //print('## LAST-bpm-type:${bpm_data.runtimeType}');
      update(['chart']);

    });
  }
  /// /////////////////////////////////////////////////////////

  /// //////////: HISTORY ///////////////////////////
  int eachTimeHis = 7;
  List bpm_history = [];//{time,value}
  List<String> bpm_times = [];//time
  List<String> bpm_values = [];//value
  /// ///
  initHistoryValues(String historyPath) async {
    loadingHis=true;

    bpm_history = [];//{time,value}
    bpm_times = [];//time
    bpm_values = [];//value*


    bpm_history = await getHistoryData(historyPath); /// path history
    bpm_values = bpm_history.map((map) => map['value'].toDouble().toString()).toList();
     bpm_times = bpm_history.map((map) => map['time'].toString() ).toList();
    debugPrint('## bpm_history<${bpm_history.length}>// bpm_times<${bpm_times.length}>//  bpm_values<${bpm_values.length}><${bpm_values}>');
    debugPrint('## max<${getMaxValue(bpm_values)}> / min<${getMinValue(bpm_values)}>');



    loadingHis =false;
    update(['chart']);
    update(['appBar']);
  }
    Future<List> getHistoryData(dataTypePath) async {
      List dataHis = [];
    DatabaseReference serverData = database!.ref(dataTypePath);
    //servers = sharedPrefs!.getStringList('servers') ?? ['server1'];

    final snapshot = await serverData.get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        //print('## ele ${element.key}');
        dataHis.add(element.value);
        //print('## type... <${element.value.runtimeType}>');

      });

      print('## <${dataTypePath}>history exists with <${dataHis.length}> values');
    } else {
      print('## <${dataTypePath}> history DONT exists');
    }

    update(['chart']);
    //print('## <<${dataHis.length}>> hisValues=<$dataHis> ');
    return dataHis;
  }
    List<FlSpot> generateHistorySpots(List dataList) {
    //print('## generate spots...');
    List<FlSpot> spots = [];
    for (int i = 0 ; i < dataList.length ; i++) {
      //bool isLast = i % spots.length == 0;
      spots.add(
          FlSpot(
              i.toDouble(), // X
              double.parse(dataList[i]['value'].toString()) // Y
          )
      );
    }

    return spots;
  }


  deleteFirstValues(int deleteCount,String type) async {
    DatabaseReference gasRef = database!.ref('patients/$selectedServer/bpm_history');

    await gasRef.limitToFirst(deleteCount).once().then((DatabaseEvent value) {
      if (value.snapshot.exists){
        Map<dynamic, dynamic> gasValues = value.snapshot.value as Map<dynamic, dynamic>;
        List keys = gasValues.keys.toList();
        keys.forEach((key) { // 20 loop
          gasRef.child(key).remove();
        });
      }else{
        print('## failed to delete: values dont exist');
      }
      //print('## vals: $gasValues');

    });
  }

  Future<void> deleteHisDialog(String type,List hisList) {
    TextEditingController _textEditingController = TextEditingController();
    final _serverFormKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bpm values to delete'),
          content: Form(
            key: _serverFormKey,
            child: TextFormField(
              controller: _textEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'number (max: ${hisList.length})',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'number cannot be empty';
                }
                if(int.parse(value)>hisList.length){
                  return 'number is greater than max';
                }
                return null;
              },
            ),
          ),

          actions: [
            ElevatedButton(
              onPressed: () {
                //if(sName.isNotEmpty && servers.contains(sName))
                if(_serverFormKey.currentState!.validate()){
                  int count = int.parse(_textEditingController.text);
                  deleteFirstValues(count,type);
                  Get.back();
                  Future.delayed(const Duration(milliseconds: 800), () async { //time to start readin history  data
                    initHistoryValues('patients/$selectedServer/bpm_history');
                    update(['chart']);

                  });

                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }


}