

import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../../manager/myVoids.dart';
import '../../models/user.dart';

class DoctorHomeCtr extends GetxController{
  static DoctorHomeCtr instance = Get.find();

  StreamSubscription<DatabaseEvent>? streamData;

  double newestChartValue =0;

  int periodicUpdateData = 1000;
  //String gas_tapped_val = '00.00';
  String bpm_data = '0.0';
  String? selectedServer ;
  int serversNumber = 0 ;
  Map<String,ScUser> myPatients = {};
  List<String> servers = [];
  double maxRange = 90;
  double minRange = 60;

  List<double> bpmDataPts = [
    60.0, 70.0, 80.0, 90.0, 100.0,60.0, 70.0, 80.0, 90.0, 100.0,60.0, 70.0, 80.0, 90.0, 100.0,60.0,
  ]; // initial data points
 List<double>  normalPersonBpm =[60.0, 70.0, 80.0, 90.0, 100.0];
  int b=0;

  int xIndexs = 0;
  DateTime startDateTime = DateTime.now();
  bool loadingUsers = true;
  bool staticPts = true;

  ScUser doctorSelectedUser = ScUser();

  List<String> bpm_history = [];



  /// /////////////////////////////////////////::
  @override
  void onInit() {
    super.onInit();
    startDateTime =  startDateTime.subtract(Duration(seconds:bpmDataPts.length ));
    Future.delayed(const Duration(milliseconds: 500), () async {//time to start readin data

      serversNumber = await getChildrenLength();
      if(servers.isNotEmpty){
        changeServer(servers[0]);
        getPatientsFromIDs(authCtr.cUser.patients!);
        realTimeListen();// start streamData
        periodicFunction();
        update(['chart']);
        update(['appBar']);
      }else{
        selectedServer='';
      }
    });
  }
  selectUser(ScUser user){
    doctorSelectedUser = user;
    print('## selected_user = ${user.name}');

  }
  changeServer(server) async {
    selectedServer = server;
    print('## selected server = ${selectedServer}');
    if(streamData != null) await streamData!.cancel();
    bpm_history = await getHistoryData('patients/$selectedServer/bpm_hiwtory'); // path history

    realTimeListen();

    update(['appBar']);
    update(['chart']);
  }

  void getPatientsFromIDs(List<dynamic> IDs) async {
    //print('## getting my_patients From IDS....');

    myPatients.clear();
    if(IDs.isNotEmpty){
      for (var id in IDs) {
        final event = await usersColl.where('id', isEqualTo: id).get();
        var doc = event.docs.single;
        myPatients[id] = ScUserFromMap(doc);
      }
    }

    print('## my_patients From IDS <${myPatients.length}>');
    // if(myPatients.length > IDs.length){
    //   for (var id in myPatients.keys) {
    //     if(!IDs.contains(id) ){
    //       myPatients.remove(id);
    //     }
    //   }
    // }

    if(myPatients.isEmpty){
      loadingUsers=false;
    }else{
      loadingUsers=true;

    }
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   if(this.mounted){
    //     setState(() {});
    //   }
    // });
    //update();

    // Future.delayed(Duration(milliseconds: 20),(){update();});
    // print('## my patients number < ${myPatients.length} >');


  }



  updateCtr(){
    update(['appBar']);
    update(['chart']);
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


  Future<int> getChildrenLength() async {
    String userID = authCtr.cUser.id!;
    int serverNumbers = 0;
    DatabaseReference serverData = database!.ref('patients');
    //servers = sharedPrefs!.getStringList('servers') ?? ['server1'];

    final snapshot = await serverData.get();

    if (snapshot.exists) {
      serverNumbers = snapshot.children.length;
      snapshot.children.forEach((element) {
        //print('## ele ${element.key}');
        servers.add(element.key.toString());
      });
      print('## <$userID> exists with [${serverNumbers}]servers:<$servers> server');
    } else {
      print('## <$userID> DONT exists');
    }

    update(['chart']);
    return serverNumbers;
  }



  /// UPDATE-DATA-PTS //////
  updateDataPoints(double newData) {
    // update data points and rebuild chart
    bpmDataPts.removeAt(0); // remove oldest data point
    bpmDataPts.add(newData); // add new data point
  }

  periodicFunction() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {

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
      bpm_data = event.snapshot.child('bpm_once').value.toString();
      // print('## LAST-gas_data:$gas_data');
      //print('## gas_data_pointd:$gasValueList');
      update(['chart']);

    });
  }



  /// //////////: HISTORY ///////////////////////////
  Future<List<String>> getHistoryData(dataTypePath) async {
    List<String> dataHis = [];
    DatabaseReference serverData = database!.ref(dataTypePath);
    //servers = sharedPrefs!.getStringList('servers') ?? ['server1'];

    final snapshot = await serverData.get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        //print('## ele ${element.key}');
        dataHis.add(element.value.toString());
        //print('## type... <${element.value.runtimeType}>');

      });

      print('## <${dataTypePath}>history exists with <${dataHis.length}> values');
    } else {
      print('## <${dataTypePath}> history DONT exists');
    }

    update(['chart']);
    print('## <<${dataHis.length}>> hisValues=<$dataHis> ');
    return dataHis;
  }
  List<FlSpot> generateHistorySpots(List dataList) {
    //print('## generate spots...');
    List<FlSpot> spots = [];
    for (int i = 0 ; i < dataList.length ; i++) {
      //bool isLast = i % spots.length == 0;
      spots.add(
          FlSpot(
              i.toDouble(),
              double.parse(dataList[i])
          )
      );
    }

    return spots;
  }




}