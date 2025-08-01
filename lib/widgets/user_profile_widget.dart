
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/widgets/chat_widgets.dart';

import '../chat/chat_message_toUserId.dart';

void user_profile_screen(BuildContext context,{
  required String userName,
  required String imageUrl,
  required String toUserId,
}){
  final currentUser = FirebaseAuth.instance.currentUser;
  final fromUserId = currentUser?.uid ?? '';
  showDialog(
      context: context,
      builder: (context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40)
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            width:1500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [/*
              //나중에 이미지 프로필 생기면 수정
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 40,
                ),*/
                SizedBox(height: 12,),
                Text(userName,style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 18),),
                Divider(),
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    Expanded(child:ElevatedButton(onPressed: ()async{
                      await sendFriendRequest(fromUserId, toUserId);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('친구 요청을 보냈습니다')));
                    }, child: Text('👤 요청')),),
                    Expanded(child: ElevatedButton(onPressed: (){
                      /*Navigator.push(context,
                          MaterialPageRoute(builder: (_)=>chat_message_toUserId()));*/
                    }, child: Text('✉️ 쪽지')),),
                    Expanded(child: ElevatedButton(onPressed: (){
                      //차단 기능 추가하기
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:Text('차단 처리 되었습니다.')));
                    }, child: Text('⛔ 차단')))
                  ],
                )
              ],
            ),
          ),
        );
      });
}