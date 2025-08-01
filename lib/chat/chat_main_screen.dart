
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_add_screen.dart';

class chat_main_screen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length:3,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
              title: Text('채팅'),
            actions: [
              IconButton(onPressed: (){

              }, icon: Icon(Icons.search_rounded))
            ],
            bottom: TabBar(tabs:[
              Tab(text: '대화',),
              Tab(text: '쪽지',),
              Tab(text: '알림',)
            ] ),
          ),
        body: TabBarView(
            children: [
          Text('대화'),
          Text('쪽지'),
          Text('알림'),
        ]),
        floatingActionButton: FloatingActionButton(onPressed:(){
          Navigator.push(context,
              MaterialPageRoute(builder:(_)=>chat_add_screen()));
        },child: Icon(Icons.add),),
        ),
    );
  }
  }

  