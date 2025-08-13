import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TeamEditScreen extends StatefulWidget{
  final String postId;
  const TeamEditScreen({super.key,required this.postId});
  @override
  State<TeamEditScreen> createState()=> _FreeEditScreenState();
}
class _FreeEditScreenState extends State<TeamEditScreen>{
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    _loadPost();
  }
  @override
  void dispose(){
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  //이전 정보 가져와서 미리 세팅해놓기
  Future<void> _loadPost() async{
    final doc = await FirebaseFirestore
        .instance
        .collection('team_board')
        .doc(widget.postId)
        .get();
    final data = doc.data() as Map<String,dynamic>;
    if(data != null){
      _titleController.text = data['title'] ?? '';
      _contentController.text = data['content'] ?? '';
    }
    setState(() => _isloading = false);
  }
  //저장한 정보 업로드하기
  Future<void> _uploadPost() async{
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if(title.isEmpty||content.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('제목과 내용 모두 입력해주세요!')));
      return;
    }
    await FirebaseFirestore.instance
        .collection('team_board')
        .doc(widget.postId)
        .update({
      'title' : title,
      'content' : content,
    });
    Navigator.pop(context,true);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
    Text('게시글이 수정 되었습니다!')));
  }
  @override
  Widget build(BuildContext context) {
    if(_isloading){
      return Scaffold(
        appBar: AppBar(title: Text('게시글 수정'),),
        body: Center(child: CircularProgressIndicator(),),
      );
    }
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border:OutlineInputBorder(),
                labelText: '제목',
              ),
              maxLines: 1,
              maxLength: 20,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '내용'
              ),
              maxLines: 6,
              maxLength: 200,
            ),
            ElevatedButton(onPressed:_uploadPost, child: Text('수정 완료'))
          ],
        ),),
    );
  }
}
