import 'package:chat_app/screens/conversation_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'screens/chat_room_screen.dart';
import 'screens/login_screen.dart';

kNavigator(BuildContext context, String path, String chatRoomId) {
  if (path == 'contact' || path == 'conversation') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) {
          if (path == 'contact') {
            return const SearchScreen();
          } //
          else if (path == 'conversation') {
            return ConversationScreen(
              chatRoomId: chatRoomId,
            );
          } //
          else {
            return const ChatRoomScreen();
          }
        },
      ),
    );
  } //
  else {
    if (path == 'login-chatroom' || path == 'sign-out') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            if (path == 'login-chatroom') {
              return const ChatRoomScreen();
            } //
            else if (path == 'sign-out') {
              return const LoginScreen();
            } //
            else {
              return const ChatRoomScreen();
            }
          },
        ),
      );
    } //
    else if (path == 'signup-chatroom') {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return const ChatRoomScreen();
        },
      ), (route) => false);
    } //
  }
}

/*
Future<void> kLogOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => const LoginScreen(),
    ),
  );
}
*/
