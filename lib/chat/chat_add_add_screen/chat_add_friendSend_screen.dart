import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/widgets/chat_widgets.dart';

class chat_add_friendSend_screen extends StatelessWidget{
@override
  Widget build(BuildContext context) {
  final String? myId = FirebaseAuth.instance.currentUser?.uid;
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(myId)
            .collection('send_requests')
            .orderBy('timestamp',descending: true)
            .snapshots(),
        builder: (context,snap){
          if(snap.hasError) return Center(child: Text('오류발생!'),);
          if(snap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
          final docs = snap.data!.docs;
          if(docs.isEmpty) return Center(child: Text('친구 요청이 비어있습니다!\n친구요청을 보내보세요!'),);
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context,index){
                final data = docs[index].data() as Map<String,dynamic>;
                return ListTile(
                  leading: CircleAvatar(/*
                    backgroundImage: NetworkImage(url),*/
                  ),
                  title: Text(data['userName']??''),
                  trailing: IconButton(
                      onPressed: ()async{
                        await rejectFriendSend(myId!, data['userUid']??'');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${data['userName']}의 요청을 취소하였습니다.')));
                      }, icon: Icon(Icons.close,color: Colors.red,)),
                );
              }
          );
        }
    );
  }
}