import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lvlup/models/app_user.dart';
import 'package:lvlup/pages/authentication/register_page.dart';
import 'package:lvlup/services/auth.dart';
import 'package:lvlup/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lvlup/services/database_service.dart';

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
  // DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('users');

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));
      Map<String, dynamic> contact = {
        FirebaseAuth.instance.currentUser!.uid: AppUser.newUser(username: widget.username).toJson()
      };

      DatabaseService.createUser(contact).whenComplete(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const HomePage(),
          ),
        );
      });
      timer?.cancel();
    }
  }

  @override
  void dispose() {
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
                    builder: (ctx) => const RegisterPage(),
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
