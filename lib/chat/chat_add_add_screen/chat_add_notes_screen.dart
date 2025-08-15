import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/user_profile_widget.dart';

class chat_add_notes_screen extends StatelessWidget{
  const chat_add_notes_screen({super.key});
  @override
  Widget build(BuildContext context) {
    final String myUid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(myUid)
              .collection('notes')
              .orderBy('timestamp',descending:true)
              .snapshots(),
          builder: (context,snap){
            if(snap.hasError) return Center(child: Text('오류발생'),);
            if(snap.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator(),);
            final docs = snap.data!.docs;
            if(docs.isEmpty) return Center(child: Text('받은 쪽지가 없습니다!'),);
            return ListView.builder(
                itemCount:docs.length,
                itemBuilder:(context,index){
                  final otherUid = docs[index].id;
                  final data = docs[index].data() as Map<String,dynamic>;
                  return ListTile(
                    //나중에 이미지 받으면 프로필 하튼 꾸밀거임
                    leading:GestureDetector(
                      onTap: (){
                        user_profile_screen(context, userName: data['userName'] ?? '',
                            imageUrl: data['imageUrl'] ?? '', toUserId: otherUid
                        );
                      },
                      child:CircleAvatar(/*
                      backgroundImage: NetworkImage(url),*/
                    ),
                    ),
                    title: Text(data['userName']??''),
                    onTap: (){
                      showDialog(context: context,
                          builder: (context){
                        return AlertDialog(
                          title: Text('from ${data['userName']}'),
                          content: Text(data['content']),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: Text('닫기'))
                          ],
                          );
                          }
                          );
                    },
                    trailing: IconButton(onPressed: ()async{
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(myUid)
                          .collection('notes')
                          .doc(otherUid)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('쪽지를 삭제했습니다.')));
                    }, icon: Icon(Icons.close,color: Colors.red,)),
                  );
                }
            );
          }
      ),
    );
  }
}