import 'package:chat_app/constants.dart';
import 'package:chat_app/constants_function.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../helper/util_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  DatabaseMethods databaseMethods = DatabaseMethods();
  late QuerySnapshot<Map<String, dynamic>> snapShotUserInfo;

  // QuerySnapshot<Map<String, dynamic>>? snapShotUserInfo;
  // late QuerySnapshot<Map<String, dynamic>> searchSnapShot;

  //todo : form key
  final _formKey = GlobalKey<FormState>();

  //todo : editing controller
  late TextEditingController emailController;
  late TextEditingController passwordController;

  //todo -----------Obscure------------
  bool _isObscure = true;

  //todo : initialized :: firebase
  final _auth = FirebaseAuth.instance;

  void _toggle() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    if (user != null) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () => kNavigator(context, 'login-chatroom','-1'),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //todo : email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
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
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kDecoration,
    );
    //todo : password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      validator: (value) {
        //Requires the user to enter at least 6 characters
        RegExp regExp = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required to login");
        }
        if (!regExp.hasMatch(value)) {
          return ("Enter Valid Password\n(Min. 6 characters)");
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: kDecoration.copyWith(
        prefixIcon: const Icon(Icons.vpn_key),
        hintText: "Password",
        suffixIcon: IconButton(
          onPressed: _toggle,
          icon: Icon(
            _isObscure ? Icons.visibility_off_sharp : Icons.visibility_sharp,
          ),
        ),
      ),
      obscureText: _isObscure,
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => signIn(emailController.text, passwordController.text),
        child: Text(
          'Login',
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
                          'assets/images/sign_in.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      emailField,
                      const SizedBox(
                        height: 25,
                      ),
                      passwordField,
                      const SizedBox(
                        height: 35,
                      ),
                      loginButton,
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const RegistrationScreen(),
                                ),
                              );
                            },
                            child: Text(
                              ' SignUp',
                              style: kTextStyle.copyWith(
                                  fontSize: 15, color: Colors.redAccent),
                            ),
                          ),
                        ],
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

  //todo : login function
  void signIn(String email, String password) async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      UtilFunctions.saveEmailSharedPref(email);

      setState(() {
        isLoading = true;
      });
      // UtilFunctions.saveUserNameSharedPref(username);===>>not access
      //In the login section, because we do not have access to the username,
      // and since our login operation is based on email and password,
      // to save the name in the local database,
      // we must run a query to firestore based on the email we have,
      // and after the email with The previously registered email matched (when it goes into the then function if the desired blindness is correct)
      // it must then store the resulting username in the local database, which returns a value that is QuerySnapShot.
      //TODO ==>> function get user detail==>>same is name
      databaseMethods.getUserByEmail(email).then((value) {
        snapShotUserInfo = value;
        Map<String, dynamic> docSnap = snapShotUserInfo.docs[0].data();
        UtilFunctions.saveUserNameSharedPref(docSnap['username']).then((value) {
          if (value == true) {
        print('#############################################');
            print('saved username in sharedPref');
          }
        });
      });

      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (uid) {
          //If the login was successful,Give the user uid
          //Wait for the value to return to be completed and after receiving the result we can use it and perform the next operation
          print('user uid : ${uid.user!.uid}');
          Fluttertoast.showToast(msg: "Login Successful");
          UtilFunctions.saveUserLoggedInSharedPref(true);
          kNavigator(context, 'login-chatroom','-1');
        },
      ).catchError((e) {
        resetValues();
        Fluttertoast.showToast(msg: e!.message);
      });

      /*UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(userCredential);
      print(userCredential.credential);
      print(_auth.currentUser);*/
    }
  }

  void resetValues() {
    setState(() {
      isLoading = false;
    });
  }
}
