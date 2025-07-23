// Firestore의 Timestamp를 'YYYY.MM.DD' 형식으로 변환하는 함수
import 'package:cloud_firestore/cloud_firestore.dart';



String FormatTimestamp(dynamic timestamp) {
  if (timestamp == null) return ''; // null이면 빈 문자열 반환

  // Timestamp 객체를 DateTime으로 변환 (Firebase Timestamp일 경우)
  DateTime dateTime = (timestamp as Timestamp).toDate();

  // 날짜를 '2025.07.20' 형식(년.월.일, 두 자리 월/일)으로 반환
  return '${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}';
}


