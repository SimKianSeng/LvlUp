import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';
import '../services/auth.dart';

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        signOut();
        Navigator.pop(context);
      },
      child: const Text('Sign Out'),
    );
  }

  Widget _resetPasswordButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Reset Password'),
    );
  }

  Widget _deleteAccountButton() {
    return ElevatedButton(
      onPressed: () {},
      child: const Text('Delete Account'),
    );
  }

class Settings extends StatelessWidget {
  const Settings({super.key});

//TODO Implement reset pwd and delete account option
//TODO Fix the UI
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _resetPasswordButton(),
            _deleteAccountButton(),
          ],
        ),
      ),
      floatingActionButton: _signOutButton(context),
    );
  }
}