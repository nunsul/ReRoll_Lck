
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/screens/board/Free_board/board_free_detail.dart';
import 'package:untitled2/screens/board/Free_board/board_free_screen.dart';
import 'package:untitled2/screens/board/Team_board/board_teamboard_screen.dart';
import 'package:untitled2/widgets/widgets.dart';

import 'Team_board/teamboard_detail.dart';

class main_board_screen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ListView(padding: EdgeInsets.all(20),
      children: [
        TextButton(onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (_)=>free_screen()));
        }, child: Text("🔥 자유 게시판 HOT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
        ),
        FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore
                .instance
                .collection('boards')
                .orderBy('views',descending: true)
                .limit(3)
                .get(),
            builder:(context,snaps){
              if(!snaps.hasData||snaps.data!.docs.isEmpty) {
                return Center(child:Text('게시글이 없습니다!'));
              }
              final docs = snaps.data!.docs;
              return Column(
                children: docs.map((datas){
                  final data = datas.data() as Map<String,dynamic>;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(data['title']??''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['content']??'',maxLines: 2,overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 3,),
                          Text('${FormatTimestamp(data['timestamp'])}/${data['userName'] ?? '익명'} / 조회수: ${data['views'] ?? 0}')
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FreeDetail(postId: datas.id),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            }
        ),
        SizedBox(height: 10,),
        TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (_)=>Team_Screen()));
        }, child: Text('🔥 팀 게시판 HOT',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore
                .instance
                .collection('team_board')
                .orderBy('views',descending: true)
                .limit(3)
                .get(),
            builder:(context,snaps){
              if(!snaps.hasData||snaps.data!.docs.isEmpty) {
                return Center(child:Text('게시글이 없습니다!'));
              }
              final docs = snaps.data!.docs;
              return Column(
                children: docs.map((datas){
                  final data = datas.data() as Map<String,dynamic>;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(data['title']??''),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data['content']??'',maxLines: 2,overflow: TextOverflow.ellipsis,),
                          SizedBox(height: 4),
                          Text('${FormatTimestamp(data['timestamp'])} / ${data['userName'] ?? '익명'} / 조회수: ${data['views'] ?? 0}')
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => teamboard_detail(postId: datas.id),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            }),
        SizedBox(height: 10),
        TextButton(onPressed: (){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('공지사항 화면은 준비 중입니다!')));
        }, child: Text('📢 공지사항'))


      ],

    );
  }
}