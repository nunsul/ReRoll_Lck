import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import 'package:untitled2/models/models_post.dart';

class signup_screen extends StatefulWidget {
  @override
  State<signup_screen> createState() => _signup_screenState();
}

class _signup_screenState extends State<signup_screen> {
  // File? _profileImage; // ❌ 이미지 파일 변수 비활성화

  final _userIdController = TextEditingController();
  final _userNameController = TextEditingController();
  final _userPwController = TextEditingController();
  final _reuserPwController = TextEditingController();

  /*
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }
  */

  @override
  void dispose() {
    _userIdController.dispose();
    _userNameController.dispose();
    _userPwController.dispose();
    _reuserPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          /*
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 40,
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? Icon(Icons.add_a_photo, size: 30)
                  : null,
            ),
          ),
          SizedBox(height: 16),
          */
          TextField(
            controller: _userIdController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '이메일',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _userNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '닉네임',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _userPwController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '비밀번호',
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _reuserPwController,
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '비밀번호 재입력',
            ),
          ),
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: () async {
              final userId = _userIdController.text.trim();
              final userName = _userNameController.text.trim();
              final userPw = _userPwController.text.trim();
              final userrePw = _reuserPwController.text.trim();

              if (userId.isEmpty || userName.isEmpty || userPw.isEmpty || userrePw.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('모든 칸을 입력해주세요!')));
                return;
              }
              if (userPw != userrePw) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('비밀번호가 일치하지 않습니다!')));
                return;
              }

              final userNamecheck = await FirebaseFirestore.instance
                  .collection('users')
                  .where('userName', isEqualTo: userName)
                  .get();

              if (userNamecheck.docs.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('이미 사용 중인 닉네임입니다')));
                return;
              }

              try {
                print('[DEBUG] 회원가입 시작');
                final credential = await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                    email: userId, password: userPw);

                final uid = credential.user!.uid;

                // ✅ 기본 이미지 URL 사용 (Storage 연결 안 되어 있을 때)
                String photoUrl = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';

                /*
                // ✅ Storage 연결 시 다시 활성화
                if (_profileImage != null) {
                  print('[DEBUG] 선택된 이미지 경로: ${_profileImage!.path}');
                  final ref = FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
                  final uploadTask = await ref.putFile(_profileImage!);
                  if (uploadTask.state == TaskState.success) {
                    photoUrl = await ref.getDownloadURL();
                  }
                }
                */

                print('[DEBUG] Firestore 저장 시작');

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .set(users(
                  userdocid: uid,
                  imageUrls: photoUrl,
                  userName: userName,
                  timestamp: DateTime.now(),
                  userId: userId,
                ).toJson());

                print('[DEBUG] Firestore 저장 완료');

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원가입 성공!')));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => RerollMain()),
                      (route) => false,
                );
              } catch (e) {
                print('[ERROR] 회원가입 실패: $e');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('회원가입 실패: ${e.toString()}')),
                );
              }
            },
            child: Text('회원가입'),
          ),
        ],
      ),
    );
  }
}
