import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/models/models_post.dart';

class teamboard_Write extends StatefulWidget {
  @override
  State<teamboard_Write> createState() => _teamboard_WriteState();
}

class _teamboard_WriteState extends State<teamboard_Write> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // ✅ 선택된 팀 정보 가져오기
  Future<String> _getSelectedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedTeam') ?? 'T1';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('글쓰기')),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('제목'),
              ),
              maxLines: 1,
              maxLength: 20,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('내용'),
              ),
              maxLength: 200,
              maxLines: 6,
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();

                if (title.isEmpty || content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('제목과 내용을 둘 다 입력해주세요!')),
                  );
                  return;
                }

                try {
                  final teamName = await _getSelectedTeam(); // ✅ 팀 가져오기
                  final user = FirebaseAuth.instance.currentUser; // ✅ 로그인 유저
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('로그인이 필요합니다')),
                    );
                    return;
                  }

                  // Firestore에서 유저 닉네임 가져오기
                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .get();

                  final userName = userDoc['userName'] ?? '익명';

                  final post = Boards(
                    id: '',
                    title: title,
                    content: content,
                    imageUrls: [],
                    userId: user.uid,
                    userName: userName,
                    timestamp: DateTime.now(),
                  );

                  await FirebaseFirestore.instance
                      .collection('team_board')
                      .add({
                    ...post.toJson(),
                    'teamName': teamName, // ✅ 팀 이름도 같이 저장
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('저장 완료!')),
                  );
                  await Future.delayed(Duration(milliseconds: 800));
                  Navigator.pop(context);
                } catch (e) {
                  print('[ERROR] 글 저장 실패: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('오류가 발생했습니다')),
                  );
                }
              },
              child: Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
