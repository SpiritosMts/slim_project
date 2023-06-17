
import 'dart:async';
import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
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
import '../_doctor/notifications/awesomeNotif.dart';
import '../alarm/alarm.dart';
import '../manager/test/chaa.dart';

class ChartsCtr extends GetxController with GetSingleTickerProviderStateMixin{
  static ChartsCtr instance = Get.find();
  updateCtr(){
    update();
    // dcCtr.updateCtr();
    // dcCtr.update();
    // ptCtr.updateCtr();
    // ptCtr.update();
  }


  String selectedServer ='';

  bool isConnected = true;

  Color chartLineNormalColor = Colors.green;
  Color chartLineDangerColor = Colors.red;

  late Timer periodicTimer ;
  //(Random().nextDouble() * (95 - (70)) + (70))
  double maxSafeZone = 100 ;
  double minSafeZone = 0;
  bool shouldSnooze = false;
  bool isInDanger = false;
  bool isTrainig = false;
  double dataPointsAverage = 0.0;
  int aiPercentage = 0;
  int oldAiPercentage = 0;
  final GlobalKey aiKey = new GlobalKey();
  AnimationController? animationController;
  Animation<double>? animation;

  double calculateAverage(List<double> numbers) {
    if (numbers.isEmpty) {
      return 0.0; // Return 0 if the list is empty to avoid division by zero.
    }

    double sum = 0.0;
    for (double number in numbers) {
      sum += number;
    }

    double average = sum / numbers.length;
    return average;
  }

 String convertPulseToBPM(double originalValue){ //max idle 100 // max training 170
   double minValue = 0;
   double maxValue = 4080;
    double newMinValue = 40;//60
    double newMaxValue = 180;//150
    double normalizedValue = (originalValue - minValue) / (maxValue - minValue);
    double convertedValue = (normalizedValue * (newMaxValue - newMinValue)) + newMinValue;

   // double offset = Random().nextDouble() * 50; // Adjust the range as needed
   // convertedValue = min(convertedValue, newMaxValue - offset); // Limit the value to newMaxValue - offset


   return formatNumberAfterComma(convertedValue.toString());
  }

  double convertGeneral( originalValue,minValue,maxValue,newMinValue,newMaxValue){
    double normalizedValue = (originalValue - minValue) / (maxValue - minValue);
    double convertedValue = (normalizedValue * (newMaxValue - newMinValue)) + newMinValue;
    return convertedValue;

  }

   int initialRefreshTime = 3;
  int timesToRefreshAi = 0;//changable
  aiCalculate({List<double>? bpmDataPoints}){

    int patientAge = int.parse(authCtr.cUser.age! !=''?authCtr.cUser.age!:'23' );
    double mhr = ((220 - patientAge)*0.85); // 167

    if(isConnected){


      dataPointsAverage = calculateAverage(bpmDataPts);//16 last points = 16 sec // will take that average if stays idle
      //print('## dataPointsAverage: $dataPointsAverage');



      double maxAverage = 190;
      double minAverage = 40;
      maxSafeZone = convertGeneral(dataPointsAverage ,minAverage,maxAverage,100,285);
      aiPercentage = convertGeneral(dataPointsAverage ,minAverage,maxAverage,0,100).toInt();


      //print('## aiPercentage: $aiPercentage %');
      if(timesToRefreshAi < 2){
        animation = Tween<double>(begin: oldAiPercentage.toDouble(), end: aiPercentage.toDouble()).animate(animationController!);
        //print("## animate.... <$oldAiPercentage> --${initialRefreshTime}sec--> <$aiPercentage> ");
        timesToRefreshAi = initialRefreshTime;
        oldAiPercentage = aiPercentage;
        animationController!.reset();
        animationController!.forward();

        // wait 5 sec

      }else{
        timesToRefreshAi--;
      }

    }
  }

  /// /////////////////////////////////////////::
  @override
  void onInit() {
    super.onInit();
    print('## init ChartsCtr##');

    animationController = AnimationController(
      duration: Duration(milliseconds: initialRefreshTime*1000),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController!);

    Future.delayed(const Duration(milliseconds: 200), () async {//time to start readin data
      periodicFunction();
      //updateCtr();
      //changeServer(authCtr.cUser.id);/// start streamData
    });
  }

  @override
  void onClose() {
    super.onClose();
    animationController!.dispose();
    periodicTimer!.cancel();

  }
  /// #####################################################################################"


  void alertUser(String bpm){

    String usrInDanger = 'patient';
    String idNotifRecever = authCtr.cUser.id!;
    print('## $selectedServer ');
    if(authCtr.cUser.role == 'doctor'){
      usrInDanger = dcCtr.myPatientsMap[selectedServer]!.name!;
    }else{
      usrInDanger = authCtr.cUser.name!;
    }
    print('## alerting user ....(usr-In-Danger <$usrInDanger>) ');

    sendNotif(idNotifRecever: idNotifRecever, name: usrInDanger, bpm: bpm );

  }

  void sendNotif({String? name,String? idNotifRecever,String? bpm }){ // just the patient do THIS

    print('## sending notif ..... ');

    /// /////////// Ring /////////////////////
    DateTime now =  DateTime.now();
    final alarmSettings = AlarmSettings(
      id: 42,
      dateTime: now,
      assetAudioPath: 'assets/sounds/alarm.mp3',
    );
    Alarm.set(alarmSettings: alarmSettings);
    Future.delayed(const Duration(milliseconds: 500), () {
      showAlarm( alarmID:alarmSettings.id  , name:name);
    });
    /// ///////////////////////////////

    NotificationController.createNewStoreNotification('${authCtr.cUser.role == 'patient' ? 'You Have a critical state': '${name} Has  a critical state'}', 'heart condition (${bpm!} bpm)');



    if(idNotifRecever!= null){
      //if(false){
      DateTime notifDate = DateTime.now();
      usersColl.doc(idNotifRecever).get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map<String, dynamic> notifs = documentSnapshot.get('notifications');

          int notifsNum = notifs.length;
          notifs[notifsNum.toString()] = {
            'lat': '35.858028081225996',
            'lng': '10.598973604225517',
            'new': true,
            'usrName': name,
            // 'usrID': id,
            'bpm': bpm,
            'time': '${DateFormat("hh:mm a").format(notifDate)}',
            'day': '${notifDate.day.toString().padLeft(2, '0')}',
            'month': '${getMonthName(notifDate.month)}',
          };

          //add raters again map to cloud
          await usersColl.doc(authCtr.cUser.id).update({
            'notifications': notifs,
          }).then((value) async {
            //Get.back();



            if(authCtr.cUser.role == 'patient' ){
              ptCtr.toggleNotif(true);
            }else {
              dcCtr.toggleNotif(true);
            }
            print('## notifications sent');
            showSnack('notification sent'.tr, color: Colors.black54);
          }).catchError((error) async {
            print('## notifications sending error');
            showSnack('notifications error'.tr, color: Colors.redAccent.withOpacity(0.8));
          });
        }
      });
    }
  }

  checkDangerState(dataType){
    double dataNum = double.parse(bpm_data);
    if(dataNum <= chCtr.minSafeZone || dataNum >= chCtr.maxSafeZone){

      //print('## GO TO ---CRITICATL--- STATE');

      isInDanger = true;
      if(shouldSnooze){
        Future.delayed(const Duration(milliseconds: 500), () {
          alertUser(dataType);
        });
        print('## --- S N O O Z E --- ');
        shouldSnooze = false;
      }
    }else{
      //print('## GO TO NORMAL STATE');
      isInDanger = false;
      shouldSnooze = true;
    }
  }




  void toggleConnection() {
    isConnected = !isConnected;
    updateCtr();
  }


  bool chartLoading = true;
  changeServer(server) async {
    chartLoading = true;

    //if (servers.isEmpty && authCtr.cUser.role =='doctor') return;
    selectedServer = server;
    print('## changed server to=> << ${selectedServer} >>');
    if(selectedServer!=''){
      if(streamData != null) await streamData!.cancel();
      realTimeListen();
      initHistoryValues('patients/$selectedServer/bpm_history');
    }

    chartLoading = false;
    updateCtr();
  }




  /// //////////: LIVE ///////////////////////////
  StreamSubscription<DatabaseEvent>? streamData;
  String bpm_data = '70.0';
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
    periodicTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) {

      //print('## type value : ${bpm_data.runtimeType}');
      updateDataPoints(double.parse(bpm_data));///from fb
      //updateDataPoints(normalPersonBpm[b]);///from bpm_static_list
      if(b<normalPersonBpm.length-1) {
        b++;
      }else{b=0;}
      aiCalculate();
      updateCtr();

    });
  }
  realTimeListen() async {
    //print('## realTimeListen...');
    //DatabaseReference serverData = database!.ref('Leoni/LTN4/$server');
    DatabaseReference serverData = database!.ref('patients/$selectedServer');
    streamData = serverData.onValue.listen((DatabaseEvent event) {

      // /////////////


      int bpmInt = event.snapshot.child('bpm_once').value as int;

      bpm_data = convertPulseToBPM(bpmInt.toDouble());
      double settedDouble  =0.0;
      //print('## LAST-bpm-value:$bpm_data');
      //print('## LAST-bpm-type:${bpm_data.runtimeType}');
      updateCtr();


    });
  }
  /// /////////////////////////////////////////////////////////

  /// //////////: HISTORY ///////////////////////////
  int eachTimeHis = 7;
  List bpm_history = [];//{time,value}
  List<String> bpm_times = [];//time
  List<String> bpm_values = [];//value
  //bool loadingHis = true;

  /// ///
  initHistoryValues(String historyPath) async {
    //loadingHis=true;

    bpm_history = [];//{time,value}
    bpm_times = [];//time
    bpm_values = [];//value*


    bpm_history = await getHistoryData(historyPath); /// path history
    bpm_values = bpm_history.map((map) => convertPulseToBPM(map['value'].toDouble())).toList();
    bpm_times = bpm_history.map((map) => map['time'].toString() ).toList();
    //debugPrint('## bpm_history<${bpm_history.length}>// bpm_times<${bpm_times.length}>//  bpm_values<${bpm_values.length}><${bpm_values}>');
    //debugPrint('## max<${getMaxValue(bpm_values)}> / min<${getMinValue(bpm_values)}>');



    //loadingHis =false;
    updateCtr();

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

      //print('## <${dataTypePath}>history exists with <${dataHis.length}> values');
    } else {
      //print('## <${dataTypePath}> history DONT exists');
    }

    updateCtr();
    //print('## <<${dataHis.length}>> hisValues=<$dataHis> ');
    return dataHis;
  }
  List<FlSpot> generateHistorySpots(List valList) {
    //print('## generate spots...');
    List<FlSpot> spots = [];
    for (int i = 0 ; i < valList.length ; i++) {
      //bool isLast = i % spots.length == 0;
      spots.add(
          FlSpot(
              i.toDouble(), // X
              double.parse(valList[i].toString()) // Y
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
                    updateCtr();

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