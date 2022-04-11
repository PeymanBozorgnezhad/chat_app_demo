import 'package:chat_app/constants.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context)=>const ChatRoomScreen(),
                ),
              );
            },
            icon: CircleAvatar(
              child: Image.asset('assets/images/hiring.png'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 110,
                child: Image.asset(
                  'assets/images/log_out.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                'Welcome back',
                style: kTextStyle.copyWith(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${loggedInUser.username} ${loggedInUser.lastname}',
                style: kTextStyle.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              Text(
                '${loggedInUser.email}',
                style: kTextStyle.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
              const SizedBox(
                height: 12,
              ),
              ActionChip(
                padding: const EdgeInsets.all(6),
                backgroundColor: Colors.pinkAccent,
                label: const Text('Logout'),
                onPressed: () => logOut(context),
                avatar: Image.asset('assets/images/logout_icon.png',
                    fit: BoxFit.contain),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginScreen(),
      ),
    );
  }
}
