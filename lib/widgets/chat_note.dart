import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void chat_note(BuildContext context,{
  required String otherUid,
  required String userName
})async{
  final _noteController = TextEditingController();
  final myId = FirebaseAuth.instance.currentUser!.uid;
  final aboutMyId =  await FirebaseFirestore.instance.collection('users').doc(myId).get();
  final myName = aboutMyId['userName'] ?? '';
  final myImageUrl = aboutMyId['imageUrl'] ?? '';
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('쪽지보내기'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('to $userName',style: TextStyle(fontWeight: FontWeight.bold),),
              TextField(
                controller: _noteController,
                maxLength: 50,
                decoration: InputDecoration(
                  hintText: '간단한 인사'
                ),
              )
            ],
          ),
          actions: [
            IconButton(onPressed: ()async{
              final String note = _noteController.text.trim();
              if(note.isEmpty) return;
              final aboutNote = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(otherUid)
                  .collection('notes')
                  .doc(myId);
              final doc = await aboutNote.get();
              if(doc.exists){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('이미 쪽지를 보냈습니다')));
                return;
              }
              await aboutNote.set({
                'userName' : myName,
                'imageUrl' : myImageUrl,
                'timestamp' : FieldValue.serverTimestamp(),
                'content' : note,
              });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('쪽지를 전송했습니다!')));
            Navigator.pop(context);
            }, icon: Icon(Icons.check,color: Colors.green,)),
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.close,color: Colors.red,))
          ],
        );
      }
  );
}