import 'package:flutter/material.dart';
import 'package:lvlup/constants.dart';

class ScheduleGen extends StatefulWidget {
  const ScheduleGen({super.key});

  @override
  State<ScheduleGen> createState() => _ScheduleGenState();
}

class _ScheduleGenState extends State<ScheduleGen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Schedule")),
      body: Container(
        decoration: bgColour,
      ),
    );
  }
}