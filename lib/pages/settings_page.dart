import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

//TODO Implement back arrow key, sign out, reset pwd and delete account option
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7B5EFE),
              Color(0xFFB88CED),
              Color(0xFFCF9EE7),
              Color(0xFFE4AEE1),
            ]
            ),
        ),
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}