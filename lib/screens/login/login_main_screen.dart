import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/screens/login/signup_screen.dart';
import 'findidorpw_screen.dart';

class login_main extends StatefulWidget{
  const login_main({super.key});
  @override
  State<login_main> createState()=> _login_mainState();
}
class _login_mainState extends State<login_main>{
  final _emailid = TextEditingController();
  final _password = TextEditingController();
@override
  void dispose(){
    _emailid.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인'),),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: _emailid,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '이메일을 입력하세요'
            ),
          ),
          SizedBox(height: 15),
          TextField(
            controller: _password,
            obscureText: true,//비밀번호 안보이게
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: '비밀번호를 입력하세요',
            ),
          ),
          SizedBox(height: 5,),
          ElevatedButton(onPressed: ()async{
            try{
              final credential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                  email: _emailid.text.trim(), password: _password.text.trim());
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('로그인 성공!')));
              Navigator.pop(context);
            } on FirebaseAuthException catch (e){
              String message = '로그인실패';

              if (e.code == 'user-not-found') {
                message = '사용자를 찾을 수 없습니다.';
              } else if (e.code == 'wrong-password') {
                message = '비밀번호가 틀렸습니다.';
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ $message")),
              );
            }
            }, child: Text('로그인')
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context,
                         MaterialPageRoute(builder: (_)=> signup_screen()));
                   },child: Text('회원가입'),
                 ),
                 SizedBox(width: 30,),
                 GestureDetector(
                   onTap: (){/*
                     Navigator.push(context,
                         MaterialPageRoute(builder: (_)=>findidorpw_screen()));*/
                   },child: Text('아이디/비밀번호 찾기'),
                 ),
               ], 
              ),
          SizedBox(height: 20,),
          Divider(),
          SizedBox(height: 10,),
          ElevatedButton(
              onPressed: (){
                
              },
              child: Text('나중에 구글 로그인 예정'))
          
        ],
      ),
      ),
    );
  }
}