import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import '../services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

final User? user = Auth().currentUser;

Future<void> signOut() async {
  await Auth().signOut();
}

Widget _signOutButton(BuildContext context) {
  return SizedBox(
    width: 250,
    child: ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)))),
      onPressed: () async {
        signOut();
        Navigator.pop(context);
      },
      child: const Text('Sign Out'),
    ),
  );
}

Widget _resetPasswordButton(BuildContext context) {
  return SizedBox(
    width: 250.0,
    child: ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)))),
      onPressed: () {
        Auth().sendPasswordResetEmail(email: user?.email ?? "", context: context);
        
        print("Email sent");
      },
      child: const Text('Reset Password'),
    ),
  );
}

Widget _deleteAccountButton(BuildContext context) {
  return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.redAccent[100]),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)))),
      onPressed: () async {
        _deleteAccountConfirmation(context);
      },
      child: const Text('Delete Account'),
  );
}

void _deleteAccountConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Delete Account"),
        content: const Text("All progress will be lost"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
              await Auth().deleteUser();
              print("Deleted account");
            },
            child: const Text("Yes"),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),),
        ],
      );
    });
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
            _resetPasswordButton(context),
            const SizedBox(
              width: double.infinity,
              height: 50.0,
            ),
            _signOutButton(context),
          ],
        ),
      ),
      floatingActionButton: _deleteAccountButton(context),
    );


  }
}
