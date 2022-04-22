import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<QuerySnapshot<Map<String, dynamic>>> getUserByUsername(
      String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("username", isEqualTo: username)
        .get();
  }

  createChatRoom({required String chatRoomId, required charRoomMap}) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(charRoomMap)
        .catchError(
          (e) => print(
            e.toString(),
          ),
        );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserByEmail(
      String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: email)
        .get();
  }

  addConversationMessage({required String chatRoomId, required messageMap}) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getConversationMessage(
      {required String chatRoomId}) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .get();
  }

  Stream getChatRooms(String userName) {
    return FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: userName)
        .snapshots();
  }
}
