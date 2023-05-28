import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lvlup/constants.dart';
import '../../services/auth.dart';
import 'package:lvlup/pages/authentication/email_verification_page.dart';

class registerPage extends StatefulWidget {
  final Function switchPage;

  const registerPage({required this.switchPage});

  @override
  State<registerPage> createState() => _registerPageState();
}

//TODO: Register page should also ask user for their account name?
//TODO: Ensure that only valid emails are used to create an account
class _registerPageState extends State<registerPage> {
  @override
  Widget build(BuildContext context) {
    String? errorMessage = '';

    final TextEditingController _controllerEmail = TextEditingController();
    final TextEditingController _controllerPassword = TextEditingController();

    // Future<void> createUserWithEmailAndPassword() async {
    //   try {
    //     await Auth().createUserWithEmailAndPassword(
    //       email: _controllerEmail.text,
    //       password: _controllerPassword.text,
    //       context: context,
    //     );
    //   } on FirebaseAuthException catch (e) {
    //     setState(() {
    //       errorMessage = e.message;
    //     });
    //   }
    // }

    Future<User?> createUserWithEmailAndPassword() async {
      try {
        User? user = await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          context: context,
        );
        return user;
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMessage = e.message;
        });
      }
    }

    Widget title() {
      return const Text(
        "Create an account",
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    Widget entryField(
      String title,
      TextEditingController controller,
    ) {
      return TextField(
        controller: controller,
        decoration: customTextField(title),
        obscureText: title == 'password'
            ? true
            : false, //Hide password if textfield is for password
      );
    }

    Widget _errorMessage() {
      return Text(errorMessage == '' ? '' : 'Humm ? $errorMessage');
    }

    // Widget submitButton() {
    //   return ElevatedButton(
    //     onPressed: createUserWithEmailAndPassword,
    //     child: Text('Register'),
    //   );
    // }

    Widget submitButton() {
      return ElevatedButton(
        onPressed: () async {
          await Auth().createUserWithEmailAndPassword(
            email: _controllerEmail.text,
            password: _controllerPassword.text,
            context: context,
          );
          if (Auth().currentUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => const EmailVerificationScreen()),
            );
          }
        },
        child: Text('Register'),
      );
    }

    Widget loginButton() {
      return TextButton(
        onPressed: () {
          setState(() {
            widget.switchPage();
          });
        },
        child: const Text('Login instead'),
      );
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
            entryField('email', _controllerEmail),
            const SizedBox(
              height: 25.0,
            ),
            entryField('password', _controllerPassword),
            _errorMessage(),
            submitButton(),
            loginButton(),
          ],
        ),
      ),
    );
  }
}
