import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/pages/authentication/authentication.dart';
// import 'package:lvlup/pages/authentication/email_verification_page.dart';
import 'package:lvlup/pages/authentication/register_page.dart';
// import 'package:lvlup/services/auth.dart';
import 'package:lvlup/pages/home/home_page.dart';
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
    final user = Provider.of<AppUser?>(context);

    if (user == null) {
      return const Authentication();
    }
    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      return const RegisterPage();
    }
    
    return const HomePage();
  }
}
