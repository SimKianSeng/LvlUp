import 'package:flutter/material.dart';
import 'package:lvlup/pages/authentication/login_page.dart';
import 'package:lvlup/pages/authentication/register_page.dart';
import '../../constants.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}


class _AuthenticationState extends State<Authentication> {
  bool signingIn = true;

  void switchPage() {
    setState(() {
      signingIn = !signingIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return signingIn ? LoginPage(switchPage) : RegisterPage(switchPage);
  }
}

///Supertype of both login and register page, contains shared components
abstract class parent extends StatefulWidget {
  final Function switchPage;

  const parent({required this.switchPage});

  @override
  State<parent> createState() => parentState();
}

class parentState<T extends parent> extends State<parent> {
  String? errorMessage = '';

  Widget entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: customTextField(title),
      obscureText: title == 'password' || title == 'confirm password'
          ? true
          : false, //Hide password if textfield is for password
    );
  }

  ///Button to log in or register, to be overriden in child classes
  Widget submitButton() {
    return const Placeholder();
  }

  Widget switchButton(String text) {
    return TextButton(
      onPressed: () {
        setState(() {
          widget.switchPage();
        });
      },
      child: Text(text),
    );
  }

  ///Will be overriden by LoginPage and registerPage respectively
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}