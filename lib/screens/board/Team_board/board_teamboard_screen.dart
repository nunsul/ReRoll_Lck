import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/screens/board/Team_board/teamboard_detail.dart';
import 'package:untitled2/screens/board/Team_board/teamboard_write.dart';
import 'package:untitled2/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ 선택한 팀 가져오는 함수
Future<String> GetSelectedTeam() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('selectedTeam') ?? '오류';
}

class Team_Screen extends StatelessWidget {
  const Team_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: GetSelectedTeam(), // ✅ 선택된 팀 불러오기
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: Text('로딩 중...')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final selectedTeam = snapshot.data!;

        return Scaffold(
          appBar: AppBar(
            title: Text('$selectedTeam 게시판'),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('team_board')
                .where('teamName', isEqualTo: selectedTeam) // ✅ 팀 이름 필터링
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshots) {
              if (snapshots.hasError) {
                return Center(child: Text('오류 발생!'));
              }
              if (snapshots.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final docs = snapshots.data!.docs;

              if (docs.isEmpty) {
                return Center(
                  child: Text(
                    '아직 게시글이 없습니다.\n첫 글을 작성해보세요!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                );
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: ListTile(
                      title: Text(
                        data['title'] ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['content'] ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text('${FormatTimestamp(data['timestamp'])} / ${data['userName'] ?? ''} / 조회수: ${data['views'] ?? 0}')
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => teamboard_detail(postId: docs[index].id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => teamboard_Write()),
              );
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
