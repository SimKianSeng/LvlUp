import 'package:flutter/material.dart';

class StudyStats extends StatelessWidget {
  const StudyStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Summary"),
        centerTitle: true,
      ),
    );
  }
}