
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class signup_screen extends StatefulWidget{
  @override
  State<signup_screen> createState()=> _signup_screenState();
}
class _signup_screenState extends State<signup_screen>{
  //userId == 즉 이메일이 id입니다.
  final _userIdController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userPwController = TextEditingController();
  final _reuserPwController = TextEditingController();

  @override
  void dispose(){
    _userIdController.dispose();
    _userNameController.dispose();
    _userPwController.dispose();
    _reuserPwController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입'),),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _userIdController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('이메일')
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: _userNameController,
            decoration: InputDecoration(
            border: OutlineInputBorder(),
            label: Text('닉네임')
            )
          ),
          SizedBox(height: 20,),
          TextField(
              controller: _userPwController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('비밀번호')
              )
          ),
          SizedBox(height: 20,),
          TextField(
              controller: _reuserPwController,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('비밀번호 재입력')
              )
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed:()async{
            final userId = _userIdController.text.trim();
            final userName = _userNameController.text.trim();
            final userPw = _userPwController.text.trim();
            final userrePw = _reuserPwController.text.trim();
            
            if(userId.isEmpty||userName.isEmpty||userPw.isEmpty||userrePw.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
              Text('모든 칸을 입력해주세요!')));
              return;
            }
            if(userPw!=userrePw){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('비밀번호가 일치하지 않습니다!')));
              return;
            }
            //닉네임 중복 검사하기
            final userNamecheck = await FirebaseFirestore
                .instance
                .collection('users')
                .where('userName',isEqualTo: userName)
                .get();
            if(userNamecheck.docs.isNotEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('이미 사용 중인 닉네임입니다')));
              return;
            }
            try{
               await FirebaseAuth.instance.createUserWithEmailAndPassword(
                   email: userId, password: userPw);
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
               Text('회원가입 성공!')));
               Navigator.pop(context);
            }on FirebaseAuthException catch (e) {
              String message = '회원가입 실패';
              if (e.code == 'email-already-in-use') {
                message = '이미 등록된 이메일입니다.';
              } else if (e.code == 'invalid-email') {
                message = '올바른 이메일 형식이 아닙니다.';
              } else if (e.code == 'weak-password') {
                message = '비밀번호는 6자리 이상이어야 합니다.';
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$message')));
            }
          },child: Text('회원가입'))
        ],


      ),
    );
  }
}