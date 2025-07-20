
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/models/models_post.dart';

class WritePage extends StatefulWidget{
  @override
  State<WritePage> createState() => _WritePageState();
}
class _WritePageState extends State<WritePage>{
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
      appBar: AppBar(title: Text('글 쓰기')),
      body: Padding(padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
              ),
              label: Text('제목')
            ),
            maxLines: 1,
            maxLength: 20,
          ),
          SizedBox(height: 20,),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(
              label: Text('내용'),
              border: OutlineInputBorder(),
            ),
            maxLines: 6,
            maxLength: 200,
          ),
          SizedBox(height: 20,),
          ElevatedButton
            (onPressed:() async{
              final title = _titleController.text.trim();
              final content = _contentController.text.trim();
              if(title.isEmpty||content.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('제목과 내용을 모두 입력해주세요!')));
                return;
              }
              final posts = Boards(id: '', title: title, content: content, imageUrls: [], userId: 'abv', userName: 'abc', timestamp:DateTime.now());

              await FirebaseFirestore
                  .instance
                  .collection('boards')
                  .add(posts.toJson());

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('저장완료!'),duration: Duration(milliseconds: 800),)
              );

              await Future.delayed(Duration(milliseconds: 800));
              Navigator.pop(context);
              }, child: Text('저장'))
        ],
      ),
      ),
    );
  }
}