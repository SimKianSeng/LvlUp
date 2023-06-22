import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';

class StudyStats extends StatelessWidget {
  const StudyStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Summary"),
        centerTitle: true,
      ),
      body: Container(
        decoration: bgColour,
        child: Center(child: Text('Coming soon'),),
      ),
    );
  }
}