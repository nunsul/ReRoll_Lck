
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/chat/chat_add_add_screen/chat_add_friendList_screen.dart';

import 'chat_add_add_screen/chat_add_friendReceived_screen.dart';
import 'chat_add_add_screen/chat_add_friendSend_screen.dart';

class chat_add_screen extends StatelessWidget{
  const chat_add_screen({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(title: Text('친구관리'),
          actions: [
            IconButton(onPressed: (){

            }, icon: Icon(Icons.search_rounded))
          ],
          bottom: TabBar(tabs: [
            Tab(text:'쪽지',),
            Tab(text:'보낸요청',),
            Tab(text:'받은요청',),
          ]),
          ),
          body: TabBarView(
              children: [
                Text('쪽지'),
                chat_add_friendSend_screen(),
                chat_add_friendReceived_screen(),
              ]),
        ),
    );
  }
}