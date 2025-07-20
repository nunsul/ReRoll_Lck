//여기는 게시판에서 사용할 Firebase 연동 용 입니다.
//FirebaseFirestore.instance.collection('boards').add(post.toJson())
// // 위 코드에서 'posts' 부분이 컬렉션 ID!
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Boards {
  final String id; //문서 id
  final String title; //글 제목
  final String content; // 글 내용
  final List<String> imageUrls; // 이미지 url 목록
  final String userId; //작성자 id
  final String userName; //작성자 이름
  final DateTime timestamp; // 작성 시간

  Boards({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.userId,
    required this.userName,
    required this.timestamp,
  });

//Json => Post 객체 변환
  factory Boards.fromJson(Map<String, dynamic> json, String docId){
    return Boards(
      id: docId,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
//Post => Json 객체 변환
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp,
    };
  }
}

class Comments {
  final String  id;
  final String  content;
  final String  userId;
  final String  userName;
  final DateTime  timestamp;

  Comments({
    required this.id,
    required this.content,
    required this.userId,
    required this.userName,
    required this.timestamp,
});

  factory Comments.fromJson(Map<String,dynamic> json,String docId){
    return Comments(
        id: docId,
        content: json['content'] ?? '',
        userId: json['userId'] ?? '',
        userName: json['userName'] ?? '',
        timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String,dynamic> toJson(){
    return{
      'content' : content,
      'userId' : userId,
      'userName' : userName,
      'timestamp' : timestamp
    };
  }

}

