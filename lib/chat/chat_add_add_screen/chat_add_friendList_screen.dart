import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/widgets/chat_widgets.dart';

class add_friendList_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? myId = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(myId)
          .collection('friend_list')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('오류 발생!'));
        }
        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return Center(child: Text('아직 친구가 없습니다 \n 친구를 추가하세요!'));
        }
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return ListTile(
              leading: CircleAvatar(
                // 차후 이미지 추가 시 사용
                // backgroundImage: NetworkImage(data['imageUrl'] ?? ''),
              ),
              title: Text(data['userName'] ?? ''),
              trailing: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'delete') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('정말로 ${data['userName']}을 삭제하겠습니까?'),
                        actions: [
                          IconButton(
                            onPressed: ()  async{
                              friend_list_clear(myId!, data['userUid']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${data['userName']}가 삭제되었습니다!'),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.check),
                            color: Colors.green,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    );
                  }
                  if (value == 'block') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('정말로 ${data['userName']}을 차단하시겠습니까?'),
                        actions: [
                          IconButton(
                            onPressed: () async {
                              // 차단된 사용자 정보를 blocked_list에 추가
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(myId)
                                  .collection('block_users')
                                  .doc(data['userUid'])
                                  .set({
                                'userName': data['userName'],
                              });
                              // 친구 목록에서 삭제
                              friend_list_clear(myId!, data['userUid']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${data['userName']}가 차단되었습니다!'),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.check),
                            color: Colors.green,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('삭제'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'block',
                      child: Row(
                        children: [
                          Icon(Icons.block, color: Colors.red),
                          SizedBox(width: 8),
                          Text('차단'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            );
          },
        );
      },
    );
  }
}
