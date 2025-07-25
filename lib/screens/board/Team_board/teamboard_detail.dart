import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/models/models_post.dart';
import 'package:untitled2/widgets/widgets.dart';

class teamboard_detail extends StatefulWidget {
  final String postId;

  const teamboard_detail({required this.postId,super.key});

  @override
  State<teamboard_detail> createState() => _teamboard_detailState();
}

class _teamboard_detailState extends State<teamboard_detail> {
  final TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('자유 게시판')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('team_board')
            .doc(widget.postId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('오류'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('글을 찾을 수 없습니다.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(25),
            children: [
              // 게시글 상단 정보 카드
              Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        //나중에 진짜 이미지로 변경 예정
                        color: Colors.grey[500],
                        child: Icon(Icons.image, size: 30),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['userName'] ?? 'unknown'),
                            SizedBox(height: 4),
                            Text(FormatTimestamp(data['timestamp'])),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(data['title'] ?? '제목 없음', style: TextStyle(fontSize: 25)),
              SizedBox(height: 18),
              Text(data['content'] ?? '내용 없음', style: TextStyle(fontSize: 15)),
              SizedBox(height: 30),
              Divider(),
              // 댓글 영역
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('team_board')
                    .doc(widget.postId)
                    .collection('comments')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('댓글이 없습니다'),
                    );
                  }

                  final comments = snapshots.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final commentData =
                      comments[index].data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(commentData['userName'] ?? ''),
                        subtitle: Text(commentData['content'] ?? ''),
                        trailing: Text(
                          FormatTimestamp(commentData['timestamp']),
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentsController,
                  decoration: InputDecoration(hintText: '댓글을 입력하세요'),
                  maxLength: 200,
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () async {
                  final content = _commentsController.text.trim();
                  if (content.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('내용을 입력하세요!')),
                    );
                    return;
                  }
    if (FirebaseAuth.instance.currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
    Text("로그인 후 댓글을 작성할 수 있습니다")));
    return;}

                  final comment = Comments(
                    id: "",
                    content: content,
                    userId: '임시',
                    userName: '임시',
                    timestamp: DateTime.now(),
                  );

                  await FirebaseFirestore.instance
                      .collection("team_board")
                      .doc(widget.postId)
                      .collection('comments')
                      .add(comment.toJson());

                  _commentsController.clear(); // 작성 후 초기화
                },
                icon: Icon(Icons.send),
              )
            ],
          ),
        ),
      ),
    );
  }
}
