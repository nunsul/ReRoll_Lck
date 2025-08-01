
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class chat_message_toUserId extends StatefulWidget{
  @override
  State<chat_message_toUserId> createState() => chat_message_toUserIdState();
}
class chat_message_toUserIdState extends State<chat_message_toUserId>{
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
      title: Text('쪽지보내기'),),
    );
  }
}