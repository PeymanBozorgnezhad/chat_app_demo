import 'package:flutter/material.dart';

final kDecoration = InputDecoration(
  prefixIcon: const Icon(Icons.mail),
  contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
  hintText: "Email",
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
);
const kTextStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black);

InputDecoration kTextFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      /* focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black54)),*/
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.pink)));
}

// const kBackgroundColorDecoration = Color(0x542F2929);
const kBackgroundColorDecoration = Color(0x8F972B97);

const kTxtStyleSearchResult = TextStyle(
  color: Colors.white70,
  fontSize: 15,
  fontWeight: FontWeight.w400,
);

const kTextStyleDrawer = TextStyle(color: Colors.black87);
