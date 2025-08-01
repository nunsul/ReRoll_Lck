import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

//선택한 팀 데려오는 함수
class GetSelectedTeam {
  static Future<String?> getSelectedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedTeam');
  }

  static Future<void> clearSelectedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selectedTeam');
  }

  static Future<void> updateSelectedTeam(String team) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTeam', team);
  }
}

//실행이 처음인지 아닌지 확인
Future<bool> checkFirstLaunch() async {

  if (kIsWeb) {
    return false; // Web은 무조건 처음 아님 처리
  }
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  // 첫 실행이면 false로 바꿔서 다시 안 들어오게
  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
  }

  return isFirstLaunch;
}


// timestamp 받아오면 사용가능하게 포멧
String FormatTimestamp(dynamic timestamp) {
  if (timestamp == null) return ''; // null이면 빈 문자열 반환

  // Timestamp 객체를 DateTime으로 변환 (Firebase Timestamp일 경우)
  DateTime dateTime = (timestamp as Timestamp).toDate();

  // 날짜를 '2025.07.20' 형식(년.월.일, 두 자리 월/일)으로 반환
  return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
}

//로그인 유저 아니면 막는거
/*
if (FirebaseAuth.instance.currentUser == null) {
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
Text("로그인 후 댓글을 작성할 수 있습니다")));
return;
*/

