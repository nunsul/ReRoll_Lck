
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled2/screens/home/home_screen.dart';

class team_selectscreen extends StatelessWidget{
  final List<String> teams = ['T1','Gen','Hle','Dk','Kt','Bro','Drx','Lsb','Kdf'];
  Future<void> _savedSelectedTeam(BuildContext context,String team)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTeam', team);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder:(_)=> RerollMain()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('응원하는 팀을 선택해주세요'),),
      body: ListView.builder(
          itemCount:teams.length,
          itemBuilder:(context,index){
            final team = teams[index];
            return Card(
              child: ListTile(
                title: Text(team),
                trailing: Icon(Icons.arrow_forward),
                onTap: (){
                  showDialog(context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text('팀 선택'),
                          content: Text('정말로 $team를 선택하시겠습니까?'),
                          actions: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                              _savedSelectedTeam(context, team);
                            }, child: Text('네')),
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                            },
                                child: Text('아니요'))
                          ],
                        );
                      });
                },
              ),
            );
          }),
    );
  }
}