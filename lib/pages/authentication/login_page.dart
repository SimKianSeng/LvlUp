import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/pages/authentication/authentication.dart';
import '../../services/auth.dart';

class LoginPage extends parent {
  LoginPage(switchPage) : super(switchPage: switchPage);

  @override
  parentState createState() => _LoginPageState();
}

class _LoginPageState extends parentState {
  bool loading = false;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        loading = false;
      });
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  @override
  Widget submitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
              signInWithEmailAndPassword();
              loading = true;
          },
          child: const Text('Log in'),
        ),
        loading ? CircularProgressIndicator() : SizedBox(width: 0.0,),
      ],
    );
  }

  Widget forgotPasswordButton() {
  return Container(
    height: 45.0,
    child: TextButton(
        onPressed: () async {
          await Auth().sendPasswordResetEmail(email: _controllerEmail.text, context: context);
        },
        child: const Text('Forgot password'),
    ),
  );
}

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: bgColour,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
              child: SizedBox(
                width: 500.0, height: 150.0,
                child: Image.asset("assets/AppTitle.png"),
              ),
            ),
            entryField('email', _controllerEmail),
            const SizedBox(height: 25.0,),
            entryField('password', _controllerPassword),
            _errorMessage(),
            submitButton(),
            forgotPasswordButton(),
            switchButton("Register instead"),
          ],
        ),
      ),
    );
  }
}
