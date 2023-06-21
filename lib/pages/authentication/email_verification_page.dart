import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lvlup/pages/authentication/register_page.dart';
import 'package:lvlup/services/auth.dart';
import 'package:lvlup/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String username;
  const EmailVerificationScreen({Key? key, required this.username})
      : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  DatabaseReference? dbRef;

  @override
  void initState() {
    super.initState();
    // FirebaseAuth.instance.currentUser?.sendEmailVerification();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
    dbRef = FirebaseDatabase.instance.ref().child('users');
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      // isEmailVerified =
      //     FirebaseAuth.instance.currentUser?.emailVerified ?? false;
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // TODO: implement your code after email verification
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));
      Map<String, dynamic> contact = {
        FirebaseAuth.instance.currentUser!.uid: {
          'username': widget.username,
          'characterName': "default",
          'tierName': "Noob",
          'xp': 0,
          'evoState': 0,
          'evoImage': "default",
        }
      };
      // DatabaseReference userRef = dbRef.child("users").push();

      dbRef!.update(contact).whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => HomePage(),
          ),
        );
      });
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () async {
              timer?.cancel();
              await Auth().deleteUser();
              // Navigator.pop(context);
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => RegisterPage(),
                  ));
            },
          ),
          title: Text("Verify email"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Check your \n Email',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'We have sent you a Email on  ${Auth().currentUser?.email}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Verifying email....',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  child: const Text('Resend'),
                  onPressed: () {
                    try {
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
