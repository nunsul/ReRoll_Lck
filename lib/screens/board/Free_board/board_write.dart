import 'package:cloud_firestore/cloud_firestore.dart';
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
      resizeToAvoidBottomInset: true, // 키보드 올라올 때 자동으로 body 줄이기
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

                final posts = Boards(
                  id: '',
                  title: title,
                  content: content,
                  imageUrls: [],
                  userId: 'abv',
                  userName: 'abc',
                  timestamp: DateTime.now(),
                );

                await FirebaseFirestore.instance
                    .collection('boards')
                    .add(posts.toJson());

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('저장 완료!'),
                    duration: Duration(milliseconds: 800),
                  ),
                );

                await Future.delayed(const Duration(milliseconds: 800));
                Navigator.pop(context);
              },
              child: const Text('등록'),
            ),
          ],
        ),
      ),
    );
  }
}
