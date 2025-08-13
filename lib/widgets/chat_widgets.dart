import 'package:cloud_firestore/cloud_firestore.dart';

// 친구 요청 보내기
Future<void> sendFriendRequest({
  required String myId,
  required String toUserId,
  required String toUserName,
  required String toUserImageUrl,
  required String myName,
  required String myImageUrl,
}) async {
  final request = FirebaseFirestore.instance;
//내가 보낼 요청
  await request
      .collection('users')
      .doc(myId)
      .collection('send_requests')
      .doc(toUserId)
      .set({
    'timestamp': Timestamp.now(),
    'userName' : toUserName,
    'userUid' : toUserId,
    'imageUrl' : toUserImageUrl
      });
//상대가 받은 요청
  await request
      .collection('users')
      .doc(toUserId)
      .collection('received_requests')
      .doc(myId)
      .set({
    'timestamp': Timestamp.now(),
    'userUid' : myId,
    'userName' : myName,
    'imageUrl' : myImageUrl
      });
}

// 친구 요청 수락
Future<void> acceptFriendRequest({
  required String myId,
  required String myName,
  required String myImageUrl,
  required String otherUserId,
  required String otherUserName,
  required String otherUserImageUrl,
}) async {
  final request = FirebaseFirestore.instance;
//친구 목록에 추가
  await request
      .collection('users')
      .doc(myId)
      .collection('friend_list')
      .doc(otherUserId)
      .set({
    'timestamp': Timestamp.now(),
    'userUid' : otherUserId,
    'userName' : otherUserName,
    'imageUrl' : otherUserImageUrl,
  });
//상대도 목록에 추가
  await request
      .collection('users')
      .doc(otherUserId)
      .collection('friend_list')
      .doc(myId)
      .set({
    'timestamp': Timestamp.now(),
    'userUid' : myId,
    'userName' : myName,
    'imageUrl' : myImageUrl,
      });

  await request
      .collection('users')
      .doc(myId)
      .collection('received_requests')
      .doc(otherUserId)
      .delete();

  await request
      .collection('users')
      .doc(otherUserId)
      .collection('send_requests')
      .doc(myId)
      .delete();
}
// 친구 보낸 요청 거절하기
Future<void> rejectFriendSend(String myId, String otherUserId) async {
  final request = FirebaseFirestore.instance;

  await request
      .collection('users')
      .doc(myId)
      .collection('send_requests')
      .doc(otherUserId)
      .delete();

  await request
      .collection('users')
      .doc(otherUserId)
      .collection('received_requests')
      .doc(myId)
      .delete();
}

// 친구 요청 거절
Future<void> rejectFriendRequest(String myId, String otherUserId) async {
  final request = FirebaseFirestore.instance;

  await request
      .collection('users')
      .doc(myId)
      .collection('received_requests')
      .doc(otherUserId)
      .delete();

  await request
      .collection('users')
      .doc(otherUserId)
      .collection('send_requests')
      .doc(myId)
      .delete();
}
// 친구 여부 확인
Future<bool> isFriend(String myId, String otherUserId) async {
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(myId)
      .collection('friend_list')
      .doc(otherUserId)
      .get();

  return doc.exists;
}
//친구목록에서 삭제하기
Future<void> friend_list_clear(String myId,String otherId)async{
  //내 친구 목록에서 상대 삭제하기
  await FirebaseFirestore.instance
      .collection('users')
      .doc(myId)
      .collection('friend_list')
      .doc(otherId)
      .delete();
  //상대 친구목록에서 내 아이디 삭제하기
  await FirebaseFirestore.instance
      .collection('users')
      .doc(otherId)
      .collection('friend_list')
      .doc(myId)
      .delete();
}
//친구 차단하기
Future<void> friend_block(String myId,String otherId)async{
  await FirebaseFirestore.instance
      .collection('users')
      .doc(myId)
      .collection('block_users')
      .doc(otherId)
      .set({
    'userName': otherId ?? '',
  });
  // 친구 목록에서 삭제
  friend_list_clear(myId, otherId);
}