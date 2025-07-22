

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/screens/board/Team_board/teamboard_detail.dart';
import 'package:untitled2/screens/board/Team_board/teamboard_write.dart';
import 'package:untitled2/widgets/widgets.dart';

class Team_Screen extends StatelessWidget{
  const Team_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('선택한팀'),),
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore
            .instance
            .collection('team_board')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context,snapshots){
          if(snapshots.hasError){
            return Center(child: Text('오류발생!'),);
          }
          if(snapshots.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          final docs = snapshots.data!.docs;
          return ListView.builder(
              itemCount:docs.length,
              itemBuilder:(context,index){
                final data = docs[index].data() as Map<String,dynamic>;
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 6),
                  child: ListTile(
                    title: Text(data['title']??''
                    ,style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['content'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text('${FormatTimestamp(data['timestamp'])}/${data['userName']??''}')
                      ],
                    ),
                    onTap: (){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (_)=>teamboard_detail(postId: docs[index].id))
                      );
                    },
                  ),
                );
              }

          );

              }
          ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (_)=>teamboard_Write()));
      },child: Icon(Icons.add),
      ),

    );
}
}