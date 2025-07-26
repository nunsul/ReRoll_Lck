
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chat_add_screen extends StatelessWidget{
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
            Tab(text: '친구목록',),
            Tab(text: '받은요청',),
            Tab(text: '보낸요청',),
          ]),
          ),
          body: TabBarView(
              children: [
                Text('친구목록'),
                Text('받은요청'),
                Text('보낸요청'),
              ]),
        ),
    );
  }
}