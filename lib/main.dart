import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/firebase_options.dart';
import 'package:untitled2/screens/home/home_screen.dart';
import 'package:untitled2/screens/home/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 이미 초기화된 Firebase 앱이 없을 때만 초기화
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('🔥 Firebase already initialized or duplicate: $e');
  }

  runApp(ReRoll());
}
class ReRoll extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      );
  }
}