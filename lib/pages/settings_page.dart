import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import '../services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

final User? user = Auth().currentUser;

Future<void> signOut() async {
  await Auth().signOut();
}

Widget _signOutButton(BuildContext context) {
  return ElevatedButton(
    style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)))),
    onPressed: () async {
      signOut();
      Navigator.pop(context);
    },
    child: const Text('Sign Out'),
  );
}

Widget _resetPasswordButton() {
  return SizedBox(
    width: 250.0,
    child: ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)))),
      onPressed: () {
        Auth().sendPasswordResetEmail(email: user?.email ?? "");
        print("Email sent");
      },
      child: const Text('Reset Password'),
    ),
  );
}

Widget _deleteAccountButton(BuildContext context) {
  return SizedBox(
    width: 250.0,
    child: ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)))),
      onPressed: () async {
        await Auth().deleteUser();
        print("Deleted account");
        Navigator.pop(context);
      },
      child: const Text('Delete Account'),
    ),
  );
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        decoration: bgColour,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _resetPasswordButton(),
            SizedBox(
              width: double.infinity,
              height: 50.0,
            ),
            _deleteAccountButton(context),
          ],
        ),
      ),
      floatingActionButton: _signOutButton(context),
    );
  }
}
