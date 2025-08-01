import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled2/screens/home/team_selectscreen.dart';
import 'package:untitled2/screens/home/home_screen.dart';
import 'package:untitled2/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    //2초동안 로그 보이고 그다음 실행
    Timer(Duration(seconds: 2), ()async{
      bool isFirst = await checkFirstLaunch();

      if(isFirst){
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_)=>team_selectscreen()));
      }else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_)=>RerollMain()));
      }
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text('ReRoll',style: TextStyle(
            fontWeight: FontWeight.bold,fontSize: 40),),
      ),

    );
  }

}
