import 'package:chat_app/constants.dart';
import 'package:chat_app/constants_function.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: Center(
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
    );
  }

  //todo : login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (uid) {
          //If the login was successful,Give the user uid
          //Wait for the value to return to be completed and after receiving the result we can use it and perform the next operation
          print('user uid : ${uid.user!.uid}');
          Fluttertoast.showToast(msg: "Login Successful");
          kNavigator(context, 'login-chatroom');
        },
      ).catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });

      /*UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(userCredential);
      print(userCredential.credential);
      print(_auth.currentUser);*/
    }
  }
}
