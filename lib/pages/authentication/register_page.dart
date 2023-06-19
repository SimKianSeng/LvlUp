import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:lvlup/pages/authentication/authentication.dart';
import 'package:lvlup/pages/authentication/login_page.dart';
import '../../services/auth.dart';
import 'package:lvlup/pages/authentication/email_verification_page.dart';

class RegisterPage extends Parent {
  RegisterPage({Key? key}) : super(key: key);

  @override
  ParentState createState() => _RegisterPageState();
}

//TODO: Register page should also ask user for their account name?
//TODO: Ensure that only valid emails are used to create an account
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
              child: Text('Register'),
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
            submitButton(),
            ElevatedButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => LoginPage(),
                      ));
                },
                child: Text("login instead")),
          ],
        ),
      ),
    );
  }
}
