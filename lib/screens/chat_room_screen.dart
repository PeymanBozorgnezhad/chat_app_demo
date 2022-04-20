import 'package:chat_app/constants.dart';
import 'package:chat_app/constants_function.dart';
import 'package:chat_app/helper/util_functions.dart';
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
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    setState(() {
    });
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'unique_key',
        onPressed: () => kNavigator(context, 'contact','-1'),
        child: const Icon(
          Icons.search,
        ),
      ),
    );
  }
}
