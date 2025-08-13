import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/screens/home/real_home_screen.dart';

import '../../chat/chat_main_screen.dart';
import '../board/board_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../board/main_board_screen.dart';
import '../login/login_main_screen.dart';
import 'mypage_screen.dart';

class RerollMain extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return RerollMainScreen();

  }
}
class RerollMainScreen extends StatefulWidget{
  @override
  State<RerollMainScreen> createState()=> _RerollMainScreenState();
}
class _RerollMainScreenState extends State<RerollMainScreen>{
  int selectedIndex = 0;

  final List<Widget> pages = [
    real_home_screen(),
    Center(child: Text('경기정보'),),
    BoardMain(),
    chat_main_screen(),
    Center(child: Text('승부예측'),),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ReRoll',
        style: TextStyle(fontSize: 18,color: Colors.black),),
        actions: [
          StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder:(context,snap){
                final user = snap.data;
                if(user==null){
                  return IconButton(onPressed:(){
                    Navigator.push(context,
                        MaterialPageRoute(builder:(_)=>login_main()));
                  },icon: Icon(Icons.account_box));
                }else {
                  return IconButton(onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => mypage_screen()));
                  }, icon: Icon(Icons.accessibility_new_rounded));
                }
              })
        ],
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:selectedIndex,
      onTap: (int index){
          if(index == 3 && FirebaseAuth.instance.currentUser==null){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('채팅은 로그인이 필요합니다!') ));
            return;
          }
        setState(() {
          selectedIndex = index;
        });
      },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(color: Colors.black),
        unselectedLabelStyle: TextStyle(color: Colors.grey),

        items: const[
          BottomNavigationBarItem(icon: Icon(Icons.home_filled),
              label: '홈'
          ),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports),
            label: '경기정보'
        ),
          BottomNavigationBarItem(icon: Icon(Icons.article),
          label: '게시판'
          ),
          BottomNavigationBarItem(icon: Icon(Icons.chat),
          label: '채팅'
          ),
          BottomNavigationBarItem(icon: Icon(Icons.batch_prediction_sharp),
          label: '승부예측'
          ),
        ],
      ),
    );
  }
}