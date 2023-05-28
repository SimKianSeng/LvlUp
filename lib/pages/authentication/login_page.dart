import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lvlup/constants.dart';
import '../../services/auth.dart';

class LoginPage extends StatefulWidget {
  final Function switchPage;
  
  const LoginPage({required this.switchPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';

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
      });
    }
  }

  Widget entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: customTextField(title),
      obscureText: title == 'password' ? true : false, //Hide password if textfield is for password
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed:
          signInWithEmailAndPassword,
      child: const Text('Log in'),
    );
  }

  Widget registerButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          widget.switchPage();
        });
      },
      child: const Text('Register instead'),
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
            registerButton(),
          ],
        ),
      ),
    );
  }
}
