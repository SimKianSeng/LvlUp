import 'package:lvlup/pages/authentication/authentication.dart';
import 'package:lvlup/pages/authentication/email_verification_page.dart';
import 'package:lvlup/pages/authentication/register_page.dart';
import 'package:lvlup/services/auth.dart';
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

    if (user == null) {
      return Authentication();
    }
    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      //   // return FutureBuilder(
      //   //     future: Auth().deleteUser(),
      //   //     builder: (context, snapshot) {
      //   //       if (snapshot.connectionState == ConnectionState.done) {
      //   //         // return Text("test");
      //   //         return Authentication();
      //   //       }
      //   //       return Text("testing");
      //   //     });

      // return EmailVerificationScreen();

      return RegisterPage();
    }
    // return Authentication();
    return HomePage();
  }
}
