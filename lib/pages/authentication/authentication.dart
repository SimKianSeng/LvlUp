import 'package:flutter/material.dart';
import 'package:lvlup/pages/authentication/login_page.dart';
import 'package:lvlup/pages/authentication/register_page.dart';

class authentication extends StatefulWidget {
  const authentication({super.key});

  @override
  State<authentication> createState() => _authenticationState();
}


class _authenticationState extends State<authentication> {
  bool signingIn = true;

  void switchPage() {
    setState(() {
      signingIn = !signingIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return signingIn ? LoginPage(switchPage: switchPage) : registerPage(switchPage: switchPage);
  }
}