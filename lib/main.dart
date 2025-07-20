import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/firebase_options.dart';
import 'package:untitled2/screens/home/home_screen.dart';
//안녕하세요 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ReRoll());
}

class ReRoll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RerollMain(),
      );
  }
}