import 'dart:math';
import 'package:chat_app/constants.dart';
import 'package:chat_app/constants_function.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/chat_room_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDrawer extends StatefulWidget {
  final FirebaseAuth? auth;
  final User? user;
  late UserModel userModel;

  CustomDrawer(
      {required this.auth, required this.user, required this.userModel});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  double value = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user!.uid)
        .get()
        .then((value) {
      widget.userModel = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('*********************************');
    print('image url :${widget.userModel.imageUrl}');
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade800],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter),
            ),
          ),
          Container(
            width: 200.0,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          radius: 40.0,
                          backgroundImage: widget.userModel.imageUrl != null
                              ? NetworkImage(
                                  widget.userModel.imageUrl.toString(),
                                )
                              : null),
                      const SizedBox(
                        height: 10,
                      ),
                      FittedBox(
                        child: Text(
                          widget.user!.email ?? "Not Signed in",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${widget.userModel.username} ${widget.userModel.lastname}',
                        style: kTextStyle.copyWith(
                            color: Colors.white60,
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      /* ListTile(
                        title: const Text('Chat Room', style: kTextStyleDrawer),
                        leading: const Icon(FontAwesomeIcons.rocketchat,
                            color: Colors.white),
                        onTap: () => kNavigator(context, 'chat-room'),
                      ),
                      const Divider(
                        color: Colors.blueGrey,
                        height: 3,
                      ),*/
                      ListTile(
                        title: const Text('Contact', style: kTextStyleDrawer),
                        leading: const Icon(
                          FontAwesomeIcons.addressBook,
                          color: Colors.white,
                        ),
                        onTap: () => kNavigator(context, 'contact','-1'),
                      ),
                      const Divider(
                        color: Colors.white60,
                        height: 1,
                      ),
                      ListTile(
                        title: const Text('Sign Out', style: kTextStyleDrawer),
                        leading: const Icon(
                          FontAwesomeIcons.rightFromBracket,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          await widget.auth!.signOut();
                          kNavigator(context, 'sign-out','-1');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: value),
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
            builder: (_, double val, __) {
              return (Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..setEntry(0, 3, 200 * val)
                  ..rotateY(pi / 6 * val),
                child: const ChatRoomScreen(),
              ));
            },
          ),
          _rightClick(),
        ],
      ),
    );
  }

  Widget _rightClick() {
    return GestureDetector(
      onHorizontalDragUpdate: (e) {
        if (e.delta.dx > 0) {
          setState(() {
            value = 1;
          });
        } else {
          setState(() {
            value = 0;
          });
        }
      },
    );
  }
}
