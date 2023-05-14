import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_care/manager/dataBase.dart';
import 'package:smart_care/manager/myVoids.dart';

class ChatRoomCtr extends GetxController {
  String senderID = Get.arguments['senderID'];
  String chatRoomID = '';
  late  StreamSubscription<QuerySnapshot> streamSub;
  Map<String, dynamic> messages = {};
  List<Widget> messagesWidgets = [];

  @override
  void onInit() {
    super.onInit();
    print('## init ChatRoomCtr');
    getChatRoomID();
    Future.delayed(const Duration(seconds: 0), () {
      streamingDoc(roomsColl,chatRoomID);
    });
  }
  @override
  void onClose() {
    super.onClose();
    print('## close ChatRoomCtr');
    stopStreamingDoc();
  }

  getChatRoomID() async {
    if (authCtr.cUser.role == 'doctor') {
      chatRoomID = (authCtr.cUser.id! + senderID);
    } else {
      chatRoomID = (senderID + authCtr.cUser.id!);
    }
    bool roomExists = await checkIfDocExists('sc_rooms', chatRoomID);

    if (!roomExists) {
      roomsColl
          .doc(chatRoomID)
          .set({
        'messages': {},
        'id':chatRoomID})
          .then((_) => print('## new chatRoom added'))
          .catchError((error) => print('room Add failed: $error'));
    } else {
      print('## room Already Exists');
    }
  }

  Future<void> sendMessage(String msg) async {
    if (msg.isNotEmpty) {
      roomsColl
          .doc(chatRoomID)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          //get existing raters of garage
          Map<String, dynamic> messages = documentSnapshot.get('messages');

          Map<String, dynamic> msgDetails = {
            'msg': msg,
            'sender': authCtr.cUser.name,
            'time': todayToString(showHours: true),
          };
          messages[messages.length.toString()] = msgDetails;

          //add raters again map to cloud
          await roomsColl.doc(chatRoomID).update({
            'messages': messages,
          }).then((value) async {
            print('## messages sent');

            update();
          }).catchError((error) async {
            print('## messages failed to sent');
          });
        }
      });
    } else {
      print('## message cant be empty');
      showSnack('message cant be empty');
    }
  }

  streamingDoc(CollectionReference coll,String id){
    print('##_start_Streaming');

    if(id!=''){
      streamSub  = coll.where('id', isEqualTo: chatRoomID).snapshots().listen((snapshot) {
        snapshot.docChanges.forEach((change) {
          print('##_CHANGE_Streaming');
          var chatDoc = snapshot.docs.first;
          messages.clear();
          messagesWidgets.clear();
          messages = chatDoc.get('messages');
          for(int i=0; i < messages.length ; i++ ){
            Map<String,dynamic> msg = messages[i.toString()];
            bool showTail =true;
            if(i < messages.length-1){
              Map<String,dynamic> nextMsg = messages[(i+1).toString()];
              if(msg['sender'] == nextMsg['sender']){
                showTail = false;
              }
            }
           bool isSender = authCtr.cUser.name! == msg['sender'];
            messagesWidgets.add(
              BubbleSpecialThree(
                text: msg['msg'],
                textStyle: const TextStyle(
                    color: Colors.white
                ),
                tail: showTail,
                color: isSender? Colors.blueGrey:Colors.grey.withOpacity(0.6),
                //tail: true,
                isSender: isSender,
              ),
            );
          }
          Future.delayed(Duration(milliseconds: 20),(){update();});
        });
      });
    }else{
      print('##_no_ID_to_stream_yet');
    }



  }

  stopStreamingDoc(){
    streamSub.cancel();
    print('##_stop_Streaming');

  }
}
