import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/screens/board/Free_board/board_free_screen.dart';
import 'package:untitled2/screens/board/Team_board/board_teamboard_screen.dart';

class BoardMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('게시판'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Main'),
              Tab(text: '자유'),
              Tab(text: '팀게시판'),
              Tab(text: '갤러리'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Text('메인'),
            free_screen(),
            Team_Screen(),
            Text('갤러리'),
          ],
        ),
      ),
    );
  }
}
