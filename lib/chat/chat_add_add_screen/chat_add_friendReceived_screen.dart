import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/chat_widgets.dart';

class chat_add_friendReceived_screen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final String? myId = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(myId)
            .collection('received_requests')
            .orderBy('timestamp',descending: true)
            .snapshots(),
        builder: (context,snap){
          if(snap.hasError) return Center(child: Text('오류발생!'),);
          if(snap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
          final docs = snap.data!.docs;
          if(docs.isEmpty) return Center(child: Text('친구요청이 비어있습니다!'),);
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context,index){
                final data = docs[index].data() as Map<String,dynamic>;
                return ListTile(
                  leading: CircleAvatar(/*
                    backgroundImage: NetworkImage(url),*/
                  ),
                  title: Text(data['userName']??''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: ()async{
                            final aboutMyId = await FirebaseFirestore.instance.collection('users').doc(myId).get();
                            final about = aboutMyId.data() ?? {};
                            await acceptFriendRequest(
                               myId: myId!,
                               myName: about['userName'] ?? '',
                               myImageUrl: about['imageUrl'] ?? '',
                               otherUserId: data['userUid'] ?? '',
                               otherUserName: data['userName'] ?? '',
                               otherUserImageUrl: data['imageUrl'] ?? ''
                           );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${data['userName']}과 친구가 되었습니다')));
                          },
                          icon: Icon(Icons.check,color: Colors.green,)
                      ),
                      IconButton(
                          onPressed: ()async{
                            await rejectFriendRequest(myId!, data['userUid'] ?? '');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('거절되었습니다.')));
                          },
                          icon: Icon(Icons.close,color: Colors.red,)
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }
}