import 'dart:io';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isLoading = false;
  File? _userImageFile;

  // File? _userImageFile = File('-1');

  //todo : our formKey
  final _formKey = GlobalKey<FormState>();

  //todo : editing controller
  final firstNameEditingController = TextEditingController();
  final lastNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  //todo : initialized :: Firebase
  final _auth = FirebaseAuth.instance;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    //todo : image profile
    /*const imageProfile = CircleAvatar(
      radius: 40,
    );*/

    /* final textButton = TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.image),
      label: const Text(
        'Add Image',
      ),
    );*/

    //todo : first name field
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        //Requires the user to enter at least 3 characters
        RegExp regExp = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("First Name can\'t be Empty");
        }
        if (!regExp.hasMatch(value)) {
          return ("Enter Valid name(Min. 3 characters)");
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kDecoration.copyWith(
        prefixIcon: const Icon(Icons.account_circle),
        hintText: 'First Name',
      ),
    );
    //todo : last name field
    final lastNameField = TextFormField(
      autofocus: false,
      controller: lastNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Last Name can\'t be Empty");
        }
        return null;
      },
      onSaved: (value) {
        lastNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kDecoration.copyWith(
        prefixIcon: const Icon(Icons.account_circle),
        hintText: 'Last Name',
      ),
    );
    //todo : email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter Your Email");
        }
        //reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kDecoration.copyWith(
        prefixIcon: const Icon(Icons.mail),
        hintText: 'Email',
      ),
    );
    //todo : password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        //Requires the user to enter at least 6 characters
        RegExp regExp = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required to SignUp");
        }
        if (!regExp.hasMatch(value)) {
          return ("Enter Valid Password\n(Min. 6 characters)");
        }
        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kDecoration.copyWith(
        prefixIcon: const Icon(Icons.vpn_key),
        hintText: 'Password',
      ),
    );
    //todo : confirm password field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (passwordEditingController.text != value) {
          return ("Password don\'t match");
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: kDecoration.copyWith(
        prefixIcon: const Icon(Icons.vpn_key),
        hintText: 'Confirm Password',
      ),
    );
    //todo : SignUp Button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => signUp(emailEditingController.text,
            passwordEditingController.text, _userImageFile),
        child: Text(
          'SignUp',
          textAlign: TextAlign.center,
          style: kTextStyle.copyWith(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.red,
          ),
        ),
      ),
      body: ModalProgressHUD(
        progressIndicator: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
        inAsyncCall: isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 250,
                        child: Image.asset(
                          'assets/images/sign_up.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      UserImagePicker(
                        imagePickFn: (File pickedImage) {
                          _pickedImage(pickedImage);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      firstNameField,
                      const SizedBox(
                        height: 20,
                      ),
                      lastNameField,
                      const SizedBox(
                        height: 20,
                      ),
                      emailField,
                      const SizedBox(
                        height: 20,
                      ),
                      passwordField,
                      const SizedBox(
                        height: 20,
                      ),
                      confirmPasswordField,
                      const SizedBox(
                        height: 20,
                      ),
                      signUpButton,
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password, File? image) async {
    final isValid = _formKey.currentState!.validate();
    if (_userImageFile == null || image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      setState(() {
        isLoading = true;
      });
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        //resetValues();
        postDetailToFirestore(image);
      }).catchError((e) {
        resetValues();
        print('sth went wrong');
        Fluttertoast.showToast(msg: e.toString());
      });
    }
  }

  void resetValues() {
    setState(() {
      isLoading = false;
    });
  }

  void postDetailToFirestore(File? image) async {
    //calling our Firestore
    //calling our user model
    //sending these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    String filename = image!.path.split('/').last;

    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child('users/images/$filename')
        .putFile(image);

    String url = await taskSnapshot.ref.getDownloadURL();

    //writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.username = firstNameEditingController.text;
    userModel.lastname = lastNameEditingController.text;
    userModel.imageUrl = url;

    Map<String, dynamic> newMap = userModel.toMap();
    await firebaseFirestore.collection('users').doc(user.uid).set(newMap).then(
          (_) => Fluttertoast.showToast(msg: "Account created successfully :)"),
        );
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return const HomeScreen();
      },
    ), (route) => false);
  }
}
