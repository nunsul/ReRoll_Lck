
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/models/models_post.dart';

class teamboard_Write extends StatefulWidget{
@override
  State<teamboard_Write> createState()=> _teamboard_WriteState();
}
class _teamboard_WriteState extends State<teamboard_Write>{
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void dispose(){
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('글쓰기'),),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  border:OutlineInputBorder(),
                  label: Text('제목')
              ),
              maxLines: 1,
              maxLength: 20,
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                label: Text('내용')
              ),
              maxLength: 200,
              maxLines: 6,
            ),
            SizedBox(height: 15,),
            ElevatedButton(onPressed: () async{
              final title = _titleController.text.trim();
              final content = _contentController.text.trim();
              if(title.isEmpty||content.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('제목과 내용을 둘 다 입력해주세요!') ));
                  return;
                }
              final posts = Boards(id:'',title: title,content: content,imageUrls: [],userId: '',userName: '',timestamp: DateTime.now());
              await FirebaseFirestore.instance
                    .collection('team_board')
                    .add(posts.toJson());

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('저장완료!')));
              await Future.delayed(Duration(milliseconds: 800));
              Navigator.pop(context);

            }, child: Text('등록'))
          ],

        ),
      ),

    );

  }
}
