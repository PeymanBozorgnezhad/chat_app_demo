import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<QuerySnapshot<Map<String, dynamic>>>  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where("username", isEqualTo: username)
        .get();
  }
}
