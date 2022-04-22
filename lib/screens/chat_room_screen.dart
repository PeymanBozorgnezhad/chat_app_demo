import 'package:chat_app/constants.dart';
import 'package:chat_app/constants_function.dart';
import 'package:chat_app/helper/util_functions.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import '../widgets/custom_drawer.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserModel loggedInUser = UserModel();
  DatabaseMethods databaseMethods = DatabaseMethods();
  late CollectionReference chatRoomRef;

  Widget chatRoomList() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomRef.where('users', arrayContains: kMyName).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Not Exist documents'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              Map data = snapshot.data!.docs[index].data() as Map;
              return ChatRoomsTile(
                userName: data['chatroomId']
                    .toString()
                    .replaceAll('_', "")
                    .replaceAll(kMyName, ""),
                chatRoomId: data['chatroomId'],
              );
            },
          );
        } //
        else {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                Colors.blueGrey,
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    chatRoomRef = firestore.collection('ChatRoom');
    super.initState();
  }

  getUserInfo() async {
    setState(() {});
    kMyName = await UtilFunctions.getUserNameSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(auth: auth, user: user, userModel: loggedInUser),
      appBar: AppBar(
        title: const Text(
          'Chat Room',
        ),
        centerTitle: true,
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        heroTag: 'unique_key',
        onPressed: () => kNavigator(context, 'contact', '-1'),
        child: const Icon(
          Icons.search,
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({required this.userName, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        kNavigator(context, 'conversation', chatRoomId);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.purple.shade200,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                userName.substring(0, 1).toUpperCase(),
                style: kTextStyle.copyWith(fontSize: 15),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              userName,
              style: kTextStyle.copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
