import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_app/screens/LoginRegister/login_screen.dart';
import 'package:weather_app/utils/color_util.dart';
import 'package:weather_app/widgets/reuseable_widgets.dart';

class MyResgiter extends StatefulWidget {
  const MyResgiter({super.key});

  @override
  _MyResgiterState createState() => _MyResgiterState();
}

class _MyResgiterState extends State<MyResgiter> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();

  // Email validation function
  bool isValidEmail(String email) {
    String emailPattern = r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  bool isValidPassword(String password) {
    String passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
    RegExp regExp = RegExp(passwordPattern);
    return regExp.hasMatch(password);
  }

  Future<void> _saveUserToFirestore(String userId, String email, String username) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection("users").doc(userId).set({
      'email': email,
      'username': username,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme:const IconThemeData(
          color: Colors.white
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("041E42"),
              hexStringToColor("0E3386"),
              hexStringToColor("5C73A3")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              reuseableTextFeild(
                "Enter UserName",
                Icons.person_outline,
                false,
                _userNameTextController,
              ),
              const SizedBox(height: 20),
              reuseableTextFeild(
                "Enter Email",
                Icons.person_outline,
                false,
                _emailTextController,
              ),
              const SizedBox(height: 20),
              reuseableTextFeild(
                "Enter Password",
                Icons.lock_outlined,
                true,
                _passwordTextController,
              ),
              const SizedBox(height: 20),
              signInSignUpButton(context, false, () {
                String email = _emailTextController.text;
                String password = _passwordTextController.text;
                String userName = _userNameTextController.text;

                if (email.isEmpty || password.isEmpty || userName.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please fill all fields",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }

                if (!isValidEmail(email)) {
                  Fluttertoast.showToast(
                    msg: "Invalid email format",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }

                if (!isValidPassword(password)) {
                  Fluttertoast.showToast(
                    msg: "Password should be at least 6 characters",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }

                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(email: email, password: password)
                    .then((value) async {
                  String userId = value.user!.uid;

                  // Save user data to Firestore
                  await _saveUserToFirestore(userId, email, userName);

                  Fluttertoast.showToast(
                    msg: "Account Created",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MyLogin()));
                }).onError((error, stackTrace) {
                  Fluttertoast.showToast(
                    msg: "Error ${error.toString()}",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                });
              })
            ],
          ),
        ),
      ),
    );
  }
}
