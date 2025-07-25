
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/screens/home/home_screen.dart';

class mypage_screen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마이 페이지'),),
      body: ListView(
        children: [
          Divider(),
          TextButton(onPressed:() {

          }, child: Text('공지사항')),
          Divider(),
          TextButton(onPressed:() {

          }, child: Text('관리자에게 문의')),
          Divider(),
          TextButton(onPressed:() {

          }, child: Text('푸시알림 설정')),
          Divider(),
          TextButton(onPressed:() {

          }, child: Text('차단목록')),
          Divider(),
          TextButton(onPressed:() {

          }, child: Text('이용약관')),
          Divider(),
          TextButton(onPressed:() {
            showDialog(context: context,
                builder: (context){
              return AlertDialog(
                title: Text('로그아웃'),
                content: Text('정말로 로그아웃 하시겠습니까?'),
                actions: [
                  TextButton(onPressed: ()async{
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (_)=>RerollMain()),
                        (route)=>false);
                  }, child: Text('네')),
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('아니요'))
                ],
                
              );
                });

            
          }, child: Text('로그아웃')),
        ],
      ),
    );
  }
}