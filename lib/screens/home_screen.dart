import 'package:chat_app/constants.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(auth: auth, user: user, userModel: loggedInUser),
      appBar: AppBar(
        title: const Text(
          'Welcome',
        ),
        centerTitle: true,
      ),
      /*body: Center(
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
      ),*/
    );
  }
}
