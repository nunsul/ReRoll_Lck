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

}