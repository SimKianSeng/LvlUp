import 'package:lvlup/pages/authentication/authentication.dart';
import 'package:lvlup/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  /// Return either home or login page depending on authentication status
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    //TODO obtain user profile from realtime database based on uuid

    return user == null ? const Authentication() : HomePage();
  }
}
