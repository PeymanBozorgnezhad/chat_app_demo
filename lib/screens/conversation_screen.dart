import 'package:bubble/bubble.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen({required this.chatRoomId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController sendMessageController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late CollectionReference messagesRef;
  ScrollController scrollController = ScrollController();

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: messagesRef
          .orderBy('date', descending: true)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Item found'),
            );
          }
          final snapShotData = snapshot.data;
          return ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            reverse: true,
            controller: scrollController,
            children: snapShotData!.docs.map(
              (doc) {
                String id = doc.id;
                Map data = doc.data() as Map;
                bool isMe = data['sendBy'] == firebaseAuth.currentUser!.uid;
                bool ismE = data['sendBy'] == kMyName;
                return GestureDetector(
                  onTap: () {},
                  child: Bubble(
                    color: (isMe) ? kThemeSenderColor : Colors.white,
                    nip: (isMe) ? BubbleNip.rightTop : BubbleNip.leftTop,
                    alignment: (isMe) ? Alignment.topRight : Alignment.topLeft,
                    margin: BubbleEdges.only(
                      top: 10.0,
                      left: (isMe) ? 15.0 : 0.0,
                      right: (!isMe) ? 15.0 : 0.0,
                    ),
                    child: Text(
                      '${data['message']}',
                    ),
                  ),
                );
              },
            ).toList(),
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

  sendMessage() {
    String dateTime = DateTime.now().toString();
    String date = dateTime.substring(0, 10);
    String time = dateTime.substring(11, 19);
    if (sendMessageController.text.isNotEmpty) {
      Map<String, String> messageMap = {
        'message': sendMessageController.text,
        'sendBy': kMyName,
        'date': date,
        'time': time,
      };
      databaseMethods.addConversationMessage(
          chatRoomId: widget.chatRoomId, messageMap: messageMap);
      sendMessageController.clear();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messagesRef = firestore
        .collection('ChatRoom')
        .doc(widget.chatRoomId)
        .collection('chats');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logo.png",
          height: 40,
        ),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.purple.shade400,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: sendMessageController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      minLines: 1,
                      maxLines: 5,
                      decoration:
                          kTextFieldInputDecoration('Type Here...').copyWith(
                        hintStyle: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x36FFFFFF),
                            Color(0x0FFFFFFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Image.asset(
                        'assets/images/send.png',
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
