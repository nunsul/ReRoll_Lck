import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/models/models_post.dart';

class WritePage extends StatefulWidget {
  const WritePage({super.key});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('글 쓰기')),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '제목',
              ),
              maxLines: 1,
              maxLength: 20,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '내용',
              ),
              maxLines: 6,
              maxLength: 200,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text.trim();
                final content = _contentController.text.trim();

                if (title.isEmpty || content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('제목과 내용을 모두 입력해주세요!')),
                  );
                  return;
                }

                try {
                  // ✅ 로그인된 유저 확인
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('로그인이 필요합니다')),
                    );
                    return;
                  }

                  // ✅ Firestore에서 닉네임 가져오기
                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .get();
                  final userName = userDoc['userName'] ?? '익명';
                  final userId = userDoc['userId'];
                  final userUid = userDoc.id;
                  final imageUrl = userDoc['imageUrl'];

                  final post = Boards(
                    id: '',
                    title: title,
                    content: content,
                    imageUrls: [],
                    imageUrl: imageUrl,
                    userId: userId,
                    userUid: userUid,
                    userName: userName,
                    timestamp: DateTime.now(),
                  );

                  await FirebaseFirestore.instance
                      .collection('boards')
                      .add(post.toJson());

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('저장 완료!')),
                  );

                  await Future.delayed(const Duration(milliseconds: 800));
                  Navigator.pop(context);
                } catch (e) {
                  print('[ERROR] 글 저장 실패: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('오류가 발생했습니다')),
                  );
                }
              },
              child: const Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
