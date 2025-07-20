import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled2/widgets/widgets.dart';

class free_detail extends StatelessWidget{
  final TextEditingController _commentsController = TextEditingController();
  final String postId;
  free_detail({required this.postId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text('자유 게시판'),),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore
              .instance
              .collection('boards')
              .doc(postId)
              .get(),
          builder: (context,snapshots){
          if(snapshots.hasError){
            return Center(child: Text('오류'),);
          }
          if(snapshots.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(!snapshots.hasData||!snapshots.data!.exists){
            return Center(child: Text('글을 찾을 수 없습니다.'),);
          }
          final data = snapshots.data!.data() as Map<String,dynamic>;

          return ListView(
            padding: const EdgeInsets.all(25),
            children: [
              Card(
                margin: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        //나중에 진짜 이미지로 바꿀 예정
                        color: Colors.grey[500],
                        child: Icon(Icons.image,size: 30,),
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['userId'] ?? 'unknown'
                            ),
                            SizedBox(height: 4,),
                            Text(
                                FormatTimestamp(data['timestamp']))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Text(
                data['title'] ?? '제목없음',style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 12,),
              Text(
                data['content'] ?? '내용없음',style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 30,),
              TextField(
                controller: _commentsController,


              )
            ],
          );
          }
          ),
    );
  }
}