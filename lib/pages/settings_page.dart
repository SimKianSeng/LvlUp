import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lvlup/services/firebase/auth.dart';

final User? user = Auth().currentUser;

Future<void> signOut() async {
  await Auth().signOut();
}

Widget _signOutButton(BuildContext context) {
  return SizedBox(
    width: 250,
    child: ElevatedButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)))),
      onPressed: () async {
        signOut();
        Navigator.popUntil(context, (route) => route.isFirst);
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
        Auth()
            .sendPasswordResetEmail(email: user?.email ?? "", context: context);
      },
      child: const Text('Reset Password'),
    ),
  );
}

Widget _deleteAccountButton(BuildContext context) {
  return ElevatedButton(
    style: customButtonStyle(color: Colors.redAccent[100]),
    onPressed: () async {
      _deleteAccountConfirmation(context);
    },
    child: const Text('Delete Account'),
  );
}

void _deleteAccountConfirmation(BuildContext context) {
  final TextEditingController controllerPassword = TextEditingController();

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: Column(
            children: [
              const Text("All progress will be lost"),
              TextField(
                decoration: customTextField(initText: 'password'),
                controller: controllerPassword,
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.popUntil(context, (route) => route.isFirst);
                await Auth().deleteUser(password: controllerPassword.text);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
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
