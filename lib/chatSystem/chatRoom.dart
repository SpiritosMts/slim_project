import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:smart_care/chatSystem/chatRoomCtr.dart';
import 'package:smart_care/manager/myUi.dart';
import 'package:smart_care/manager/myVoids.dart';
import 'package:smart_care/manager/styles.dart';

import '../models/user.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final ChatRoomCtr gc = Get.find<ChatRoomCtr>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${gc.userChatWith.name}'),
        centerTitle: true,
        backgroundColor: appbarColor,
        elevation: 10,
      ),
      body: backGroundTemplate(
        child: GetBuilder<ChatRoomCtr>(
          builder:(ctr)=> Stack(
            children: [
              gc.messagesWidgets.isNotEmpty
                  ? SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Column(children: gc.messagesWidgets),
                      SizedBox(height: 90)
                    ],
                  )
              )
                  : Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 115.0),
                  child: Text('send your first message',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18
                    ),
                  ),
                ),
              ),
              MessageBar(

                onSend: (msg) {
                  print('## message_sent > <$msg>');
                  gc.sendMessage(msg);
                },
                replyWidgetColor: Colors.black26,
                sendButtonColor: Colors.white,
                messageBarColor: appbarColor.withOpacity(0.6),


                actions: [
                  InkWell(
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.white70,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: InkWell(
                      child: Icon(
                        Icons.add_a_photo_sharp,
                        color: Colors.white70,
                        size: 24,
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}
