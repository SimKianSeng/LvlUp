import 'package:flutter/material.dart';
import 'package:lvlup/pages/authentication/login_page.dart';
import 'package:lvlup/pages/authentication/register_page.dart';
import '../../constants.dart';

// TODO: this file can be removed or used for the switching page functionality instead of pushing onto navigator stack
class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool signingIn = true;

  // TODO utilize this in the log in / register page instead of pushing another page?
  void switchPage() {
    setState(() {
      signingIn = !signingIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return signingIn ? const LoginPage() : const RegisterPage();
  }
}

///Supertype of both login and register page, contains shared components
abstract class Parent extends StatefulWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  State<Parent> createState() => ParentState();
}

class ParentState<T extends Parent> extends State<Parent> {
  String? errorMessage = '';

  Widget entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: customTextField(initText: title),
      obscureText: title == 'password' || title == 'confirm password'
          ? true
          : false, //Hide password if textfield is for password
    );
  }

  ///Button to log in or register, to be overriden in child classes
  Widget submitButton() {
    return const Placeholder();
  }

  ///Will be overriden by LoginPage and registerPage respectively
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
