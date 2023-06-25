import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/pages/authentication/authentication.dart';
import 'package:lvlup/pages/authentication/login_page.dart';
import 'package:lvlup/services/firebase/auth.dart';
import 'package:lvlup/pages/authentication/email_verification_page.dart';

class RegisterPage extends Parent {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  ParentState createState() => _RegisterPageState();
}

class _RegisterPageState extends ParentState {
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPasswordConfirmation =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return const Text(
        "Create an account",
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    @override
    Widget submitButton() {
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await Auth().createUserWithEmailAndPassword(
                  email: _controllerEmail.text,
                  password: _controllerPassword.text,
                  passwordConfirmation: _controllerPasswordConfirmation.text,
                  context: context,
                );

                if (Auth().currentUser != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => EmailVerificationScreen(
                            username: _controllerUsername.text),
                      ));
                }
              },
              child: const Text('Register'),
            )
          ]);
    }

    return Scaffold(
      body: Container(
        decoration: bgColour,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title(),
            const SizedBox(
              height: 45.0,
            ),
            entryField('username', _controllerUsername),
            const SizedBox(
              height: 25.0,
            ),
            entryField('email', _controllerEmail),
            const SizedBox(
              height: 25.0,
            ),
            entryField('password', _controllerPassword),
            const SizedBox(
              height: 25.0,
            ),
            entryField('confirm password', _controllerPasswordConfirmation),
            const SizedBox(
              height: 25.0,
            ),
            submitButton(),
            TextButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const LoginPage(),
                      ));
                },
                child: const Text("login instead")),
          ],
        ),
      ),
    );
  }
}
