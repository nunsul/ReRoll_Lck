import 'package:cloud_firestore/cloud_firestore.dart';

// 친구 요청 보내기
Future<void> sendFriendRequest(String fromUserId, String toUserId) async {
  final request = FirebaseFirestore.instance;

  await request
      .collection('users')
      .doc(fromUserId)
      .collection('sent_requests')
      .doc(toUserId)
      .set({'timestamp': Timestamp.now(),});

  await request
      .collection('users')
      .doc(toUserId)
      .collection('received_requests')
      .doc(fromUserId)
      .set({'timestamp': Timestamp.now()});
}

// 친구 요청 수락
Future<void> acceptFriendRequest(String myId, String otherUserId) async {
  final request = FirebaseFirestore.instance;

  await request
      .collection('users')
      .doc(myId)
      .collection('friend_list')
      .doc(otherUserId)
      .set({'timestamp': Timestamp.now()});

  await request
      .collection('users')
      .doc(otherUserId)
      .collection('friend_list')
      .doc(myId)
      .set({'timestamp': Timestamp.now()});

  await request
      .collection('users')
      .doc(myId)
      .collection('received_requests')
      .doc(otherUserId)
      .delete();

  await request
      .collection('users')
      .doc(otherUserId)
      .collection('sent_requests')
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
      .collection('sent_requests')
      .doc(myId)
      .delete();
}

// 친구 여부 확인
Future<bool> isFriend(String myId, String otherUserId) async {
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(myId)
      .collection('friend_list') // 여기만 수정!
      .doc(otherUserId)
      .get();

  return doc.exists;
}
